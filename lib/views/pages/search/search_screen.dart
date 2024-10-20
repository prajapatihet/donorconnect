import 'package:donorconnect/language/helper/language_extention.dart';
import 'package:donorconnect/views/common_widgets/home_card.dart';
import 'package:donorconnect/views/pages/search/widgets/blood_bank_form.dart';
import 'package:donorconnect/views/pages/search/widgets/blood_donor_form.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
class SearchScreen  extends StatefulWidget{
    const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  @override
  Widget build(BuildContext context) {
    final _text = context.localizedString;
    return  Scaffold(
        appBar: AppBar(
          title:  Padding(
          padding: const EdgeInsets.only(
            top: 16.0,
          ),
          child: Text(
            _text.locate_nearby_bloodbank,
            maxLines: 3,
            style: GoogleFonts.montserrat(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              letterSpacing: 1,
            ),
          ),
        ),
          
        ),
    body: SingleChildScrollView(
    child: Column(
      children: [
        Padding(
          padding: EdgeInsets.all(30),
          child: Container(
            height: 50,
            width: double.infinity,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.black),borderRadius: BorderRadius.all(Radius.circular(19)),
            ),
            child:  Padding(
              padding: EdgeInsets.all(9),
              child: Row(
                  children: [
                    Icon(Icons.search, color: Colors.grey),
                    const SizedBox(width: 20),
                    Text('Search nearby bloodbanks', style: Theme.of(context).textTheme.bodySmall),
                  ],
                ),
            ),
          ),
        ),
        SizedBox(height: 15),
         HomeCard(
          title: 'Blood Bank',
           description: 'Search near by blood  bank',
            button: 'Find', 
            image: 'assets/images/home_image1.png', 
            onPressed:(){Navigator.push(
              context,MaterialPageRoute(
                builder: (ctx)=> const BloodBankForm())
              );} , 
            icon: Icon(Icons.local_hospital),),
            SizedBox(height: 15),
          HomeCard(
            title: 'Blood Donors', 
            description: 'Find nearby donor if available and acc.to blood type',
            button: 'explore',
              image: 'assets/images/home_image2.png', 
              onPressed: (){
                Navigator.push(context, MaterialPageRoute(
                  builder:(ctx)=>const BloodDonorForm()));
              },
               icon: Icon(Icons.bloodtype))
      ],
    ),
    ),
      );
    
  }
}