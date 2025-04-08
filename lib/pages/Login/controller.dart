import 'package:chat/common/entities/user.dart';
import 'package:chat/common/routes/names.dart';
import 'package:chat/common/store/user.dart';
import 'package:chat/common/widgets/toast.dart';
import 'package:chat/pages/Login/state.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';

GoogleSignIn googleSignIn = GoogleSignIn(scopes: <String>['openid']);

class SignInController extends GetxController {
  final state = SignInState();
  SignInController();
  final db = FirebaseFirestore.instance;

  Future<void> handleSignIn() async {
    try {
      var user = await googleSignIn.signIn();
      if (user != null) {
        final _gAuthentication = await user.authentication;
        final _credentials = GoogleAuthProvider.credential(
          idToken: _gAuthentication.idToken,
          accessToken: _gAuthentication.accessToken,
        );
        await FirebaseAuth.instance.signInWithCredential(_credentials);
        // Obtain the auth details from the request
        String displayName = user.displayName ?? user.email;
        String email = user.email;
        String id = user.id;
        String photoUrl = user.photoUrl ?? '';

        UserLoginResponseEntity userProfile = UserLoginResponseEntity(
          email: email,
          accessToken: id,
          displayName: displayName,
          photoUrl: photoUrl,
        );

        // Save user profile locally
        UserStore.to.saveProfile(userProfile);

        // Check if user exists in Firestore
        var userBase = await db
            .collection("users")
            .withConverter(
              fromFirestore: UserData.fromFirestore,
              toFirestore: (UserData userData, options) =>
                  userData.toFirestore(),
            )
            .where("id", isEqualTo: id)
            .get();

        if (userBase.docs.isEmpty) {
          // Create a new user entry in Firestore
          final data = UserData(
            id: id,
            name: displayName,
            email: email,
            photourl: photoUrl,
            location: "",
            fcmtoken: "",
            addtime: Timestamp.now(),
          );

          await db
              .collection("users")
              .withConverter(
                fromFirestore: UserData.fromFirestore,
                toFirestore: (UserData userData, options) =>
                    userData.toFirestore(),
              )
              .add(data);
        }
        toastInfo(msg: "Login Success");
        Get.offAndToNamed(AppRoutes.APPLICATION);
      }
    } catch (e) {
      toastInfo(msg: "Login Error");
      print(e);
    }
  }

  @override
  void onReady() {
    super.onReady();
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (user == null) {
        print("User is currently log out");
      } else {
        print("User Logged In");
      }
    });
  }
}
