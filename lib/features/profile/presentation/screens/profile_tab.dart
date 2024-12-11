import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:get/get.dart';
import 'package:tl_consultant/app/presentation/theme/colors.dart';
import 'package:tl_consultant/app/presentation/theme/fonts.dart';
import 'package:tl_consultant/app/presentation/widgets/app_bar_button.dart';

import 'package:tl_consultant/app/presentation/widgets/user_avatar.dart';
import 'package:tl_consultant/core/utils/helpers/size_helper.dart';
import 'package:tl_consultant/features/journal/presentation/widgets/tab_bar.dart';

import 'package:tl_consultant/features/profile/presentation/screens/edit_profile.dart';
import 'package:tl_consultant/features/profile/presentation/screens/tabs/Bio_view.dart';
import 'package:tl_consultant/features/profile/presentation/screens/tabs/qualifications_view.dart';

// class ProfileScreen extends StatelessWidget {
//   const ProfileScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         backgroundColor: ColorPalette.scaffoldColor,
//         body: SafeArea(
//             child: Padding(
//           padding: EdgeInsets.only(left: 24, right: 24.0),
//           child: SingleChildScrollView(
//             child: Column(
//               children: [
//                 SizedBox(
//                   height: 8,
//                 ),
// Row(
//   children: [
//     AppBarButton(
//         icon: const Icon(Icons.arrow_back_ios),
//         onPressed: () {
//           Get.back();
//         }),
//     const SizedBox(
//       width: 12,
//     ),
//     const Text(
//       "My profile",
//       style: TextStyle(
//           fontSize: 24,
//           fontWeight: FontWeight.w500,
//           color: ColorPalette.black),
//     ),
//   ],
// ),
//                 SizedBox(
//                   height: 40,
//                 ),
//                 Row(
//                   children: [
// CircleAvatar(
//   backgroundImage:
//       AssetImage("assets/images/profile/therapist.png"),
//   radius: 42,
// )
//                   ],
//                 )
//               ],
//             ),
//           ),
//         )));
//   }
// }

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen>
    with TickerProviderStateMixin {
  late TabController controller = TabController(length: 2, vsync: this);

  int index = 0;

  @override
  void initState() {
    super.initState();
    listenToController();
  }

  listenToController() {
    controller.addListener(() {
      setState(() {
        index = controller.index;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorPalette.scaffoldColor,
      body: SingleChildScrollView(
        child: Padding(
          padding:
              const EdgeInsets.only(top: 8, left: 24, right: 24, bottom: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  AppBarButton(
                      icon: const Icon(Icons.arrow_back_ios),
                      onPressed: () {
                        Get.back();
                      }),
                  const SizedBox(
                    width: 12,
                  ),
                  const Text(
                    "My profile",
                    style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w500,
                        color: ColorPalette.black),
                  ),
                ],
              ),
              const SizedBox(height: 40),
              const ProfileHead(),
              const SizedBox(height: 24),
              const ProfileRow(),
              const SizedBox(height: 24),
              const PersonalInfo(),
              const SizedBox(height: 40),
              CustomTabBar(
                controller: controller,
                onTap: (i) {},
                label1: "My Bio",
                label2: "Qualifications",
              ),
              const SizedBox(height: 20),
              SizedBox(
                height: displayHeight(context) * 0.5,
                child: TabBarView(
                  controller: controller,
                  children: const [
                    BioTabView(),
                    QualificationsTabView(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ProfileHead extends StatelessWidget {
  const ProfileHead({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      // color: Colors.green,
      height: 100,
      child: Row(
        children: [
          //const UserAvatar(),
          CircleAvatar(
            backgroundImage: AssetImage("assets/images/profile/therapist.png"),
            radius: 52,
          ),
          const SizedBox(
            width: 10,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Charles Richard, MD",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                "Clinical therapist",
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Row(
                children: [
                  Icon(
                    Icons.location_on_outlined,
                    color: ColorPalette.blue.shade600,
                  ),
                  Text(
                    "London, United Kingdom",
                    style: TextStyle(
                      color: ColorPalette.blue.shade600,
                      fontSize: AppFonts.defaultSize,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ],
          ),
          Expanded(
            child: Align(
              alignment: Alignment.topRight,
              child: IconButton(
                onPressed: () {
                  // showDialog(
                  //   context: context,
                  //   builder: (_) => SignOutDialog(),
                  // );
                  debugPrint("print");
                  Get.to(const EditProfileScreen());
                  // Get.defaultDialog(
                  //     title: "Dialog", middleText: "This is a GetX dialog.");
                },
                icon: Icon(
                  Icons.more_vert_outlined,
                  color: Color.fromARGB(255, 76, 48, 81),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ProfileRow extends StatelessWidget {
  const ProfileRow({Key? key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          height: 70,
          width: 100,
          decoration: BoxDecoration(
            color: ColorPalette.green[200],
            borderRadius: BorderRadius.circular(4),
          ),
          child: const Center(
            child: Padding(
              padding: EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Text(
                    "50",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Divider(
                    endIndent: 32,
                    indent: 32,
                  ),
                  Text(
                    "Sessions",
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        Container(
          height: 70,
          width: 100,
          decoration: BoxDecoration(
            color: ColorPalette.green[200],
            borderRadius: BorderRadius.circular(4.0),
          ),
          child: const Center(
            child: Padding(
              padding: EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Text(
                    "7",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Divider(
                    endIndent: 32,
                    indent: 32,
                  ),
                  Text(
                    "Clients",
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        Container(
          height: 70,
          width: 100,
          decoration: BoxDecoration(
            color: ColorPalette.green[200],
            borderRadius: BorderRadius.circular(4.0),
          ),
          child: const Center(
            child: Padding(
              padding: EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Text(
                    "\$5900",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Divider(
                    endIndent: 32,
                    indent: 32,
                  ),
                  Text(
                    "Earned",
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class PersonalInfo extends StatelessWidget {
  const PersonalInfo({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 115,
      width: 180,
      // color: Colors.amber,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Personal info",
            style: TextStyle(
                fontSize: AppFonts.baseSize, fontWeight: FontWeight.w400),
          ),
          Row(
            children: [
              Icon(
                Icons.male,
                color: ColorPalette.gray.shade800,
              ),
              Text(
                "Male",
                style: TextStyle(
                  fontSize: AppFonts.defaultSize,
                  color: ColorPalette.gray.shade800,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
          SizedBox(
            height: 8,
          ),
          Row(
            children: [
              SvgPicture.asset(
                height: 16,
                width: 16,
                "assets/images/icons/timer.svg",
                color: ColorPalette.gray.shade800,
              ),
              SizedBox(
                width: 5,
              ),
              Text(
                "45 years old",
                style: TextStyle(
                  fontSize: AppFonts.defaultSize,
                  color: ColorPalette.gray.shade800,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
          SizedBox(
            height: 8,
          ),
          Row(
            children: [
              SvgPicture.asset(
                height: 16,
                width: 16,
                "assets/images/icons/calendar.svg",
                color: ColorPalette.gray.shade800,
              ),
              SizedBox(
                width: 5,
              ),
              Text(
                "15 July, 2023",
                style: TextStyle(
                  fontSize: AppFonts.defaultSize,
                  color: ColorPalette.gray.shade800,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
