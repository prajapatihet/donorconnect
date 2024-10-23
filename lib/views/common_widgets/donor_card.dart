import 'package:donorconnect/Utils/constants/images_string.dart';
import 'package:donorconnect/views/common_widgets/rounded_conatiner.dart';
import 'package:donorconnect/views/common_widgets/rounded_image.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

class TDonorCardHorizontal extends StatelessWidget {
  const TDonorCardHorizontal({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 370,
      padding: const EdgeInsets.all(1),
      decoration: BoxDecoration(

        borderRadius: BorderRadius.circular(16),
        color:const Color.fromARGB(255, 250, 237, 237),
      ),
      child: Row(
        children: [
          ///Thumbnail
          const TRoundedContainer(
            height: 120,
            padding: EdgeInsets.all(8),
            backgroundColor:Color.fromARGB(255, 236, 225, 225),
            child:  Stack(
              children: [
                /// --- Thumbnail Image
                SizedBox(
                  height:170,
                    width: 100,
                    child: TRoundedImage(imageUrl: TImages.onBoardingImage1,applyImageRadius: true,),
                ),
              ],
            ),
          ),
            SizedBox(width: 20,),
          /// Details
           SizedBox(
            width: 172,
            child: Padding(
              padding:  const EdgeInsets.only(top: 8,left: 8),
              child: Column(
                children: [
                   Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      backgroundColor: Theme.of(context).colorScheme.primary,
                      padding: const EdgeInsets.fromLTRB(40, 10, 40, 15),
                    ),
                        onPressed: (){}, child: Text('Book Now', style: TextStyle(
                        color: Theme.of(context).colorScheme.onPrimary,
                        fontWeight: FontWeight.bold,
                      ),))
                    ],
                  ),


                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
