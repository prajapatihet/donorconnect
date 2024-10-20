import 'package:dropdown_textfield/dropdown_textfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class BloodBankForm extends StatelessWidget{
  const BloodBankForm({super.key});
  @override
  Widget build(BuildContext context) {

    return  Scaffold(
      
      body: 
      
        Container(
          height: double.infinity,
          width: double.infinity,
                decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    const Color.fromARGB(255, 221, 45, 45).withOpacity(0.6),
                    const Color.fromARGB(255, 232, 62, 50).withOpacity(0.6),
                    const Color.fromARGB(255, 240, 62, 39),
                    const Color.fromARGB(255, 222, 69, 69)
                  ],
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  ),
              ),

          child: Padding(
            padding: EdgeInsets.fromLTRB(30, 150, 30, 90),
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
                        Text('Blood Bank',style: TextStyle(
                  color: Theme.of(context).colorScheme.onSurface,
                  fontWeight: FontWeight.bold,
                  fontSize: 30,
                  ),
                  ),

                        SizedBox(height: 50,),
                      const DropdownMenu(dropdownMenuEntries: [
                        DropdownMenuEntry(value: '1', label: 'Agra'),
                        DropdownMenuEntry(value: '2', label: 'Delhi'),
                        DropdownMenuEntry(value: '3', label: 'Chandigarh'),
                        DropdownMenuEntry(value: '4', label: 'Banglore'),
                        DropdownMenuEntry(value: '5', label: 'Pune'),
                        DropdownMenuEntry(value: '6', label: 'Noida'),
                        DropdownMenuEntry(value: '7', label: 'Mumbai'),
                        DropdownMenuEntry(value: '8', label: 'Kolkata'),

                      ],
                      width: 600,

                      label: Text('Select City'),
                      ),
                                              SizedBox(height: 30,),
                      const DropdownMenu(dropdownMenuEntries: [
                        DropdownMenuEntry(value: '1', label: 'xx'),
                        DropdownMenuEntry(value: '2', label: 'zx'),
                        DropdownMenuEntry(value: '3', label: 'xy'),
                        DropdownMenuEntry(value: '4', label: 'xm'),
                        DropdownMenuEntry(value: '5', label: 'xk'),
                      ],
                      width: 600,

                      label: Text('Select Taluka/Zila'),
                      ),
                        SizedBox(height: 30,),
                      const DropdownMenu(dropdownMenuEntries: [
                        DropdownMenuEntry(value: '1', label: 'AIIMS'),
                        DropdownMenuEntry(value: '2', label: 'City Hospital'),
                        DropdownMenuEntry(value: '3', label: 'General Hospital'),
                        DropdownMenuEntry(value: '4', label: 'Trama center'),


                      ],
                      width: 600,

                      label: Text('Select Hospital'),
                      ),


                        SizedBox(height: 30,),  

                      const DropdownMenu(dropdownMenuEntries: [
                        DropdownMenuEntry(value: '1', label: 'A'),
                        DropdownMenuEntry(value: '2', label: 'A+'),
                        DropdownMenuEntry(value: '3', label: 'AB'),
                        DropdownMenuEntry(value: '4', label: 'AB+'),
                        DropdownMenuEntry(value: '5', label: 'B'),
                        DropdownMenuEntry(value: '6', label: 'B+'),
                        DropdownMenuEntry(value: '7', label: 'O'),
                        DropdownMenuEntry(value: '8', label: 'O+'),
                      ],
                      width: 600,
                      label: Text('Needed blood group'),
                      ),                      
                    SizedBox(height: 30),

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

