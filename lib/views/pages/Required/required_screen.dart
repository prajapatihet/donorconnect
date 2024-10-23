import 'package:donorconnect/views/common_widgets/donor_card.dart';
import 'package:donorconnect/views/pages/Required/widgets/choice_chip.dart';
import 'package:flutter/material.dart';

class RequiredScreen extends StatelessWidget {
  const RequiredScreen({super.key,});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pick Your Blood'),
        actions: const [
          Chip(
            label: Icon(Icons.question_mark),
            shape: CircleBorder(eccentricity: BorderSide.strokeAlignCenter),
          )
        ],
      ),
      body: Column(
              children: [
                const ChipApp(),

                const SizedBox(height: 30,),
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 0, 180, 0),
                  child: Text('Available Donner',style: TextStyle(
                          fontSize: 20,
                          color: Theme.of(context).colorScheme.onSurface,
                          fontWeight: FontWeight.bold,
                        ),),
                ),
                const SizedBox(height: 20),
                const TDonorCardHorizontal(),
                const SizedBox(height: 20,),
                const TDonorCardHorizontal(),
                const SizedBox(height: 20,),
                const TDonorCardHorizontal()
              ],
            )
        
      );

  }
}
