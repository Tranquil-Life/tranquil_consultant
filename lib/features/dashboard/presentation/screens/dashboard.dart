import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tl_consultant/app.dart';
import 'package:tl_consultant/core/global/custom_app_bar.dart';
import 'package:tl_consultant/core/global/custom_fab.dart';
import 'package:tl_consultant/core/theme/colors.dart';
import 'package:tl_consultant/core/utils/functions.dart';
import 'package:tl_consultant/core/utils/helpers/size_helper.dart';
import 'package:tl_consultant/core/utils/helpers/svg_elements.dart';
import 'package:tl_consultant/features/chat/presentation/controllers/chat_controller.dart';
import 'package:tl_consultant/features/dashboard/presentation/controllers/dashboard_controller.dart';
import 'package:tl_consultant/features/dashboard/presentation/widgets/nav_item.dart';
import 'package:tl_consultant/features/home/presentation/screens/home_tab.dart';
import 'package:tl_consultant/features/home/presentation/widgets/count_indicator.dart';
import 'package:tl_consultant/features/journal/presentation/screens/journal_tab.dart';
import 'package:tl_consultant/features/profile/data/models/user_model.dart';
import 'package:tl_consultant/features/profile/data/repos/user_data_store.dart';
import 'package:tl_consultant/features/profile/domain/entities/user.dart';
import 'package:tl_consultant/features/profile/presentation/controllers/profile_controller.dart';
import 'package:tl_consultant/features/profile/presentation/screens/edit_profile.dart';
import 'package:tl_consultant/features/profile/presentation/screens/profile_tab.dart';
import 'package:tl_consultant/features/wallet/presentation/screens/wallet_tab.dart';

part 'package:tl_consultant/features/dashboard/presentation/widgets/nav_bar.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  final dashboardController = Get.put(DashboardController());
  final profileController = Get.put(ProfileController());

  @override
  void initState() {
    dashboardController.getMyLocationInfo();
    checkForEmptyProfileInfo(profileController);

    setStatusBarBrightness(true);
    super.initState();
  }

  @override
  void didChangeDependencies() {
    precacheImage(const AssetImage('assets/images/chat_bg.png'), context);
    super.didChangeDependencies();
  }

  bool reload = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(0), // Completely removes AppBar height
        child: CustomAppBar(
          backgroundColor: Colors.grey.shade100,
        ),
      ),
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.grey.shade100,
      floatingActionButton: CustomFAB(
        onChatTap: () {},
        dbController: dashboardController,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        shadowColor: Colors.grey,
        color: ColorPalette.scaffoldColor,
        shape: const CircularNotchedRectangle(),
        notchMargin: displayWidth(context) * 0.025,
        child: BottomNavBar(dashboardController: dashboardController),
      ),
      body: Obx(() =>
          dashboardController.pages[dashboardController.currentIndex.value]),
    );
  }
}
