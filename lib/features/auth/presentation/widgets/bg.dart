import 'package:flutter/material.dart';
import 'package:tl_consultant/app/presentation/widgets/custom_app_bar.dart';
import 'package:tl_consultant/app/presentation/widgets/my_default_text_theme.dart';
import 'package:tl_consultant/app/presentation/widgets/unfocus_bg.dart';
import 'package:tl_consultant/core/utils/helpers/size_helper.dart';

class BG extends StatelessWidget {
  const BG({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Image(
      image: AssetImage('assets/images/mountains_bg.png'),
      fit: BoxFit.cover,
      color: Colors.black45,
      colorBlendMode: BlendMode.darken,
    );
  }
}

class CustomBGWidget extends StatelessWidget {
  final String? title;
  final Widget child;

  const CustomBGWidget({
    Key? key,
    this.title,
    required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          Image(
            image: const AssetImage('assets/images/mountains_bg.png'),
            fit: BoxFit.cover,
            width: displayWidth(context),
            color: Colors.black45,
            colorBlendMode: BlendMode.darken,
          ),

          Column(
            children: [
              if (title != null)
                CustomAppBar(title: title!, titleColor: Colors.white),
              Expanded(
                child: SafeArea(
                  top: false,
                  child: UnfocusWidget(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: MyDefaultTextStyle(
                        style: const TextStyle(color: Colors.white),
                        child: child,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
