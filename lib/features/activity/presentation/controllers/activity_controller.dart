import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tl_consultant/core/global/custom_snackbar.dart';
import 'package:tl_consultant/features/activity/data/models/notification.dart';
import 'package:tl_consultant/features/activity/data/repos/notification_repo.dart';
import 'package:tl_consultant/features/activity/domain/entities/notification.dart';

class ActivityController extends GetxController {
  static ActivityController get instance => Get.find();

  var count = 0.obs;

  RxList<NotificationData> notifications = <NotificationData>[].obs;
  NotificationRepoImpl repo = NotificationRepoImpl();

  //pagination vars
  var page = 1.obs;
  var limit = 10.obs;

  // There is next page or not
  var hasNextPage = true.obs;

  // Used to display loading indicators when _firstLoad function is running
  var isFirstLoadRunning = false.obs;

  // Used to display loading indicators when _loadMore function is running
  var isLoadMoreRunning = false.obs;

  // The controller for the ListView
  late ScrollController scrollController;

  Future<void> loadFirstNotifications() async {
    isFirstLoadRunning.value = true;

    Either either =
    await repo.getNotifications(page: page.value, limit: limit.value);

    either.fold((l) => CustomSnackBar.errorSnackBar(l.message!), (r) {
      var data = r['data'];

      notifications.value =
          (data as List).map((e) => NotificationModel.fromJson(e)).toList();
    });

    update();

    isFirstLoadRunning.value = false;
  }

  // This function will be triggered whenever the user scroll
  // to near the bottom of the list view
  Future<void> loadMoreNotifications() async {
    if (hasNextPage.value == true &&
        isFirstLoadRunning.value == false &&
        isLoadMoreRunning.value == false &&
        scrollController.position.extentAfter < 300) {
      isLoadMoreRunning.value =
      true; // Display a progress indicator at the bottom
      page.value += 1; // Increase _page by 1

      Either either =
      await repo.getNotifications(page: page.value, limit: limit.value);

      either.fold((l) => CustomSnackBar.errorSnackBar(l.message!), (r) {
        List<NotificationData> fetchedNotifications = [];
        fetchedNotifications = (r['data'] as List)
            .map((e) => NotificationModel.fromJson(e))
            .toList();
        if (fetchedNotifications.isNotEmpty) {
          notifications.addAll(fetchedNotifications);
        } else {
          // This means there is no more data
          // and therefore, we will not send another GET request
          hasNextPage.value = false;
        }

        isLoadMoreRunning.value = false;
      });

      update();
    }
  }

  getUnread() async {
    Either either = await repo.getUnreadNotificationCount();
    either.fold((l) => CustomSnackBar.errorSnackBar(l.message.toString()),
            (r) => count.value = r['data']);
  }

  clearData() {
    page.value = 1;
    limit.value = 10;
    hasNextPage.value = false;
    isFirstLoadRunning.value = false;
    isLoadMoreRunning.value = false;
  }
}
