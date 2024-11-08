import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:donorconnect/views/pages/login/login.dart'; // Import LoginPage
import 'package:get_storage/get_storage.dart';
import 'package:flutter/foundation.dart';

class OnBoardingController extends GetxController {
  // Page controller for the PageView
  var pageController = PageController();

  // Observable to track the current page index
  Rx<int> currentPageIndex = 0.obs;

  // Update the page indicator when the page changes
  void updatePageIndicator(int index) {
    currentPageIndex.value = index;
  }

  // Method to navigate to a specific page based on dot navigation
  void dotNavigationClick(int index) {
    currentPageIndex.value = index;
    pageController.jumpToPage(index);
  }

  // Method to navigate to the next page or to the login page if it's the last page
  void nextPage() {
    if (currentPageIndex.value == 2) {
      final storage = GetStorage();

      // Update the storage to indicate the user has completed onboarding
      storage.write('IsFirstTime', false);

      // Navigate to the LoginPage
      Get.offAll(const LoginPage());
    } else {
      // Move to the next page
      int nextPage = currentPageIndex.value + 1;
      pageController.jumpToPage(nextPage);
    }
  }

  // Skip the onboarding process and jump to the last page (LoginPage)
  void skipPage() {
    currentPageIndex.value = 2;
    pageController.jumpToPage(2);
  }

  // Method to go to the login page directly
  void goToLoginPage() {
    Get.to(() => const LoginPage()); // Navigate to LoginPage
  }
}
