import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeController extends GetxController {
  late PageController pageController = PageController(initialPage: currentIndex.value);

  RxInt currentIndex = 0.obs;

  @override
  void onReady() {
    super.onReady();
  }

  void onChangeIndex(int index) {
    currentIndex.value = index;
    pageController.jumpToPage(index);
  }
}
