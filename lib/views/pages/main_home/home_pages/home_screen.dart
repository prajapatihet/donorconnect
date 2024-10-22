// import 'package:donorconnect/cubit/auth/auth_cubit.dart';
// import 'package:donorconnect/language/cubit/language_cubit.dart';
import 'package:donorconnect/language/helper/langauge_popup.dart';
import 'package:donorconnect/language/helper/language_extention.dart';
import 'package:donorconnect/views/common_widgets/home_card.dart';
import 'package:donorconnect/views/common_widgets/home_card_form.dart';
import 'package:donorconnect/views/pages/learn_about_donation/learn_about_donation.dart';
import 'package:donorconnect/views/pages/locate_blood_banks/locate_blood_banks.dart';
import 'package:donorconnect/views/pages/main_home/chatbot.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
// import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    final _text = context.localizedString;
    var height = MediaQuery.of(context).size.height;
    // var width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: Padding(
          padding: const EdgeInsets.only(
            top: 16.0,
          ),
          child: Text(
            _text.how_can_we_help,
            maxLines: 3,
            style: GoogleFonts.montserrat(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              letterSpacing: 1,
            ),
          ),
        ),
        actions: const [
          // IconButton(
          //     onPressed: () {
          //       LangaugePopup();
          //     },
          //     icon: const Icon(Icons.language_rounded))

          Padding(
            padding: EdgeInsets.only(left: 16.0, right: 16.0),
            child: LanguagePopup(),
          )
        ],
        toolbarHeight: 65,
        toolbarOpacity: 0.8,
        automaticallyImplyLeading: false,
        surfaceTintColor: Colors.transparent,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  HomeCardConst(
                    title: _text.donate,
                    col: const Color.fromARGB(255, 255, 122, 122),
                    onPressed: () {},
                  ),
                  HomeCardConst(
                    title: _text.required,
                    col: const Color.fromARGB(255, 167, 165, 252),
                    onPressed: () {},
                  ),
                ],
              ),
              HomeCard(
                title: _text.locate_nearby_bloodbank,
                description: _text.find_nearby_bloodbank,
                button: "Search",
                image: 'assets/images/home_image1.png',
                icon: const Icon(
                  Icons.search,
                  size: 23,
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    PageRouteBuilder(
                      pageBuilder: (context, animation, secondaryAnimation) =>
                          const LocateBloodBanks(),
                      transitionsBuilder:
                          (context, animation, secondaryAnimation, child) {
                        return FadeTransition(
                          opacity: animation,
                          child: child,
                        );
                      },
                      transitionDuration: const Duration(
                          milliseconds: 900), // Adjust duration as needed
                    ),
                  );
                },
              ),
              HomeCard(
                title: _text.learn_about_donating,
                description: _text.learn_more_about_donating,
                button: "Learn",
                image: 'assets/images/home_image2.png',
                icon: const Icon(Icons.menu_book_outlined),
                onPressed: () {
                  Navigator.push(
                    context,
                    PageRouteBuilder(
                      pageBuilder: (context, animation, secondaryAnimation) =>
                          const LearnAboutDonation(),
                      transitionsBuilder:
                          (context, animation, secondaryAnimation, child) {
                        return FadeTransition(
                          opacity: animation,
                          child: child,
                        );
                      },
                      transitionDuration: const Duration(
                          milliseconds: 900), // Adjust duration as needed
                    ),
                  );
                },
              ),
              SizedBox(height: height * 0.1)
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(onPressed: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) => ChatBot()));
      },
      child: const Icon(Icons.chat),
    ),
    );
  }
}
