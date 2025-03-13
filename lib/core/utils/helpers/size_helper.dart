import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

const int largeScreenSize = 1366;
const int mediumScreenSize = 720;
const int smallScreenSize = 360;
const int customScreenSize = 1100;

Size displaySize(BuildContext context) {
  //debugPrint('Size = ' + MediaQuery.of(context).size.toString());
  return MediaQuery.of(context).size;
}

double displayHeight(BuildContext context) {
  //debugPrint('Height = ' + displaySize(context).height.toString());
  return displaySize(context).height;
}

double displayWidth(BuildContext context) {
  //debugPrint('Width = ' + displaySize(context).width.toString());
  return displaySize(context).width;
}

bool isSmallScreen(BuildContext context) =>
    displayWidth(context) < mediumScreenSize;

bool isMediumScreen(BuildContext context) =>
    displayWidth(context) >= mediumScreenSize &&
    displayWidth(context) < largeScreenSize;

bool isLargeScreen(BuildContext context) =>
    displayWidth(context) >= largeScreenSize;

bool isCustomScreen(BuildContext context) =>
    displayWidth(context) >= mediumScreenSize &&
    displayWidth(context) <= customScreenSize;
