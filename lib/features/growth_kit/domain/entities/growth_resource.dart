import 'package:flutter/material.dart';

class GrowthResource {
  final String image;
  final String title;
  final VoidCallback onTap;

  GrowthResource({
    required this.image,
    required this.title,
    required this.onTap});
}