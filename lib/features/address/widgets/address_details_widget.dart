
import 'package:flutter/material.dart';
import 'package:flutter_grocery/common/models/config_model.dart';
import 'package:flutter_grocery/features/address/domain/models/address_model.dart';
import 'package:flutter_grocery/features/address/widgets/map_with_lable_widget.dart';
import 'package:flutter_grocery/features/splash/providers/splash_provider.dart';
import 'package:flutter_grocery/helper/responsive_helper.dart';
import 'package:flutter_grocery/localization/language_constraints.dart';
import 'package:flutter_grocery/features/address/providers/location_provider.dart';
import 'package:flutter_grocery/utill/color_resources.dart';
import 'package:flutter_grocery/utill/dimensions.dart';
import 'package:flutter_grocery/utill/styles.dart';
import 'package:flutter_grocery/common/widgets/custom_text_field_widget.dart';
import 'package:flutter_grocery/common/widgets/phone_number_field_widget.dart';
import 'package:flutter_grocery/features/address/widgets/add_address_widget.dart';
import 'package:provider/provider.dart';

class AddressDetailsWidget extends StatefulWidget {
  final TextEditingController contactPersonNameController;
  final TextEditingController contactPersonNumberController;
  final FocusNode addressNode;
  final FocusNode nameNode;
  final FocusNode numberNode;
  final bool isEnableUpdate;
  final bool fromCheckout;
  final AddressModel? address;
  final TextEditingController streetNumberController;
  final TextEditingController houseNumberController;
  final TextEditingController florNumberController;
  final FocusNode stateNode;
  final FocusNode houseNode;
  final FocusNode florNode;
  final String countryCode;
  final Function(String value) onValueChange;


  const AddressDetailsWidget({
    super.key,
    required this.contactPersonNameController,
    required this.contactPersonNumberController,
    required this.addressNode, required this.nameNode,
    required this.numberNode,
    required this.isEnableUpdate,
    required this.fromCheckout,
    required this.address,
    required this.streetNumberController,
    required this.houseNumberController,
    required this.stateNode,
    required this.houseNode,
    required this.florNumberController,
    required this.florNode,
    required this.countryCode,
    required this.onValueChange,
  });

  @override
  State<AddressDetailsWidget> createState() => _AddressDetailsWidgetState();
}

class _AddressDetailsWidgetState extends State<AddressDetailsWidget> {
  final TextEditingController locationTextController = TextEditingController();

  @override
  void dispose() {
    locationTextController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    final ConfigModel? configModel = Provider.of<SplashProvider>(context, listen: false).configModel;
    final LocationProvider locationProvider = Provider.of<LocationProvider>(context, listen: false);
    if (!(configModel?.googleMapStatus ?? true)) {
      print("Here I am");
      locationTextController.text = locationProvider.address ?? '';
    }
  }

