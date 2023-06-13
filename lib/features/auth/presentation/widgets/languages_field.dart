import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:language_picker/language_picker.dart';
import 'package:language_picker/languages.dart';
import 'package:tl_consultant/app/presentation/theme/colors.dart';
import 'package:tl_consultant/app/presentation/theme/fonts.dart';
import 'package:tl_consultant/core/utils/helpers/size_helper.dart';
import 'package:tl_consultant/features/auth/presentation/controllers/auth_controller.dart';
import 'package:tl_consultant/features/auth/presentation/widgets/form_fields.dart';

class LanguagesField extends StatefulWidget {
  const LanguagesField({Key? key}) : super(key: key);

  @override
  State<LanguagesField> createState() => _LanguagesFieldState();
}

class _LanguagesFieldState extends State<LanguagesField> {


  String currentLang = "";
  selectLang(language){
    if(!AuthController.instance.languagesArr.contains(language)) {
      AuthController.instance.languagesArr.add(language);
    }
  }

  //Language picker
  void openLanguagePicker()=>
      showCupertinoModalPopup(
          context: context,
          builder: (BuildContext context)=>
              Container(
                height: 500,
                decoration: const BoxDecoration(color: Colors.white),
                padding: EdgeInsets.only(top: 16),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(
                          child: Obx(()=>
                              Material(
                                  child: Container(
                                    color: Colors.white,
                                    padding: EdgeInsets.only(left: 8),
                                    child: Wrap(
                                      direction: Axis.vertical,
                                      children: [
                                        SizedBox(height: 8),
                                        Text("${AuthController.instance.languagesArr.length} "
                                            "language${AuthController.instance.languagesArr.length==1 ? "" : "s"}",
                                          style: TextStyle(
                                              fontFamily: AppFonts.josefinSansSemiBold,
                                              fontSize: AppFonts.defaultSize),),
                                        SizedBox(height: 8),
                                        Text(AuthController.instance.languagesArr.join(', ').length >= 30 ?
                                        '${AuthController.instance.languagesArr.join(', ').substring(0, 30)}...' :
                                        AuthController.instance.languagesArr.join(', '),
                                          style: TextStyle(
                                              fontSize: AppFonts.defaultSize,
                                              color: ColorPalette.black,
                                              fontFamily: AppFonts.josefinSansRegular),)
                                      ],
                                    )
                                  ),
                                  ))
                        ),

                        TextButton(
                          onPressed: (){
                            selectLang(currentLang);
                          },
                          child: const Text("Add",
                            style: TextStyle(
                                color: ColorPalette.green,
                                fontSize: AppFonts.defaultSize,
                                fontFamily: AppFonts.josefinSansBold
                            ),),
                        ),
                      ],
                    ),

                    LanguagePickerCupertino(
                      pickerSheetHeight: 400.0,
                      itemBuilder: _buildCupertinoItem,
                      onValuePicked: (Language language) async{
                        setState(() {
                          currentLang = language.name;
                        });
                      },
                    )
                  ],
                )
              )
      ).whenComplete((){
        AuthController.instance.languagesTEC.text = AuthController.instance.languagesArr.join(', ');
      });

  //Language item
  Widget _buildCupertinoItem(Language language) =>
      Container(
        margin: EdgeInsets.only(
          left: displayWidth(context) * 0.06,
          right: displayWidth(context) * 0.06,
        ),
        child: Row(
          children: <Widget>[
            Text("+${language.isoCode}"),
            SizedBox(width: 8.0),
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    child: Text(language.name),
                  ),

                  Material(
                    child: Obx(()=>
                        Checkbox(
                          activeColor: Colors.green,
                            value: AuthController.instance.languagesArr.contains(language.name) ? true : false,
                            onChanged: (bool? value){
                              //
                            }),)
                  )
                ],
              ),
            )
          ],
        ),
      );

  @override
  Widget build(BuildContext context) {
    return pLanguageField(
        onTap: (){
          openLanguagePicker();
        }
    );
  }
}
