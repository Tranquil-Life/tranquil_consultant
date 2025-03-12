import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tl_consultant/features/consultation/domain/entities/event.dart';

class EventsController extends GetxController{
  static EventsController instance = Get.find();

  //pagination vars
  var page = 1.obs;
  // There is next page or not
  var hasNextPage = true.obs;
  // Used to display loading indicators when _firstLoad function is running
  var isFirstLoadRunning = false.obs;
  // Used to display loading indicators when _loadMore function is running
  var isLoadMoreRunning = false.obs;
  var lastEventId = 0.obs;
  // The controller for the ListView
  late ScrollController scrollController;

  var eventsCount = 0.obs;

  var loading = false.obs;

  RxList<Event> events = RxList<Event>();
}