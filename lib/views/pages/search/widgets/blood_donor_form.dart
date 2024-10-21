import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class BloodDonorForm extends StatelessWidget{
  const BloodDonorForm({super.key});
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      
      body: SingleChildScrollView(
                  child: Padding(
            padding: EdgeInsets.fromLTRB(30, 150, 30, 80),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(30)),
                color:Colors.white
              ),
              child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Form(
                    child:Column(
                      children: [
                        Text('Search Donors',style: TextStyle(
                  color: Theme.of(context).colorScheme.onSurface,
                  fontWeight: FontWeight.bold,
                  fontSize: 30,
                  ),
                  ),

                        SizedBox(height: 50,),
                      
            TextFormField(
                    decoration: InputDecoration(
                      border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(9))),
                      label: Text('Enter the blood group')
                      ),

                  ),
                  const SizedBox(height: 20),
            TextFormField(
                    decoration: InputDecoration(
                      border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(9))),
                      label: Text('Enter District')
                      ),

                  ),
                  const SizedBox(height: 20),
            TextFormField(
                    decoration: InputDecoration(
                      border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(9))),
                      label: Text('Enter the blood group')
                      ),

                  ),
                  const SizedBox(height: 20),
            TextFormField(
                    decoration: InputDecoration(
                      border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(9))),
                      label: Text('Enter Pin Code')
                      ),

                  ),
                  const SizedBox(height: 20),

                              ElevatedButton(
                        style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  padding: const EdgeInsets.fromLTRB(112, 10, 140, 15),
                ),
                    onPressed: () {},
                    child: Text(maxLines: 1,
                        'Search',
                      style: TextStyle(
                  color: Theme.of(context).colorScheme.onPrimary,
                  fontWeight: FontWeight.bold,
                  
                  ),
                    ),

                  ),
              const SizedBox(height: 30),
                      ]
                  ),
                ),
            ),
          ),
        )
      )
      

          );
  }
}