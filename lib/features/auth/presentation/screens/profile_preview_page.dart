import 'package:flutter/material.dart';
import 'package:tl_consultant/core/global/app_bar_button.dart';
import 'package:tl_consultant/core/global/custom_scaffold.dart';
import 'package:tl_consultant/core/global/my_default_text_theme.dart';
import 'package:tl_consultant/core/theme/colors.dart';
import 'package:tl_consultant/core/theme/tranquil_icons.dart';
import 'package:tl_consultant/core/utils/helpers/size_helper.dart';
import 'package:tl_consultant/features/auth/presentation/widgets/info_card.dart';

class ProfilePreviewPage extends StatelessWidget {
  const ProfilePreviewPage({super.key, this.image});

  final String? image;

  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.transparency,
      child: Stack(
        children: [
          SingleChildScrollView(
            child: SizedBox(
              height: displayHeight(context) - 350,
              width: displayWidth(context),
              child: Image.network(
                image!,
                fit: BoxFit.cover,
                errorBuilder: (context, __, ___) => Center(
                  child: SizedBox(
                    width: displayWidth(context) * 0.7,
                    child: FittedBox(
                      fit: BoxFit.contain,
                      child:
                      Icon(TranquilIcons.profile, color: Colors.grey[600]),
                    ),
                  ),
                ),
              ),
            ),
          ),
          Container(
            height: MediaQuery.of(context).padding.top + 24,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Colors.black38, Colors.transparent],
              ),
            ),
          ),
          Positioned(
            top: 8,
            left: 8,
            child: SafeArea(
              child: AppBarButton(
                onPressed: Navigator.of(context).pop,
                backgroundColor: Colors.white,
                icon: Padding(
                  padding: const EdgeInsets.all(1),
                  child: Icon(
                    Icons.arrow_back_ios_new,
                    color: ColorPalette.green[800],
                    size: 19,
                  ),
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
                padding: const EdgeInsets.fromLTRB(20, 32, 20, 16),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(24)),
                  boxShadow: const [
                    BoxShadow(blurRadius: 16, color: Colors.black26)
                  ],
                ),
                child: SafeArea(
                  top: false,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '[YOUR NAME]',
                        style: const TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        "Specialist in matters relating to [YOUR AREAS OF EXPERTISE]",
                        style: const TextStyle(fontSize: 15.5, height: 1.3),
                      ),
                      const SizedBox(height: 16),
                      MyDefaultTextStyle(
                        style: TextStyle(
                          color: ColorPalette.green[800]!,
                          fontSize: 16,
                        ),
                        child: Column(
                          children: [
                            InfoCard(
                              icon: Icons.timer,
                              title: '45 minutes session',
                              subTitle: "[YOUR CHARGE PER SESSION]",
                            ),
                            InfoCard(
                                icon: TranquilIcons.translate,
                                title: 'Fluent in',
                                subTitle: "[THE LANGUAGES YOU SPEAK]"
                            ),
                            const InfoCard(
                              icon: Icons.location_on_rounded,
                              title: 'Location',
                              subTitle: "[YOUR LOCATION]",
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                    ],
                  ),
                )),
          )
        ],
      ),
    );
  }
}
