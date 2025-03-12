import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tl_consultant/core/theme/colors.dart';
import 'package:tl_consultant/core/theme/fonts.dart';
import 'package:tl_consultant/core/utils/helpers/size_helper.dart';
import 'package:tl_consultant/features/auth/presentation/controllers/auth_controller.dart';

class AreaOfExpertiseModalSheet extends StatefulWidget {
  const AreaOfExpertiseModalSheet({super.key});

  @override
  State<AreaOfExpertiseModalSheet> createState() => _AreaOfExpertiseModalSheetState();
}

class _AreaOfExpertiseModalSheetState extends State<AreaOfExpertiseModalSheet> {
  final authController = Get.put(AuthController());

  Map<String, bool> numbers = {
    'Addiction & Recovery' : false,
    'Anger Management' : false,
    'Anxiety' : false,
    'Boundary Issues' : false,
    'Career and Work Counseling' : false,
    'Life Coaching' : false,
    'Relationship Issues' : false,
    'Self Esteem' : false,
    'Sexual Addiction' : false,
    'Social Media Addiction' : false,
    'Stress Management' : false,
    'Trauma and PTSD' : false,
    'LGBTQIA+ Issues' : false,
    'Codependency' : false,
    'Coping Skills' : false,
    'Depression' : false,
    'Grief and Loss' : false,
    'HIV/AIDS' : false,
    'Men’s Issues' : false,
    'School/College Issues' : false,
  };

  List<String> holder_1 = [];
  List? searchedList;

  void search(String query) {
    searchedList = [];
    print('Searching');
    setState(() {
      numbers.keys.map((e){
        //..query
      });
      // for (var i = 0; i < numbers.length; i++) {
      //   query = aoeList[i];
      //   if (query
      //       .toLowerCase()
      //       .contains(aoeSearchController.text.toLowerCase())) {
      //     searchedAOEList!.add(query);
      //   }
      // }
    });
    print(searchedList);
  }

  getItems(){
    authController.specialtiesArr.clear();

    numbers.forEach((key, value) {
      if(value == true)
      {
        holder_1.add(key);
      }
    });

    authController.specialtiesArr.value = holder_1;

    print(authController.specialtiesArr);
    authController.areaOfExpertiseTEC.text = holder_1.join(', ');

    // Clear array after use.
    holder_1.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 600,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: SizedBox(
        height: displayHeight(context) * 0.08,
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: TextField(
                    controller: authController.aoeSearchController,
                    //onEditingComplete: search(),
                    onChanged: (value){
                      //search(value);
                    },
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(right: 8),
                  child: TextButton(
                    onPressed: (){
                      getItems();

                      Get.back();
                    },
                    child: Text("Save",
                      style: TextStyle(
                          color: ColorPalette.green,
                          fontSize: AppFonts.defaultSize,
                          fontFamily: AppFonts.josefinSansBold
                      ),),
                  ),
                )
              ],
            ),

            Expanded(
              child: ListView(
                children: numbers.keys.map((String key) {
                  return CheckboxListTile(
                    title: Text(key),
                    value: numbers[key],
                    activeColor: ColorPalette.green,
                    checkColor: ColorPalette.white,
                    onChanged: (bool? value) {
                      setState(() {
                        numbers[key] = value!;
                      });
                    },
                  );
                }).toList(),
              ),
            )
          ],
        ),
      ),
    );
  }
}
