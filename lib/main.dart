import 'package:chat/common/routes/pages.dart';
import 'package:chat/common/store/config.dart';
import 'package:chat/common/store/user.dart';
import 'package:chat/common/utils/Colors.dart';
import 'package:chat/firebase_options.dart';
import 'package:chat/common/services/storage.dart'; // ✅ Import StorageService
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart'; // ✅ Fixed import for GetMaterialApp

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // ✅ Initialize Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // ✅ Initialize StorageService (SharedPreferences)
  await Get.putAsync<StorageService>(() => StorageService().init());
  Get.put<ConfigStore>(ConfigStore());
  // Register UserStore before app starts
  Get.put<UserStore>(UserStore()); // Ensure it's registered

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      builder: (BuildContext context, Widget? child) => GetMaterialApp(
        color: Colors.white,
        debugShowCheckedModeBanner: false, // ✅ Hide debug banner
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: AppColors.primarySwatch,
        ),
        initialRoute: AppPages.INITIAL,
        getPages: AppPages.routes,
      ),
    );
  }
}
