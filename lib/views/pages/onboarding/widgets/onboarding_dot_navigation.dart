import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import '../../../controllers/onboarding/onboarding_controller.dart';

class OnBoardingDotNavigation extends StatelessWidget {
  const OnBoardingDotNavigation({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    // Use Get.find to access the OnBoardingController instance
    final controller = Get.find<OnBoardingController>();

    return Positioned(
      bottom: kBottomNavigationBarHeight + 25,
      left: 154,
      child: SmoothPageIndicator(
        count: 3,
        controller: controller.pageController,
        effect: const ExpandingDotsEffect(
          activeDotColor: Color.fromARGB(255, 194, 4, 4),
          dotHeight: 6,
        ),
      ),
    );
  }
}
