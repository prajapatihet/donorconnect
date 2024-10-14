import 'package:custom_navigation_bar/custom_navigation_bar.dart';
import 'package:donorconnect/views/pages/main_home/bottom_nav.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../profile/profile_screen.dart';
import 'home_pages/home_screen.dart';

class HomePage extends StatefulWidget {
  final token;
  final String? name;
  final String? email;

  const HomePage({super.key, this.token, this.name, this.email});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // @override
  // void dispose() {
  //   Get.delete<NavigationController>();
  //   super.dispose();
  // }
  // late ScrollController controller;
  //
  /// variables
  int _currentIndex = 0;
  //
  // @override
  // void initState() {
  //   super.initState();
  //   controller = ScrollController();
  // }
  //
  // @override
  // void dispose() {
  //   controller.dispose;
  //   super.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    final PageController pageController = PageController(initialPage: 0);
    final pages = [
      const HomeScreen(),
      const HomeScreen(),
      const HomeScreen(),
      ProfileScreen(
        name: widget.name ?? "No Name",
        userId: widget.email!,
      ),
    ];

    return Scaffold(
      bottomNavigationBar: CustomNavigationBar(
        scaleFactor: 0.2,
        strokeColor: Colors.blueGrey,
        iconSize: 24,
        elevation: 0,
        backgroundColor: Colors.transparent,
        selectedColor: Colors.blue,
        unSelectedColor: Colors.blue.withOpacity(0.4),
        isFloating: false,
        currentIndex: _currentIndex,
        scaleCurve: Curves.bounceOut,
        bubbleCurve: Curves.easeInOut,
        onTap: (int newIndex) {
          setState(() {
            _currentIndex = newIndex;
            pageController.animateToPage(newIndex,
                duration: const Duration(milliseconds: 500),
                curve: Curves.fastOutSlowIn);
          });
        },
        items: [
          CustomNavigationBarItem(
            icon: const Icon(Icons.home),
            title: const Text(
              "Home",
              style: TextStyle(fontSize: 12),
            ),
          ),
          CustomNavigationBarItem(
              icon: const Icon(Icons.search),
              title: const Text(
                "Search",
                style: TextStyle(fontSize: 12),
              )),
          CustomNavigationBarItem(
              icon: const Icon(Icons.event),
              title: const Text(
                "Camps",
                style: TextStyle(fontSize: 12),
              )),
          CustomNavigationBarItem(
              icon: const Icon(Icons.person),
              title: const Text(
                "Profile",
                style: TextStyle(fontSize: 12),
              )),
        ],
      ),
      body: PageView.builder(
          controller: pageController,
          onPageChanged: (int newIndex) {
            setState(() {
              _currentIndex = newIndex;
            });
          },
          itemCount: 4,
          itemBuilder: (BuildContext context, int index) {
            return pages[index];
          }),
    );
  }
}
