
import 'package:flutter/material.dart';

import '../../../controllers/onboarding/onboarding_controller.dart';

class OnBoardingSkip extends StatelessWidget {
  const OnBoardingSkip({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
        bottom: 60,
        left: 24,
        child: TextButton(
          onPressed: () => OnBoardingController.instance.skipPage(),
          child: Text('Skip', style: TextStyle(
                        color: Theme.of(context).colorScheme.onSurface,
                        fontWeight: FontWeight.bold,
                        fontSize: 16
                      ), ),
        ));
  }
}
