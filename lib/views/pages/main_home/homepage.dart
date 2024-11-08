import 'package:custom_navigation_bar/custom_navigation_bar.dart';
import 'package:donorconnect/views/pages/camps/campsPage.dart';
import 'package:donorconnect/views/pages/search/search_screen.dart';
import 'package:flutter/material.dart';
import '../profile/profile_screen.dart';
import 'home_pages/home_screen.dart';
import 'package:donorconnect/language/helper/language_extention.dart';
import 'package:adaptive_will_pop_scope/adaptive_will_pop_scope.dart'; // Import the adaptive will pop scope
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';

class HomePage extends StatefulWidget {
  final token;
  final String? name;
  final String? email;

  const HomePage({super.key, this.token, this.name, this.email});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final PageController pageController = PageController(initialPage: 0);
    final _text = context.localizedString;
    final pages = [
      const HomeScreen(),
      const SearchScreen(),
      const Camps(),
      ProfileScreen(
        name: widget.name ?? "No Name",
        userId: widget.email!,
      ),
    ];

    final screenWidth = MediaQuery.of(context).size.width;

    return AdaptiveWillPopScope(
      onWillPop: () async {
        if (_currentIndex == 0) {
          // If we are on the HomeScreen, show the exit confirmation dialog
          bool exitApp = await _showExitConfirmationDialog(context) ?? false;
          return exitApp; // Return true to exit the app, false to do nothing
        } else {
          // If we are not on the HomeScreen, navigate to HomeScreen
          setState(() {
            _currentIndex = 0; // Navigate to the HomeScreen
          });
          pageController.jumpToPage(0); // Jump to HomeScreen
          return false; // Don't pop the page
        }
      },
      swipeWidth: screenWidth,
      swipeThreshold: screenWidth / 2,
      child: Scaffold(
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
              title: Text(
                _text.home,
                style: const TextStyle(fontSize: 12),
              ),
            ),
            CustomNavigationBarItem(
                icon: const Icon(Icons.search),
                title: Text(
                  _text.search,
                  style: const TextStyle(fontSize: 12),
                )),
            CustomNavigationBarItem(
                icon: const Icon(Icons.event),
                title: Text(
                  _text.camps,
                  style: const TextStyle(fontSize: 12),
                )),
            CustomNavigationBarItem(
                icon: const Icon(Icons.person),
                title: Text(
                  _text.profile,
                  style: const TextStyle(fontSize: 12),
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
          },
        ),
      ),
    );
  }

  Future<bool?> _showExitConfirmationDialog(BuildContext context) =>
      showCupertinoModalPopup<bool>(
        context: context,
        builder: (_) => CupertinoAlertDialog(
          title: const Text('Are you sure'),
          content: const Text('Do you really want to exit the app?'),
          actions: <CupertinoDialogAction>[
            CupertinoDialogAction(
              isDefaultAction: true,
              onPressed: () => Navigator.pop(context, false), // Don't exit
              child: const Text('No'),
            ),
            CupertinoDialogAction(
              isDestructiveAction: true,
              onPressed: () {
                Navigator.pop(context, true); // Exit the app
                // Ensure the app closes after exit confirmation
                SystemNavigator.pop();
              },
              child: const Text('Yes'),
            ),
          ],
        ),
      );
}
