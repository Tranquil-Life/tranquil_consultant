import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:get/get.dart';
import 'package:tl_consultant/app/presentation/theme/colors.dart';
import 'package:tl_consultant/app/presentation/theme/fonts.dart';
import 'package:tl_consultant/app/presentation/widgets/custom_app_bar.dart';
import 'package:tl_consultant/app/presentation/widgets/user_avatar.dart';
import 'package:tl_consultant/features/journal/presentation/widgets/tab_bar.dart';

import 'package:tl_consultant/features/profile/presentation/screens/edit_profile.dart';
import 'package:tl_consultant/features/profile/presentation/widgets/tab_bar.dart';

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
    litenToController();
  }

  litenToController() {
    controller!.addListener(
      () {
        setState(() {
          index = controller!.index;
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: const CustomAppBar(
          centerTitle: false,
          title: "My Profile",
        ),
        body: Container(
            padding:
                const EdgeInsets.only(top: 40, left: 24, right: 24, bottom: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const ProfileHead(),
                const SizedBox(height: 30),
                const ProfileRow(),
                const SizedBox(height: 40),
                const PersonalInfo(),
                const SizedBox(height: 20),
                CustomTabBar(
                  controller: controller,
                  onTap: (i) {},
                  label1: "label1",
                  label2: "label2",
                ),
                const SizedBox(height: 20),
                Expanded(
                  child: TabBarView(
                    controller: controller,
                    children: [
                      Container(
                        child: const Text(
                            "Dr Charles Richard is a licensed mental health therapist with a decade of experience. He helps clients overcome various challenges and enhance their well-being. He applies various therapy modalities to ensure his clients receive the best treatment and care. He offers a sae, supportive, and collaborative space or his clients where they can grow and thrive."),
                      ),
                      Container(
                        child: const Text("Qualification"),
                      ),
                    ],
                  ),
                ),
              ],
            )));
    // ListView(
    //   children: [
    //     ProfileHead(),
    //     SizedBox(
    //       height: 30,
    //     ),
    //     ProfileRow(),
    //     SizedBox(
    //       height: 40,
    //     ),
    //     PersonalInfo(),
    //     SizedBox(
    //       height: 20,
    //     ),
    //     CustomTabBar(
    //         controller: controller,
    //         onTap: (index) {},
    //         label1: "label1",
    //         label2: "label2"),
    //     SizedBox(height: 20),
    //     TabBarView(
    //       controller: controller,
    //       children: [
    //         Container(
    //           child: const Text("My Bio"),
    //         ),
    //         Container(
    //           child: const Text("Qualification"),
    //         ),
    //       ],
    //     ),
    //   ],
    // ));
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
          const UserAvatar(),
          const SizedBox(
            width: 10,
          ),
          const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Charles Israel, MD",
                style: TextStyle(
                  fontSize: AppFonts.defaultSize,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                "Doctor",
                style: TextStyle(),
              ),
              SizedBox(
                height: 20,
              ),
              Text(
                "London",
                style: TextStyle(color: Colors.blue),
              ),
            ],
          ),
          Expanded(
            child: Align(
              alignment: Alignment.topRight,
              child: IconButton(
                onPressed: () {
                  Get.to(const EditProfileScreen());
                  // Get.defaultDialog(
                  //     title: "Dialog", middleText: "This is a GetX dialog.");
                },
                icon: const Icon(
                  Icons.more_vert,
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
          height: 80,
          width: 100,
          decoration: BoxDecoration(
            color: ColorPalette.green[200],
            borderRadius:
                BorderRadius.circular(10), // Adjust the radius as needed
          ),
          child: const Center(
            child: Padding(
              padding: EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Text("7"),
                  Divider(),
                  Text("Sessions"),
                ],
              ),
            ),
          ),
        ),
        Container(
          height: 80,
          width: 100,
          decoration: BoxDecoration(
            color: ColorPalette.green[200],
            borderRadius:
                BorderRadius.circular(10), // Adjust the radius as needed
          ),
          child: const Center(
            child: Padding(
              padding: EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Text("7"),
                  Divider(),
                  Text("Sessions"),
                ],
              ),
            ),
          ),
        ),
        Container(
          height: 80,
          width: 100,
          decoration: BoxDecoration(
            color: ColorPalette.green[200],
            borderRadius:
                BorderRadius.circular(10), // Adjust the radius as needed
          ),
          child: const Center(
            child: Padding(
              padding: EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Text("7"),
                  Divider(),
                  Text("Sessions"),
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
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Personal information",
            style: TextStyle(fontSize: 16),
          ),
          Row(
            children: [
              Icon(
                Icons.male,
              ),
              Text("Male"),
            ],
          ),
          Row(
            children: [
              Icon(
                Icons.timer,
              ),
              Text("45 year"),
            ],
          ),
        ],
      ),
    );
  }
}

class ProfileTabBar extends HookWidget {
  const ProfileTabBar({super.key});

  @override
  Widget build(BuildContext context) {
    final tabController = useTabController(initialLength: 2);
    final tabIndex = useState(0);
    useEffect(() {
      tabController.addListener(() {
        tabIndex.value = tabController.index;
      });
      return () {
        tabController.dispose();
      };
    }, [tabController]);

    return Column(
      children: [
        TabBar(
          controller: tabController,
          onTap: (v) {
            tabIndex.value = v;
          },
          splashFactory: NoSplash.splashFactory,
          overlayColor: MaterialStateProperty.resolveWith<Color?>(
            (Set<MaterialState> states) {
              return states.contains(MaterialState.focused)
                  ? null
                  : Colors.transparent;
            },
          ),
          dividerHeight: 2,
          dividerColor: ColorPalette.green,
          indicatorColor: Colors.transparent,
          tabs: [
            Container(
              height: 40,
              width: double.maxFinite,
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(6),
                  topRight: Radius.circular(6),
                ),
                color: tabIndex.value == 0
                    ? ColorPalette.green
                    : Colors.transparent,
              ),
              child: Center(
                child: Text(
                  "My Bio",
                  style: TextStyle(
                    color: tabIndex.value == 0 ? Colors.white : Colors.black,
                  ),
                ),
              ),
            ),
            Container(
              height: 40,
              width: double.maxFinite,
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(6),
                  topRight: Radius.circular(6),
                ),
                color: tabIndex.value == 1
                    ? ColorPalette.green
                    : Colors.transparent,
              ),
              child: Center(
                child: GestureDetector(
                  child: Text(
                    "Qualification",
                    style: TextStyle(
                      color: tabIndex.value == 1 ? Colors.white : Colors.black,
                    ),
                  ),
                  onTap: () {},
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        const Expanded(
          child: TabBarView(
            children: [],
          ),
        ),
      ],
    );
  }
}
