import 'package:donorconnect/views/pages/onboarding/widgets/onboarding_dot_navigation.dart';
import 'package:donorconnect/views/pages/onboarding/widgets/onboarding_next_button.dart';
import 'package:donorconnect/views/pages/onboarding/widgets/onboarding_skip.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../Utils/constants/images_string.dart';
import '../../../Utils/constants/text_string.dart';
import '../../controllers/onboarding/onboarding_controller.dart';
import 'widgets/onboarding_page.dart';


class OnBoardingScreen extends StatelessWidget {
  const OnBoardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(OnBoardingController());

    return Scaffold(
      body: Stack(
        children: [
          /// Horizontal Scrollable Pages
          PageView(
            controller: controller.pageController,
            onPageChanged: controller.updatePageIndicator,
            children: const [
              OnBoardingPage(
                  image: TImages.onBoardingImage1,
                  title: TTexts.onBoardingTitle1,
                  subtitle:TTexts.onBoardingSubTitle1,
              ),
              OnBoardingPage(
                  image: TImages.onBoardingImage2,
                  title: TTexts.onBoardingTitle2,
                  subtitle:TTexts.onBoardingSubTitle2,
              ),
              OnBoardingPage(
                  image: TImages.onBoardingImage3,
                  title: TTexts.onBoardingTitle3,
                  subtitle:TTexts.onBoardingSubTitle3,
              ),
            ],
        ),

      /// Skip Button
        const OnBoardingSkip(),

      /// Dot Navigation SmoothPageIndicator
          const OnBoardingDotNavigation(),

      /// Circular Button
          const OnBoardingNextButton(),
        ],
      ),
    );
  }
}
