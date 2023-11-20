import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tl_consultant/app/presentation/routes/app_pages.dart';
import 'package:tl_consultant/app/presentation/widgets/app_bar_button.dart';
import 'package:tl_consultant/features/profile/data/models/user_model.dart';
import 'package:tl_consultant/features/profile/data/repos/user_data_store.dart';
import 'package:tl_consultant/features/profile/domain/entities/user.dart';

class ProfileScreen extends StatelessWidget {
  ProfileScreen({super.key});

  User therapist = UserModel.fromJson(userDataStore.user);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Padding(
                padding: const EdgeInsets.only(right: 12, top: 8, left: 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      therapist.firstName,
                      style: const TextStyle(fontSize: 24),
                    ),
                    AppBarButton(
                        icon: const Icon(Icons.settings),
                        onPressed: () {
                          Get.toNamed(Routes.SETTINGS);
                        }),
                  ],
                )),
          ],
        ),
      ),
    );
  }
}
