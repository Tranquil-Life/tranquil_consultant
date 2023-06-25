import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tl_consultant/app/presentation/theme/colors.dart';
import 'package:tl_consultant/app/presentation/theme/tranquil_icons.dart';
import 'package:tl_consultant/core/utils/functions.dart';
import 'package:tl_consultant/features/dashboard/presentation/controllers/dashboard_controller.dart';
import 'package:tl_consultant/features/dashboard/presentation/widgets/nav_item.dart';
import 'package:tl_consultant/features/home/presentation/screens/home_tab.dart';
import 'package:tl_consultant/features/home/presentation/widgets/count_indicator.dart';
import 'package:tl_consultant/features/journal/presentation/controllers/notes_controller.dart';

part 'package:tl_consultant/features/dashboard/presentation/widgets/nav_bar.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({Key? key}) : super(key: key);

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  final dashboardController = Get.put(DashboardController());

  @override
  void initState() {
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
    setStatusBarBrightness(true);

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Stack(
          fit: StackFit.expand,
          alignment: Alignment.bottomCenter,
          children: [
            Positioned.fill(
                bottom: MediaQuery.of(context).padding.bottom + 62,
                child: Obx(()=>
                    IndexedStack(
                      index: dashboardController.currentIndex.value,
                      sizing: StackFit.expand,
                      children: const [
                        HomeTab(),
                        // WalletTab(),
                        // NotesTab(),
                        // ProfileScreen()
                      ],
                    ))
            ),
            const NavBar(),
          ],
        ),
      ),
    );
  }
}
