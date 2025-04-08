import 'package:chat/common/utils/Colors.dart';
import 'package:chat/pages/welcome/controller.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

class WelcomePage extends GetView<WelcomeController> {
  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Obx(
        () => SizedBox(
          // 360.w * 780.w
          width: double.infinity,
          height: double.infinity,
          child: Stack(
            alignment: AlignmentDirectional.bottomCenter,
            children: [
              PageView(
                scrollDirection: Axis.horizontal,
                reverse: false,
                onPageChanged: (index) {
                  controller.changePage(index);
                },
                controller: PageController(
                    initialPage: 0, keepPage: false, viewportFraction: 1.0),
                pageSnapping: true,
                physics: const ClampingScrollPhysics(),
                children: [
                  Container(
                    width: double.infinity,
                    height: double.infinity,
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                        fit: BoxFit.contain,
                        image: AssetImage("assets/splash/banner1.png"),
                      ),
                    ),
                  ),
                  Container(
                    width: double.infinity,
                    height: double.infinity,
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                        fit: BoxFit.contain,
                        image: AssetImage("assets/splash/banner2.png"),
                      ),
                    ),
                  ),
                  Container(
                    width: double.infinity,
                    height: double.infinity,
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                        fit: BoxFit.contain,
                        image: AssetImage("assets/splash/banner3.png"),
                      ),
                    ),
                    child: Stack(children: [
                      Positioned(
                        bottom: 90,
                        right: 50,
                        left: 50,
                        child: ElevatedButton(
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all(
                              AppColors.primaryColor,
                            ),
                          ),
                          onPressed: () {
                            controller.handlesSignin();
                          },
                          child: Text(
                            "Login",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                            ),
                          ),
                        ),
                      ),
                    ]),
                  ),
                ],
              ),
              Positioned(
                bottom: 50,
                child: DotsIndicator(
                  dotsCount: 3,
                  position: controller.state.index.value.toDouble(),
                  decorator: DotsDecorator(
                    activeColor: AppColors.primaryColor,
                    color: AppColors.secondaryColor,
                    size: const Size.square(9.0),
                    activeSize: const Size(18.0, 9.0),
                    activeShape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5.0)),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
