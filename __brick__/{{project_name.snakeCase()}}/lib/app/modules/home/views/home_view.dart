import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../components/cached_image/cached_image.dart';
import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('HomeView'), centerTitle: true),
      body: PageView(
        controller: controller.pageController,
        children: controller.g.menuItems
            .map(
              (e) => switch (e.key) {
                'home' => const Center(child: Text('index Page')),
                'make_same' => const Center(child: Text('make_same Page')),
                'works' => const Center(child: Text('works Page')),
                'mine' => const Center(child: Text('mine Page')),
                _ => const SizedBox(),
              },
            )
            .toList(),
      ),
      bottomNavigationBar: Obx(
        () => BottomNavigationBar(
          currentIndex: controller.currentIndex.value,
          landscapeLayout: BottomNavigationBarLandscapeLayout.linear,
          elevation: 2.0,
          type: BottomNavigationBarType.fixed,
          showUnselectedLabels: true,
          showSelectedLabels: true,
          selectedFontSize: 15.sp,
          unselectedFontSize: 15.sp,
          selectedItemColor: Colors.black,
          unselectedItemColor: const Color.fromRGBO(129, 129, 129, 1),
          items: controller.g.menuItems
              .map(
                (e) => BottomNavigationBarItem(
                  icon: CachedImage(imageUrl: e.icon, width: 34.w),
                  activeIcon: CachedImage(imageUrl: e.activeIcon, width: 34.w),
                  label: e.label,
                ),
              )
              .toList(),
          onTap: controller.onChangeIndex,
        ),
      ),
    );
  }
}
