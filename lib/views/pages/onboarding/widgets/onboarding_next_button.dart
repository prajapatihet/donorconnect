import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import '../../../controllers/onboarding/onboarding_controller.dart';

class OnBoardingNextButton extends StatelessWidget {
  const OnBoardingNextButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {

    return Positioned(
        right: 24,
        bottom: kBottomNavigationBarHeight,
        child: ElevatedButton(
          onPressed:() => OnBoardingController.instance.nextPage(),
          style: ElevatedButton.styleFrom(shape: const CircleBorder(), backgroundColor:  Color.fromARGB(255, 194, 4, 4),) ,
          child: const Icon(Iconsax.arrow_right_3,color: Colors.white,) ,
        )
    );
  }
}
