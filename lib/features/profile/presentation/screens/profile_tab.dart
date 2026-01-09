import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:tl_consultant/core/global/custom_app_bar.dart';

import 'package:tl_consultant/core/global/unfocus_bg.dart';
import 'package:tl_consultant/core/global/user_avatar.dart';
import 'package:tl_consultant/core/constants/constants.dart';
import 'package:tl_consultant/core/theme/colors.dart';
import 'package:tl_consultant/core/theme/fonts.dart';
import 'package:tl_consultant/core/utils/functions.dart';
import 'package:tl_consultant/core/utils/helpers/size_helper.dart';
import 'package:tl_consultant/core/utils/routes/app_pages.dart';
import 'package:tl_consultant/features/dashboard/presentation/controllers/dashboard_controller.dart';
import 'package:tl_consultant/features/journal/presentation/widgets/tab_bar.dart';
import 'package:tl_consultant/features/profile/data/models/user_model.dart';
import 'package:tl_consultant/features/profile/data/repos/user_data_store.dart';
import 'package:tl_consultant/features/profile/presentation/controllers/profile_controller.dart';
import 'package:tl_consultant/features/profile/presentation/screens/edit_profile.dart';

import 'package:tl_consultant/features/profile/presentation/screens/tabs/bio_view.dart';
import 'package:tl_consultant/features/profile/presentation/screens/tabs/qualifications_view.dart';
import 'package:tl_consultant/features/settings/presentation/widgets/sign_out_dialog.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen>
    with TickerProviderStateMixin {
  late TabController controller = TabController(length: 2, vsync: this);
  final dashboardController = DashboardController.instance;

  // final profileController = ProfileController.instance;

  int index = 0;

  UserModel? therapist;

  // void getMyLocationInfo() {
  //   profileController.countryTEC.text = dashboardController.country.value;
  //   profileController.cityTEC.text = dashboardController.city.value;
  //   profileController.timeZoneTEC.text = dashboardController.timezone.value;
  // }

  void checkVariables() {
    if (dashboardController.firstName.value.isEmpty ||
        dashboardController.lastName.value.isEmpty) {
      dashboardController.restoreUserInfo();
    }
  }


  @override
  void initState() {
    super.initState();

    // ✅ Create TabController in initState (not as a field initializer)
    controller = TabController(length: 2, vsync: this);

    // ✅ If you need index, update it safely AFTER the frame
    controller.addListener(() {
      if (!mounted) return;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        setState(() => index = controller.index);
      });
    });

    // ✅ Do not trigger reactive updates during build
    WidgetsBinding.instance.addPostFrameCallback((_) {
      checkVariables();
    });
  }

  @override
  void dispose() {
    // _locWorker?.dispose();
    controller.dispose();
    super.dispose();
  }

  void listenToController() {
    controller.addListener(() {
      setState(() {
        index = controller.index;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return UnFocusWidget(
        child: Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: CustomAppBar(
        backgroundColor: Colors.grey.shade100,
        title: "My profile",
        centerTitle: false,
        // onBackPressed: () =>
        //     kIsWeb ? Get.offAllNamed(Routes.DASHBOARD) : Get.back(),
        onBackPressed: () {
          if (Get.key.currentState?.canPop() ?? false) {
            Get.back();
          } else {
            Get.offNamed(Routes.DASHBOARD); // fallback route
          }
        },
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding:
              const EdgeInsets.only(left: 24, right: 24, bottom: 24, top: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ProfileHead(),
              const SizedBox(height: 24),
              ProfileRow(),
              const SizedBox(height: 24),
              PersonalInfo(
                therapist: therapist,
              ),
              const SizedBox(height: 40),
              CustomTabBar(
                controller: controller,
                onTap: (i) {},
                label1: "My Bio",
                label2: "Qualifications",
              ),
              const SizedBox(height: 20),

              //Bio & Qualifications
              SizedBox(
                height: displayHeight(context) * 0.5,
                child: TabBarView(
                  controller: controller,
                  children: [
                    BioTabView(),
                    SingleChildScrollView(
                      child: QualificationsTabView(),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 40)
            ],
          ),
        ),
      ),
    ));
  }
}

class ProfileHead extends StatefulWidget {
  const ProfileHead({super.key});

  // final ProfileController profileController;

  @override
  State<ProfileHead> createState() => _ProfileHeadState();
}

class _ProfileHeadState extends State<ProfileHead> {
  final dashboardController = DashboardController.instance;

  final GlobalKey actionKey = GlobalKey();

  // String containsTitle(String lastName) {
  //   var exists = false;
  //   for (var e in titleOptions) {
  //     if (lastName.contains(e)) {
  //       exists = true;
  //     }
  //   }
  //
  //   if (exists) {
  //     return "${widget.profileController.lastNameTEC.text}, ${widget.profileController.titles.join(',')}";
  //   } else {
  //     return widget.profileController.lastNameTEC.text.split(',').first;
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CircleAvatar(
          backgroundColor: ColorPalette.grey[100],
          radius: 52,
          child: MyAvatarWidget(size: 52 * 2),
        ),
        const SizedBox(
          width: 8,
        ),
        Expanded(
            flex: 4,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ValueListenableBuilder<TextEditingValue>(
                //   valueListenable: widget.profileController.firstNameTEC,
                //   builder: (_, __, ___) {
                //     return Text(
                //         "${widget.profileController.firstNameTEC.text} ${widget.profileController.lastNameTEC.text}");
                //   },
                // ),

                // Obx(
                //   () => Text(
                //     truncateWithEllipsis((displayWidth(context) / 14).toInt(),
                //         "${widget.profileController.firstNameTEC.text} ${widget.profileController.lastNameTEC.text} ${containsTitle(widget.profileController.titles.join(', '))}"),
                //     style: TextStyle(
                //       fontSize: 18,
                //       fontWeight: FontWeight.w600,
                //     ),
                //   ),
                // ),

                Obx(
                  () => Text(
                    truncateWithEllipsis((displayWidth(context) / 14).toInt(),
                        "${dashboardController.firstName.value} ${dashboardController.lastName.value}"),
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                SizedBox(
                  height: 2,
                ),
                // Text(
                //   "Clinical therapist",
                //   style: TextStyle(
                //     fontSize: 12,
                //     fontWeight: FontWeight.w400,
                //   ),
                // ),
                SizedBox(
                  height: 10,
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.location_on_outlined,
                      color: ColorPalette.blue.shade600,
                    ),
                    Obx(() => Expanded(
                          child: Text(
                            truncateWithEllipsis(
                                28,
                                "${dashboardController.country.value} "
                                "${dashboardController.state.value.isNotEmpty ? "/" : ""} "
                                "${dashboardController.state.value}"),
                            style: TextStyle(
                              color: ColorPalette.blue.shade600,
                              fontSize: AppFonts.defaultSize,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ))
                  ],
                )
              ],
            )),
        Expanded(
          child: Align(
            alignment: Alignment.topRight,
            child: IconButton(
              key: actionKey, // Assigning the GlobalKey here
              onPressed: () => displayActionPopUp(context),
              icon: Icon(
                Icons.more_vert_outlined,
                color: Color.fromARGB(255, 76, 48, 81),
              ),
            ),
          ),
        ),
      ],
    );
  }

  void displayActionPopUp(BuildContext context) {
    // Ensure the RenderBox is obtained from the widget assigned with the key
    final RenderBox? renderBox =
        actionKey.currentContext?.findRenderObject() as RenderBox?;

    if (renderBox == null) {
      // Avoid crashing if the render box is null
      if (kDebugMode) {
        print('RenderBox is null. The widget may not have been rendered yet.');
      }
      return;
    }

    final Offset offset = renderBox.localToGlobal(Offset.zero);
    final Size size = renderBox.size;

    showMenu(
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius:
            BorderRadius.circular(12), // Set the desired border radius
      ),
      context: context,
      position: RelativeRect.fromLTRB(
        offset.dx,
        offset.dy + size.height,
        offset.dx + size.width,
        0,
      ),
      items: [
        PopupMenuItem(
          onTap: () => Get.toNamed(Routes.EDIT_PROFILE),
          value: 'edit',
          child: Text('Edit profile'),
        ),
        PopupMenuItem(
          onTap: () => Get.toNamed(Routes.SETTINGS),
          value: 'delete',
          child: Text('Settings'),
        ),
      ],
    );
  }
}

