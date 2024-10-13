import 'package:donorconnect/language/helper/language_extention.dart';
import 'package:donorconnect/views/pages/main_home/bottom_nav.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomePage extends StatefulWidget {
  final token;
  final String? name;
  final String? email;

  const HomePage({super.key, this.token, this.name, this.email});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void dispose() {
    Get.delete<NavigationController>();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final _text = context.localizedString;
    final controller =
        Get.put(NavigationController(widget.name ?? "No Name", widget.email!));

    return Scaffold(
      bottomNavigationBar: Obx(
        () => NavigationBar(
          height: 70,
          elevation: 3,
          surfaceTintColor: Colors.blue,
          selectedIndex: controller.selectedIndex.value,
          onDestinationSelected: (index) {
            controller.selectedIndex.value = index;
          },
          destinations: [
            NavigationDestination(
              icon: const Icon(Icons.home),
              label: _text.home,
            ),
            NavigationDestination(
              icon: const Icon(Icons.search),
              label: _text.search,
            ),
            NavigationDestination(
              icon: const Icon(Icons.event),
              label: _text.camps,
            ),
            NavigationDestination(
              icon: const Icon(Icons.person),
              label: _text.profile,
            ),
          ],
        ),
      ),
      body: Obx(
        () => AnimatedSwitcher(
          duration:
              const Duration(milliseconds: 800), // Duration of the fade effect
          transitionBuilder: (Widget child, Animation<double> animation) {
            return FadeTransition(opacity: animation, child: child);
          },
          child: controller.getScreens()[controller.selectedIndex.value],
        ),
      ),
    );
  }
}
