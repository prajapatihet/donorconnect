import 'package:donorconnect/views/pages/main_home/home_pages/home_screen.dart';
import 'package:donorconnect/views/pages/profile/profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NavigationController extends GetxController {
  final Rx<int> selectedIndex = 0.obs;
  final String name;
  final String email;
  NavigationController(this.name, this.email);

  List<Widget> getScreens() {
    return [
      const HomeScreen(),
      const HomeScreen(),
      const HomeScreen(),
      ProfileScreen(name: name,userId: email,),
    ];
  }
}