class ProfileRow extends StatelessWidget {
  ProfileRow({super.key});

  final dashboardController = DashboardController.instance;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: ProfileRowItem(
              title: "Sessions",
              figure: "${dashboardController.meetingsCount.value}"),
        ),
        SizedBox(width: 24),
        Expanded(
          child: ProfileRowItem(
              title: "Clients",
              figure: "${dashboardController.clientsCount.value}"),
        )
      ],
    );
  }
}

class ProfileRowItem extends StatelessWidget {
  const ProfileRowItem({super.key, required this.title, required this.figure});

  final String title;
  final String figure;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: ColorPalette.grey[900]!),
        color: ColorPalette.green[200],
        borderRadius: BorderRadius.circular(4),
      ),
      child: Center(
        child: Padding(
          padding: EdgeInsets.all(8.0),
          child: Column(
            children: [
              Text(
                figure,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Divider(
                endIndent: 32,
                indent: 32,
                color: Colors.grey.shade100,
              ),
              Text(
                title,
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class PersonalInfo extends StatelessWidget {
  const PersonalInfo({super.key, this.therapist});

  final UserModel? therapist;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SvgPicture.asset(
          height: 16,
          width: 16,
          "assets/images/icons/calendar.svg",
          color: ColorPalette.grey.shade800,
        ),
        SizedBox(
          width: 5,
        ),
        Text(
          "Awaiting approval...",
          style: TextStyle(
            fontSize: AppFonts.defaultSize,
            color: therapist?.emailVerifiedAt == null
                ? ColorPalette.red
                : ColorPalette.grey.shade800,
            fontWeight: FontWeight.w400,
          ),
        ),
      ],
    );
  }
}
