import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tl_consultant/core/theme/properties.dart';
import 'package:tl_consultant/features/chat/presentation/widgets/dialogs/rate_consultation_dialog.dart';

class EndSessionBottomSheet extends StatefulWidget {
  const EndSessionBottomSheet({Key? key}) : super(key: key);

  @override
  State<EndSessionBottomSheet> createState() => _EndSessionBottomSheetState();
}

class _EndSessionBottomSheetState extends State<EndSessionBottomSheet> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 28, 24, 12),
      decoration: bottomSheetDecoration,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text('End Session?'),
          const SizedBox(
            height: 16,
          ),
          const Text(
              'Do you want to end your current session with consultant!.displayName?'),
          const SizedBox(
            height: 25,
          ),
          Row(
            children: [
              Expanded(
                  child: OutlinedButton(
                      onPressed: () {
                        Navigator.of(context).pop();

                      }, child: const Text('Cancel'))),
              const SizedBox(
                width: 16,
              ),
              Expanded(
                  child: ElevatedButton(
                      onPressed: () {
                        Get.back();

                        // showDialog(
                        //   context: context,
                        //   builder: (_) => const RateConsultationDialog(),
                        // );
                      }, child: const Text('End Session')))
            ],
          )
        ],
      ),
    );
  }
}