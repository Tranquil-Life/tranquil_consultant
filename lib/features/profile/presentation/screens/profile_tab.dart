import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import 'package:tl_consultant/app/presentation/theme/colors.dart';
import 'package:tl_consultant/app/presentation/theme/fonts.dart';
import 'package:tl_consultant/app/presentation/widgets/swipeable.dart';
import 'package:tl_consultant/app/presentation/widgets/unfocus_bg.dart';
import 'package:tl_consultant/app/presentation/widgets/user_avatar.dart';
import 'package:tl_consultant/core/constants/constants.dart';
import 'package:tl_consultant/core/utils/extensions/date_time_extension.dart';
import 'package:tl_consultant/core/utils/functions.dart';
import 'package:tl_consultant/core/utils/helpers/size_helper.dart';
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
  final GlobalKey profileKey = GlobalKey();
  final DashboardController dashboardController =
      Get.put(DashboardController());
  final ProfileController profileController = Get.put(ProfileController());

  int index = 0;

  UserModel? client;

  getMyLocationInfo() {
    profileController.countryTEC.text = dashboardController.country.value;
    profileController.cityTEC.text = dashboardController.city.value;
    profileController.timeZoneTEC.text = dashboardController.timezone.value;
  }

  @override
  void initState() {
    super.initState();
    getMyLocationInfo();
    client = UserModel.fromJson(userDataStore.user);
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
    getMyLocationInfo();

    return UnFocusWidget(
        child: SingleChildScrollView(
      child: Padding(
        padding:
            const EdgeInsets.only(left: 24, right: 24, bottom: 24, top: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ProfileHead(
              client: client!,
              profileController: profileController,
            ),
            const SizedBox(height: 24),
             ProfileRow(profileController: profileController),
            const SizedBox(height: 24),
            PersonalInfo(client: client!),
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
                    physics: NeverScrollableScrollPhysics(),
                    child: QualificationsTabView(
                        profileController: profileController),
                  ),
                ],
              ),
            ),
            SizedBox(height: 40)
          ],
        ),
      ),
    ));
  }
}

class ProfileHead extends StatefulWidget {
  const ProfileHead(
      {super.key, required this.client, required this.profileController});

  final UserModel client;
  final ProfileController profileController;

  @override
  State<ProfileHead> createState() => _ProfileHeadState();
}

class _ProfileHeadState extends State<ProfileHead> {
  final GlobalKey actionKey = GlobalKey();

  String containsTitle(String lastName) {
    var exists = false;
    for (var e in titleOptions) {
      if (lastName.contains(e)) {
        exists = true;
      }
    }

    if (exists) {
      return "${widget.profileController.lastNameTEC.text}, ${widget.profileController.titles.join(',')}";
    } else {
      return widget.profileController.lastNameTEC.text.split(',').first;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CircleAvatar(
          backgroundColor: ColorPalette.gray[100],
          radius: 52,
          child: MyAvatarWidget(size: 52*2),
        ),
        const SizedBox(
          width: 8,
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Obx(()=>Text(
              truncateWithEllipsis((displayWidth(context) / 20).toInt(),
                  "${widget.profileController.firstNameTEC.text} ${containsTitle(widget.profileController.titles.join(', '))}"),
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),),
            SizedBox(
              height: 2,
            ),
            Text(
              "Clinical therapist",
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w400,
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Row(
              children: [
                Icon(
                  Icons.location_on_outlined,
                  color: ColorPalette.blue.shade600,
                ),
                Text(
                  "${widget.profileController.countryTEC.text}/${widget.profileController.cityTEC.text}",
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
          onTap: () => Get.to(const EditProfileScreen()),
          value: 'edit',
          child: Text('Edit profile'),
        ),
        PopupMenuItem(
          onTap: () => showDialog(
              context: context, builder: (context) => SignOutDialog()),
          value: 'sign out',
          child: Text('Sign out'),
        ),
        const PopupMenuItem(
          value: 'delete',
          child: Text('Delete account', style: TextStyle(color: Colors.red)),
        ),
      ],
    );
  }
}

class ProfileRow extends StatelessWidget {
  const ProfileRow({super.key, required this.profileController});

  final ProfileController profileController;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(child: ProfileRowItem(title: "Sessions", figure: "${profileController.meetingsCount.value}"),),
        SizedBox(width: 24),
        Expanded(child: ProfileRowItem(title: "Clients", figure: "${profileController.clientsCount.value}"),)
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
        border: Border.all(color: ColorPalette.gray[900]!),
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
  const PersonalInfo({super.key, required this.client});

  final UserModel client;

  @override
  Widget build(BuildContext context) {
    return  Row(
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
          "Awaiting approval...",
          style: TextStyle(
            fontSize: AppFonts.defaultSize,
            color: client.emailVerifiedAt == null
                ? ColorPalette.red
                : ColorPalette.gray.shade800,
            fontWeight: FontWeight.w400,
          ),
        ),
      ],
    );
  }
}