  @override
  Widget build(BuildContext context) {
    final LocationProvider locationProvider = Provider.of<LocationProvider>(context, listen: false);
    final ConfigModel? configModel = Provider.of<SplashProvider>(context, listen: false).configModel;
    final Size size = MediaQuery.of(context).size;
    print("----------(Address)---------${locationProvider.address}");
    if (widget.contactPersonNumberController.text.startsWith("0")) {
      widget.contactPersonNumberController.text =
          widget.contactPersonNumberController.text.replaceFirst("0", "");
    }

    return Container(
      decoration: ResponsiveHelper.isDesktop(context) ?  BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: ColorResources.cartShadowColor.withOpacity(0.2),
            blurRadius: 10,
          )
        ],
      ) : const BoxDecoration(),

      padding: ResponsiveHelper.isDesktop(context) ?  const EdgeInsets.symmetric(
        horizontal: Dimensions.paddingSizeLarge,
        vertical: Dimensions.paddingSizeLarge,
      ) : EdgeInsets.zero,

      child: Padding(padding: (configModel?.googleMapStatus ?? false) ? const EdgeInsets.all(0) : EdgeInsets.symmetric(horizontal: size.width * 0.1),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

          if(ResponsiveHelper.isDesktop(context))...[
            Expanded(
              child: Row(children: [

                Expanded(child: Column(mainAxisAlignment: MainAxisAlignment.spaceBetween, crossAxisAlignment: CrossAxisAlignment.start, children: [

                  // for Contact Person Name
                  Row(children: [

                    Expanded(child: CustomTextFieldWidget(
                      hintText: getTranslated('enter_contact_person_name', context),
                      title: getTranslated('contact_person_name', context),
                      isShowBorder: true,
                      inputType: TextInputType.name,
                      controller: widget.contactPersonNameController,
                      focusNode: widget.nameNode,
                      nextFocus: widget.numberNode,
                      inputAction: TextInputAction.next,
                      capitalization: TextCapitalization.words,
                    )),
                    const SizedBox(width: Dimensions.paddingSizeExtraSmall),

                    Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Text(getTranslated('contact_person_number', context),
                        style: poppinsMedium.copyWith(color: Theme.of(context).textTheme.bodyMedium?.color),
                      ),
                      const SizedBox(height: Dimensions.paddingSizeExtraSmall),

                      PhoneNumberFieldWidget(
                        onValueChange: widget.onValueChange,
                        countryCode: widget.countryCode,
                        phoneNumberTextController: widget.contactPersonNumberController,
                        phoneFocusNode: widget.numberNode,
                      ),

                    ]),
                    ),

                  ]),
                  const SizedBox(height: Dimensions.paddingSizeDefault),

                  Text(
                    getTranslated('label_us', context),
                    style: poppinsRegular.copyWith(
                      color: Theme.of(context).hintColor, fontSize: Dimensions.fontSizeLarge,
                    ),
                  ),
                  const SizedBox(height: Dimensions.paddingSizeExtraSmall),

                  SizedBox(height: 50, child: ListView.builder(
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    physics: const BouncingScrollPhysics(),
                    itemCount: locationProvider.getAllAddressType.length,
                    itemBuilder: (context, index) => InkWell(
                      onTap: () {
                        locationProvider.updateAddressIndex(index, true);
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          vertical: Dimensions.paddingSizeDefault,
                          horizontal: Dimensions.paddingSizeLarge,
                        ),
                        margin: const EdgeInsets.only(right: 17),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(Dimensions.paddingSizeSmall),
                          border: Border.all(color: locationProvider.selectAddressIndex == index
                              ? Theme.of(context).primaryColor : Theme.of(context).hintColor.withOpacity(0.6)
                          ),
                          color: locationProvider.selectAddressIndex == index
                              ? Theme.of(context).primaryColor : Theme.of(context).cardColor.withOpacity(0.9),
                        ),
                        child: Text(
                          getTranslated(locationProvider.getAllAddressType[index].toLowerCase(), context),
                          style: poppinsRegular.copyWith(
                            color: locationProvider.selectAddressIndex == index
                                ? Theme.of(context).cardColor
                                : Theme.of(context).hintColor.withOpacity(0.6),
                          ),

                        ),
                      ),
                    ),
                  )),
                  const SizedBox(height: Dimensions.paddingSizeDefault),

                  Text(getTranslated('address_line_01', context),
                    style: poppinsMedium.copyWith(color: Theme.of(context).textTheme.bodyMedium?.color),
                  ),
                  const SizedBox(height: Dimensions.paddingSizeSmall),

                  CustomTextFieldWidget(
                    onChanged: (String? value){
                      locationProvider.setAddress = value;
                    },
                    hintText: getTranslated('address_line_02', context),
                    isShowBorder: true,
                    inputType: TextInputType.streetAddress,
                    inputAction: TextInputAction.next,
                    focusNode: widget.addressNode,
                    nextFocus: widget.stateNode,
                    controller: (configModel?.googleMapStatus ?? false) ? (locationTextController..text = locationProvider.address ?? '') : locationTextController,
                  ),
                  const SizedBox(height: Dimensions.paddingSizeLarge),

                  Text('${getTranslated('street', context)} ${getTranslated('number', context)}',
                    style: poppinsMedium.copyWith(
                      color: Theme.of(context).textTheme.bodyMedium?.color,
                    ),
                  ),
                  const SizedBox(height: Dimensions.paddingSizeSmall),

                  CustomTextFieldWidget(
                    hintText: getTranslated('ex_10_th', context),
                    isShowBorder: true,
                    inputType: TextInputType.streetAddress,
                    inputAction: TextInputAction.next,
                    focusNode: widget.stateNode,
                    nextFocus: widget.houseNode,
                    controller: widget.streetNumberController,
                  ),
                  const SizedBox(height: Dimensions.paddingSizeLarge),

                  Text('${getTranslated('house', context)} / ${getTranslated('floor', context)} ${getTranslated('number', context)}',
                    style: poppinsMedium.copyWith(
                      color: Theme.of(context).textTheme.bodyMedium?.color,
                    ),
                  ),
                  const SizedBox(height: Dimensions.paddingSizeSmall),

                  Row(children: [

                    Expanded(child: CustomTextFieldWidget(
                      hintText: getTranslated('ex_2', context),
                      isShowBorder: true,
                      inputType: TextInputType.streetAddress,
                      inputAction: TextInputAction.next,
                      focusNode: widget.houseNode,
                      nextFocus: widget.florNode,
                      controller: widget.houseNumberController,
                    )),
                    const SizedBox(width: Dimensions.paddingSizeLarge),

                    Expanded(
                      child: CustomTextFieldWidget(
                        hintText: getTranslated('ex_2b', context),
                        isShowBorder: true,
                        inputType: TextInputType.streetAddress,
                        inputAction: TextInputAction.next,
                        focusNode: widget.florNode,
                        nextFocus: widget.nameNode,
                        controller: widget.florNumberController,
                      ),
                    ),

                  ]),
                  const SizedBox(height: Dimensions.paddingSizeLarge),


                ])),
                const SizedBox(width: Dimensions.paddingSizeLarge),

                if(configModel?.googleMapStatus ?? false)Expanded(
                  child: MapWithLabelWidget(
                    isEnableUpdate: widget.isEnableUpdate,
                    fromCheckout: widget.fromCheckout,
                    address: widget.address,
                  ),
                ),

              ]),
            ),
            Row(children: [

              Expanded(flex : 2, child: Container()),

              Expanded(
                child: Padding(padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeLarge),
                  child: AddAddressWidget(
                    isEnableUpdate: widget.isEnableUpdate,
                    fromCheckout: widget.fromCheckout,
                    contactPersonNumberController: widget.contactPersonNumberController,
                    contactPersonNameController: widget.contactPersonNameController,
                    address: widget.address,
                    streetNumberController: widget.streetNumberController,
                    houseNumberController: widget.houseNumberController,
                    floorNumberController: widget.florNumberController,
                    countryCode: widget.countryCode,
                  ),
                ),
              ),

            ],),
          ],

          if(!ResponsiveHelper.isDesktop(context))...[
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 24.0),
              child: Text(
                getTranslated('delivery_address', context),
                style:
                Theme.of(context).textTheme.displaySmall!.copyWith(color: Theme.of(context).hintColor.withOpacity(0.6), fontSize: Dimensions.fontSizeLarge),
              ),
            ),

            // for Address Field
            Text(
              getTranslated('address_line_01', context),
              style: poppinsRegular.copyWith(color: Theme.of(context).hintColor.withOpacity(0.6)),
            ),
            const SizedBox(height: Dimensions.paddingSizeSmall),

            CustomTextFieldWidget(
              onChanged: (String? value){
                locationProvider.setAddress = value;
              },
              hintText: getTranslated('address_line_02', context),
              isShowBorder: true,
              inputType: TextInputType.streetAddress,
              inputAction: TextInputAction.next,
              focusNode: widget.addressNode,
              nextFocus: widget.stateNode,
              controller: (configModel?.googleMapStatus ?? false) ? (locationTextController..text = locationProvider.address ?? '') : locationTextController,
            ),
            const SizedBox(height: Dimensions.paddingSizeLarge),

            Text(
              '${getTranslated('street', context)} ${getTranslated('number', context)}',
              style: poppinsRegular.copyWith(color: Theme.of(context).hintColor.withOpacity(0.6)),
            ),
            const SizedBox(height: Dimensions.paddingSizeSmall),

            CustomTextFieldWidget(
              hintText: getTranslated('ex_10_th', context),
              isShowBorder: true,
              inputType: TextInputType.streetAddress,
              inputAction: TextInputAction.next,
              focusNode: widget.stateNode,
              nextFocus: widget.houseNode,
              controller: widget.streetNumberController,
            ),
            const SizedBox(height: Dimensions.paddingSizeLarge),

            Text(
              '${getTranslated('house', context)} / ${
                  getTranslated('floor', context)} ${
                  getTranslated('number', context)}',
              style: poppinsRegular.copyWith(color: Theme.of(context).hintColor.withOpacity(0.6)),
            ),
            const SizedBox(height: Dimensions.paddingSizeSmall),
            Row(children: [
              Expanded(
                child: CustomTextFieldWidget(
                  hintText: getTranslated('ex_2', context),
                  isShowBorder: true,
                  inputType: TextInputType.streetAddress,
                  inputAction: TextInputAction.next,
                  focusNode: widget.houseNode,
                  nextFocus: widget.florNode,
                  controller: widget.houseNumberController,
                ),
              ),

              const SizedBox(width: Dimensions.paddingSizeLarge),

              Expanded(
                child: CustomTextFieldWidget(
                  hintText: getTranslated('ex_2b', context),
                  isShowBorder: true,
                  inputType: TextInputType.streetAddress,
                  inputAction: TextInputAction.next,
                  focusNode: widget.florNode,
                  nextFocus: widget.nameNode,
                  controller: widget.florNumberController,
                ),
              ),

            ],),
            const SizedBox(height: Dimensions.paddingSizeLarge),

            // for Contact Person Name
            Text(
              getTranslated('contact_person_name', context),
              style: poppinsRegular.copyWith(color: Theme.of(context).hintColor.withOpacity(0.6)),
            ),
            const SizedBox(height: Dimensions.paddingSizeSmall),

            CustomTextFieldWidget(
              hintText: getTranslated('enter_contact_person_name', context),
              isShowBorder: true,
              inputType: TextInputType.name,
              controller: widget.contactPersonNameController,
              focusNode: widget.nameNode,
              nextFocus: widget.numberNode,
              inputAction: TextInputAction.next,
              capitalization: TextCapitalization.words,
            ),
            const SizedBox(height: Dimensions.paddingSizeLarge),

            // for Contact Person Number
            Text(
              getTranslated('contact_person_number', context),
              style: poppinsRegular.copyWith(color: Theme.of(context).hintColor.withOpacity(0.6)),
            ),
            const SizedBox(height: Dimensions.paddingSizeSmall),

            PhoneNumberFieldWidget(
              onValueChange: widget.onValueChange,
              countryCode: widget.countryCode,
              phoneNumberTextController: widget.contactPersonNumberController,
              phoneFocusNode: widget.numberNode,
            ),
          ],




        ]),
      )
    );
  }
}