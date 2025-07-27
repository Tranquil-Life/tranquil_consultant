import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:intl_phone_field/countries.dart';
import 'package:tl_consultant/core/constants/constants.dart';
import 'package:tl_consultant/core/global/buttons.dart';
import 'package:tl_consultant/core/theme/colors.dart';
import 'package:tl_consultant/core/theme/fonts.dart';
import 'package:tl_consultant/core/utils/helpers/size_helper.dart';
import 'package:tl_consultant/core/utils/helpers/svg_elements.dart';
import 'package:tl_consultant/features/wallet/presentation/controllers/earnings_controller.dart';
import 'package:tl_consultant/features/wallet/presentation/widgets/form_fields.dart';

class BeneficiaryInfoFields extends StatefulWidget {
  const BeneficiaryInfoFields({super.key, required this.earningsController});

  final EarningsController earningsController;

  @override
  State<BeneficiaryInfoFields> createState() => _BeneficiaryInfoFieldsState();
}

class _BeneficiaryInfoFieldsState extends State<BeneficiaryInfoFields> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("BENEFICIARY INFO", style: TextStyle(fontSize: AppFonts.baseSize)),
        SizedBox(height: 12),
        Text(
          "Beneficiary name",
          style: TextStyle(color: ColorPalette.grey[600]),
        ),
        const SizedBox(height: 8),
        beneficiaryNameField(widget.earningsController),
        SizedBox(height: 12),
        Text(
          "Beneficiary address",
          style: TextStyle(color: ColorPalette.grey[600]),
        ),
        const SizedBox(height: 8),
        beneficiaryAddressField(widget.earningsController, () {
          Get.dialog(AlertDialog(
            backgroundColor: Colors.white,
            titlePadding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            contentPadding: EdgeInsets.symmetric(horizontal: 20),
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Enter recipient address',
                      style: TextStyle(
                          fontFamily: AppFonts.mulishSemiBold, fontSize: 18),
                    ),
                    GestureDetector(
                      onTap: () {
                        Get.back();
                      },
                      child: SvgPicture.asset(SvgElements.svgHexagonCloseIcon),
                    )
                  ],
                ),
                Divider(),
              ],
            ),
            content: SizedBox(
              width: double.maxFinite,
              height: displayHeight(context),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Country"),
                    const SizedBox(height: 8),
                    Obx(
                      () =>
                          recipientCountryField(widget.earningsController, () {
                        widget.earningsController.isCountryDropdownVisible
                            .toggle();
                      }),
                    ),
                    Obx(() => widget
                            .earningsController.isCountryDropdownVisible.value
                        ? ConstrainedBox(
                            constraints: const BoxConstraints(maxHeight: 200),
                            child: ListView.builder(
                              padding: EdgeInsets.only(top: 8),
                              shrinkWrap: true,
                              itemCount: recipientCountries.length,
                              itemBuilder: (context, index) {
                                final country = recipientCountries[index];
                                return ListTile(
                                  title: Text(country),
                                  onTap: () {
                                    widget.earningsController
                                        .recipientCountryTEC.text = country;
                                    widget.earningsController
                                        .isCountryDropdownVisible.value = false;
                                  },
                                );
                              },
                            ),
                          )
                        : const SizedBox.shrink()),
                    SizedBox(height: 20),
                    Text(
                      "State",
                      style: TextStyle(
                          color: ColorPalette.grey[600], fontSize: 14),
                    ),
                    const SizedBox(height: 8),
                    Obx(() => recipientStateField(widget.earningsController,
                            () async {
                          if (!widget.earningsController.isStateDropdownVisible
                              .value) {
                            await widget.earningsController.getStates(
                                country: widget.earningsController
                                    .recipientCountryTEC.text);
                          }

                          widget.earningsController.isStateDropdownVisible
                              .toggle();
                        })),
                    Obx(() => widget
                            .earningsController.isStateDropdownVisible.value
                        ? ConstrainedBox(
                            constraints: const BoxConstraints(maxHeight: 200),
                            child: ListView.builder(
                              padding: EdgeInsets.only(top: 8),
                              shrinkWrap: true,
                              itemCount: widget.earningsController
                                  .selectedCountryStates.length,
                              itemBuilder: (context, index) {
                                final state = widget.earningsController
                                    .selectedCountryStates[index];
                                var name = "${state['name']}";
                                // var stateCode = "${state['state_code']}";
                                return ListTile(
                                  title: Text(name),
                                  onTap: () {
                                    widget.earningsController.recipientStateTEC
                                        .text = name;
                                    widget.earningsController
                                        .isStateDropdownVisible.value = false;
                                  },
                                );
                              },
                            ),
                          )
                        : const SizedBox.shrink()),
                    SizedBox(height: 20),
                    Text(
                      "City",
                      style: TextStyle(
                          color: ColorPalette.grey[600], fontSize: 14),
                    ),
                    const SizedBox(height: 8),
                    cityField(widget.earningsController, () async {
                      if (!widget
                          .earningsController.isCityDropdownVisible.value) {
                        await widget.earningsController.getCities(
                            country: widget
                                .earningsController.recipientCountryTEC.text,
                            state: widget
                                .earningsController.recipientStateTEC.text);
                      }

                      widget.earningsController.isCityDropdownVisible.toggle();
                    }),
                    Obx(() => widget
                            .earningsController.isCityDropdownVisible.value
                        ? ConstrainedBox(
                            constraints: const BoxConstraints(maxHeight: 200),
                            child: ListView.builder(
                              padding: EdgeInsets.only(top: 8),
                              shrinkWrap: true,
                              itemCount: widget.earningsController
                                  .selectedStateCities.length,
                              itemBuilder: (context, index) {
                                final city = widget.earningsController
                                    .selectedStateCities[index];
                                return ListTile(
                                  title: Text(city),
                                  onTap: () {
                                    widget.earningsController.recipientCityTEC
                                        .text = city;
                                    widget.earningsController
                                        .isCityDropdownVisible.value = false;
                                  },
                                );
                              },
                            ),
                          )
                        : const SizedBox.shrink()),
                    SizedBox(height: 20),
                    Text(
                      "Street",
                      style: TextStyle(
                          color: ColorPalette.grey[600], fontSize: 14),
                    ),
                    const SizedBox(height: 8),
                    streetField(widget.earningsController),
                    SizedBox(height: 20),
                    Text(
                      "Unit/Apartment/Suite no.",
                      style: TextStyle(
                          color: ColorPalette.grey[600], fontSize: 14),
                    ),
                    const SizedBox(height: 8),
                    aptNumberField(widget.earningsController),
                    const SizedBox(height: 40),
                    CustomButton(
                      onPressed: () {},
                      text: "Enter & close",
                    ),
                  ],
                ),
              ),
            ),
          ));
        }),
      ],
    );
  }
}
