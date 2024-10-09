import 'package:donorconnect/cubit/auth/auth_cubit.dart';
import 'package:donorconnect/views/common_widgets/home_card.dart';
import 'package:donorconnect/views/common_widgets/home_card_form.dart';
import 'package:donorconnect/views/pages/locate_blood_banks/locate_blood_banks.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    // var width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'How can we help you?',
          style: GoogleFonts.montserrat(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            letterSpacing: 1,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              context.read<AuthCubit>().signOut(context);
            },
            icon: const Icon(
              Icons.logout,
            ),
          ),
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
                    title: 'Donate',
                    col: const Color.fromARGB(255, 255, 122, 122),
                    onPressed: () {},
                  ),
                  HomeCardConst(
                    title: 'Required',
                    col: const Color.fromARGB(255, 167, 165, 252),
                    onPressed: () {},
                  ),
                ],
              ),
              HomeCard(
                title: "Locate Nearby Bloodbanks",
                description: "Find Nearby BloodBank.",
                button: "Search",
                image: 'assets/images/home_image1.png',
                icon: const Icon(
                  Icons.search,
                  size: 23,
                ),
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const LocateBloodBanks(),
                      ));
                },
              ),
              HomeCard(
                title: "Learn About Donating",
                description: "Learn more about blood & platelet donation.",
                button: "Learn",
                image: 'assets/images/home_image2.png',
                icon: const Icon(Icons.menu_book_outlined),
                onPressed: () {},
              ),
              SizedBox(height: height * 0.1)
            ],
          ),
        ),
      ),
    );
  }
}
