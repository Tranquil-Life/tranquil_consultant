import 'package:flutter/material.dart';
import 'package:tl_consultant/core/theme/colors.dart';
import 'package:tl_consultant/core/utils/helpers/size_helper.dart';

class GuestHeaderWidget extends StatelessWidget {
  final VoidCallback onSignIn;
  final VoidCallback onApply;

  const GuestHeaderWidget({
    super.key,
    required this.onSignIn,
    required this.onApply,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      margin: isSmallScreen(context)
          ? null
          : EdgeInsets.only(right: 24, top: 24, bottom: 24),
      decoration: BoxDecoration(
        color: const Color(0xffF5FBF7),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: ColorPalette.green.withValues(alpha: .15),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 52,
            width: 52,
            decoration: BoxDecoration(
              color: ColorPalette.green.withValues(alpha: .12),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.person_outline,
              color: ColorPalette.green,
              size: 28,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'You are browsing as a guest',
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w700,
                    color: ColorPalette.grey[400],

                  ),
                ),

                const SizedBox(height: 6),

                const Text(
                  'Sign in for full access or start your verification to join the platform.',
                  style: TextStyle(
                    fontSize: 14,
                    height: 1.5,
                    color: Color(0xff6B7280),
                  ),
                ),

                const SizedBox(height: 14),

                Row(
                  children: [
                    Expanded(
                      child: SizedBox(
                        height: 42,
                        child: ElevatedButton(
                          onPressed: onSignIn,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: ColorPalette.green,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: const Text(
                            'Sign In',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(width: 10),

                    Expanded(
                      child: SizedBox(
                        height: 42,
                        child: OutlinedButton(
                          onPressed: onApply,
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(
                              color: ColorPalette.green,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: const Text(
                            'Apply Now',
                            style: TextStyle(
                              color: ColorPalette.green,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

        ],
      ),
    );
  }
}
