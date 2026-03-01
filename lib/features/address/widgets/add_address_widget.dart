
import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_grocery/common/widgets/custom_loader_widget.dart';
import 'package:flutter_grocery/features/address/domain/models/address_model.dart';
import 'package:flutter_grocery/common/models/config_model.dart';
import 'package:flutter_grocery/helper/responsive_helper.dart';
import 'package:flutter_grocery/localization/language_constraints.dart';
import 'package:flutter_grocery/features/address/providers/location_provider.dart';
import 'package:flutter_grocery/features/order/providers/order_provider.dart';
import 'package:flutter_grocery/features/splash/providers/splash_provider.dart';
import 'package:flutter_grocery/utill/dimensions.dart';
import 'package:flutter_grocery/common/widgets/custom_button_widget.dart';
import 'package:flutter_grocery/helper/custom_snackbar_helper.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';

class AddAddressWidget extends StatelessWidget {
  final bool isEnableUpdate;
  final bool fromCheckout;
  final TextEditingController contactPersonNameController;
  final TextEditingController contactPersonNumberController;
  final TextEditingController streetNumberController;
  final TextEditingController houseNumberController;
  final TextEditingController floorNumberController;
  final AddressModel? address;
  final String countryCode;

  const AddAddressWidget({
    super.key,
    required this.isEnableUpdate,
    required this.fromCheckout,
    required this.contactPersonNumberController,
    required this.contactPersonNameController,
    required this.address,
    required this.streetNumberController,
    required this.floorNumberController,
    required this.houseNumberController,
    required this.countryCode,
  });

  @override
  Widget build(BuildContext context) {
    final LocationProvider locationProvider = Provider.of<LocationProvider>(context, listen: false);

    return Column(children: [

      locationProvider.addressStatusMessage != null ? Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          locationProvider.addressStatusMessage!.isNotEmpty ? const CircleAvatar(backgroundColor: Colors.green, radius: 5) : const SizedBox.shrink(),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              locationProvider.addressStatusMessage ?? "",
              style:
              Theme.of(context).textTheme.displayMedium!.copyWith(fontSize: Dimensions.fontSizeSmall, color: Colors.green, height: 1),
            ),
          )
        ],
      )  : Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          locationProvider.errorMessage!.isNotEmpty
              ? const CircleAvatar(backgroundColor: Colors.red, radius: 5)
              : const SizedBox.shrink(),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              locationProvider.errorMessage ?? "",
              style: Theme.of(context).textTheme.displayMedium!.copyWith(
                fontSize: Dimensions.fontSizeSmall,
                color: Colors.red,
                height: 1,
              ),
            ),
          )
        ],
      ),
      SizedBox(height: ResponsiveHelper.isDesktop(context) ?  0 : Dimensions.paddingSizeSmall),

      Container(
        height: 50.0,
        width: Dimensions.webScreenWidth,
        margin: const EdgeInsets.all(Dimensions.paddingSizeSmall),
        child: !locationProvider.isLoading ? CustomButtonWidget(
          buttonText: isEnableUpdate ? getTranslated('update_address', context) : getTranslated('save_location', context),
          onPressed: locationProvider.loading ? null : () {
            final SplashProvider splashProvider = Provider.of<SplashProvider>(context, listen: false);
            List<Branches> branches = splashProvider.configModel!.branches!;
            bool isAvailable = branches.length == 1;
            print('isAvailableisAvailableisAvailableisAvailableisAvailableisAvailableisAvailableisAvailableisAvailableisAvailableisAvailableisAvailableisAvailable');
            print(isAvailable);
            print( branches.length);
            print( branches[0].latitude);
            if(!isAvailable) {
              if(splashProvider.configModel?.googleMapStatus ?? false){
                for (Branches branch in branches) {
                  double distance = Geolocator.distanceBetween(
                    double.parse(branch.latitude!), double.parse(branch.longitude!),
                    locationProvider.position.latitude, locationProvider.position.longitude,
                  ) / 1000;
                  if (distance < branch.coverage!) {
                    isAvailable = true;
                    break;
                  }
                }
              }else{
                isAvailable = true;
              }

            }
            if(!isAvailable) {
              showCustomSnackBarHelper(getTranslated('service_is_not_available', context));
            }else {
              AddressModel addressModel = AddressModel(
                addressType: locationProvider.getAllAddressType[locationProvider.selectAddressIndex],
                contactPersonName: contactPersonNameController.text,
                contactPersonNumber: contactPersonNumberController.text.trim().isEmpty ? '' : '${CountryCode.fromCountryCode(countryCode).dialCode}${contactPersonNumberController.text.trim()}',
                address: locationProvider.address ?? '',
                latitude: (splashProvider.configModel?.googleMapStatus ?? false) ? locationProvider.position.latitude.toString() : null,
                longitude: (splashProvider.configModel?.googleMapStatus ?? false) ? locationProvider.position.longitude.toString() : null,
                floorNumber: floorNumberController.text,
                houseNumber: houseNumberController.text,
                streetNumber: streetNumberController.text,
              );
              if (isEnableUpdate) {
                addressModel.id = address!.id;
                addressModel.userId = address!.userId;
                addressModel.method = 'put';
                locationProvider.updateAddress(context, addressModel: addressModel, addressId: addressModel.id).then((value) {});
              } else {
                locationProvider.addAddress(addressModel, context).then((value) {

                  if (value.isSuccess) {
                    // Navigator.pop(context);
                    if (fromCheckout) {
                      Provider.of<LocationProvider>(context, listen: false).initAddressList();
                      Provider.of<OrderProvider>(context, listen: false).setAddressIndex(-1);
                    } else {
                      showCustomSnackBarHelper(value.message?? '', isError: false);
                    }
                    Navigator.pop(context);
                  } else {
                    showCustomSnackBarHelper(value.message!);
                  }
                });
              }
            }
          },
        ) : Center(child: CustomLoaderWidget(color: Theme.of(context).primaryColor)),
      )
    ]);
  }
}