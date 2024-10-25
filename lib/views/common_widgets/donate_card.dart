import 'package:donorconnect/Utils/constants/images_string.dart';
import 'package:donorconnect/views/common_widgets/rounded_conatiner.dart';
import 'package:donorconnect/views/common_widgets/rounded_image.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

class TDonateCardHorizontal extends StatelessWidget {
  const TDonateCardHorizontal({super.key});

  @override
  Widget build(BuildContext context) {
    return             Container(
              // color: Colors.red,
              // decoration: BoxDecoration(border: Border.all(color: Colors.black)),
            child: Padding(
              padding: EdgeInsets.fromLTRB(10, 20, 10,  360),
              child: Card(
                clipBehavior: Clip.hardEdge,
                child: InkWell(
                   splashColor: Colors.blue.withAlpha(30),
                   child: SizedBox(
              width: 300,
              height: 200,
              child:Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
            
                 const Padding(
                  padding: EdgeInsets.all(15),
                   child: CircleAvatar(child: Icon(Iconsax.user,size: 30,),
                                   ),
                 ),
                
                const Padding(
                   padding: EdgeInsets.fromLTRB(5, 5, 50, 0),
                  child: Text('Oliver James',style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold),)),
                const Padding(
                  padding: EdgeInsets.fromLTRB(5, 5, 50, 0),
                  child: Text('working Professional 21 year old having problem of low RBC ')),
                        const Padding(
                          padding: EdgeInsets.all(10),
                          child: Chip(
                                     backgroundColor: Color.fromARGB(255, 246, 177, 172), 
                                     label: Text('7 min ago',style: TextStyle(color: Color.fromARGB(255, 189, 20, 152)),),
                                     
                                    ),
                        ),

                        Row(
                          children: [
                            const Icon(Icons.location_pin,size: 40),
                            SizedBox(width: 10),
                            const Text('Chandigarh'),
                              SizedBox(width: 60),
                            TextButton(
                              style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      backgroundColor: Theme.of(context).colorScheme.primary,
                      padding: const EdgeInsets.fromLTRB(30, 10, 30, 15),
                    ),
                              onPressed: (){}, child: Text(textAlign: TextAlign.right ,'Donate', style: TextStyle(
                        color: Theme.of(context).colorScheme.onPrimary,
                        fontWeight: FontWeight.bold,
                      ),))
                          ],
                        )
                ],
              )
                )
                ),
              ),
            )
            );
  }
}
