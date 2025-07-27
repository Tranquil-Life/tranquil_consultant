import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:tl_consultant/core/constants/constants.dart';
import 'package:tl_consultant/core/theme/colors.dart';
import 'package:tl_consultant/core/theme/fonts.dart';
import 'package:tl_consultant/core/utils/helpers/size_helper.dart';
import 'package:tl_consultant/core/utils/helpers/svg_elements.dart';
import 'package:tl_consultant/features/wallet/domain/entities/banks.dart';
import 'package:tl_consultant/features/wallet/presentation/controllers/earnings_controller.dart';
import 'package:tl_consultant/features/wallet/presentation/widgets/form_fields.dart';

class BankInfoFields extends StatefulWidget {
  const BankInfoFields({super.key, required this.earningsController});

  final EarningsController earningsController;

  @override
  State<BankInfoFields> createState() => _BankInfoFieldsState();
}

class _BankInfoFieldsState extends State<BankInfoFields> {
  var banks = [];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("BANK INFO", style: TextStyle(fontSize: AppFonts.baseSize)),
        SizedBox(height: 12),
        Text(
          "Bank name",
          style: TextStyle(color: ColorPalette.grey[600]),
        ),
        const SizedBox(height: 8),
        bankNameField(widget.earningsController, () {
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
                      'Select bank',
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
            content: StatefulBuilder(builder: (context, setState) {
              void getBanks() async {
                banks = await Banks().getBanks();
                setState(() {});
              }

              getBanks();

              return SizedBox(
                width: double.maxFinite,
                height: displayHeight(context),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                        "Select the recipient financial institution from the list below"),
                    SizedBox(height: 40),
                    banks.isEmpty
                        ? Center(
                            child: CircularProgressIndicator(
                            color: ColorPalette.green,
                          ))
                        : ListView.builder(
                            shrinkWrap: true,
                            itemCount: banks.length,
                            itemBuilder: (context, index) {
                              final bank = banks[index];
                              return ListTile(
                                leading: Checkbox(
                                    activeColor: ColorPalette.green,
                                    value: widget.earningsController.bankNameTEC
                                            .text ==
                                        bank,
                                    onChanged: (val) {}),
                                title: Text(bank),
                                onTap: () {
                                  widget.earningsController.bankNameTEC.text =
                                      bank;
                                  setState(() {});
                                },
                              );
                            },
                          ),
                  ],
                ),
              );
            }),
          ));
        }),
        SizedBox(height: 12),
        Text(
          "Bank address (Optional)",
          style: TextStyle(color: ColorPalette.grey[600]),
        ),
        const SizedBox(height: 8),
        bankAddressField(widget.earningsController, () {
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
                      'Select bank branch',
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
                    Text("Select the address for your local bank branch"),
                    SizedBox(height: 40),
                    Text("Country"),
                    const SizedBox(height: 8),
                    Obx(
                      () => bankCountryField(widget.earningsController, () {
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
                                    widget.earningsController.bankCountryTEC
                                        .text = country;
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
                    Obx(() =>
                        bankStateField(widget.earningsController, () async {
                          if(!widget.earningsController.isStateDropdownVisible.value){
                            await widget.earningsController.getStates(
                                country: widget
                                    .earningsController.bankCountryTEC.text);
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
                                var stateCode = "${state['state_code']}";
                                return ListTile(
                                  title: Text(name),
                                  onTap: () async{
                                    widget.earningsController.bankStateTEC
                                        .text = name;
                                    widget.earningsController
                                        .isStateDropdownVisible.value = false;

                                    await widget.earningsController.getBankBranches();
                                  },
                                );
                              },
                            ),
                          )
                        : const SizedBox.shrink()),

                Obx(() => widget.earningsController.availableBranches.isNotEmpty
                    ? ConstrainedBox(
                  constraints: const BoxConstraints(maxHeight: 400), // Give enough space
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("AVAILABLE BRANCHES"),
                      const SizedBox(height: 8),
                      Expanded( // 👈 This allows ListView to scroll within available space
                        child: ListView.builder(
                          padding: const EdgeInsets.only(top: 8),
                          itemCount:
                          widget.earningsController.availableBranches.length,
                          itemBuilder: (context, index) {
                            final branch =
                            widget.earningsController.availableBranches[index];

                            return ListTile(
                              title: Text(branch),
                              onTap: () {
                                // Handle branch selection
                              },
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                )
                    : const SizedBox.shrink())

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
