import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:tl_consultant/core/theme/colors.dart';
import 'package:tl_consultant/core/theme/fonts.dart';
import 'package:tl_consultant/core/utils/helpers/size_helper.dart';
import 'package:tl_consultant/features/growth_kit/presentation/controllers/growth_kit_controller.dart';

class GrowthKitPage extends StatefulWidget {
  const GrowthKitPage({super.key});

  @override
  State<GrowthKitPage> createState() => _GrowthKitPageState();
}

class _GrowthKitPageState extends State<GrowthKitPage> {
  final growthKitController = GrowthKitController.instance;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(24, 24, 24, 0),
      child: SingleChildScrollView(child:
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Growth kit",
              style: TextStyle(
                  color: ColorPalette.black2,
                  fontSize: 32,
                  fontFamily: AppFonts.josefinSansRegular)),
          SizedBox(height: 24),
          Text(
              "Find tools and resources to help you grow, connect, and level up",
              style: TextStyle(color: ColorPalette.grey[500], fontSize: AppFonts.baseSize)),
          SizedBox(height: 24),

          Column(
            children: growthKitController.resources.map((e)=>
                GestureDetector(
                    onTap: e.onTap,
                    child: Container(
                      width: displayWidth(context),
                      decoration: BoxDecoration(),
                      child: Stack(
                        children: [
                          SvgPicture.asset(e.image, width: displayWidth(context),),
                          Positioned(
                            bottom: isSmallScreen(context) ? 12 : 35,
                            right: 0,
                            left: 0,
                            child: Container(
                              alignment: Alignment.centerLeft,
                              width: displayWidth(context),
                              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8.0),
                              height: 38, // Adjust height as needed
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.only(
                                    bottomLeft: Radius.circular(8.0),
                                    bottomRight: Radius.circular(8.0)),
                                gradient: LinearGradient(
                                  begin: Alignment.centerLeft,
                                  end: Alignment.centerRight,
                                  colors: [
                                    ColorPalette.black2, // Start with black
                                    ColorPalette.black2.withOpacity(0.8),
                                    ColorPalette.black2.withOpacity(0.5),
                                    ColorPalette.black2.withOpacity(0.2),
                                    Colors.transparent, // Fade into transparent
                                  ],
                                ),
                              ),
                              child: Text(e.title, style: TextStyle(color: Colors.white, fontFamily: isSmallScreen(context) ? null : AppFonts.mulishBold),),
                            ),
                          )
                        ],
                      ),
                    ))).toList(),
          ),

          SizedBox(height: 40,)
        ],
      )),
    );
  }
}
