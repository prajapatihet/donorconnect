import 'package:flutter/material.dart';
import 'package:get/get.dart';


class OnBoardingPage extends StatelessWidget {
  const OnBoardingPage({
    super.key,
    required this.image,
    required this.title,
    required this.subtitle,
  });

  final String image, title, subtitle;

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            Image(
              width:double.infinity,
              height: 500,
              image: AssetImage(image),
            ),
            Text(
              title,
              style: Theme
                  .of(context)
                  .textTheme
                  .headlineMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            Text(
              subtitle,
              style: Theme
                  .of(context)
                  .textTheme
                  .bodyMedium,
              textAlign: TextAlign.center,
            ),
          ],
        )
    );
  }
}