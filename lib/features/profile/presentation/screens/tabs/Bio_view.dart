import 'package:flutter/material.dart';

class BioTabView extends StatelessWidget {
  const BioTabView({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text(
        "Dr Charles Richard is a licensed mental health therapist with a decade of experience. He helps clients overcome various challenges and enhance their well-being."
        "He applies various therapy modalities to ensure his clients receive the best treatment and care. He offers a sae, supportive, and collaborative space or his clients where they can grow and thrive.",
        //  textAlign: TextAlign.start,
      ),
    );
  }
}
