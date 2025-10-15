import 'package:flutter/material.dart';
import 'package:flutter_grocery/features/address/domain/models/address_model.dart';
import 'package:flutter_grocery/features/order/enums/delivery_charge_type.dart';
import 'package:flutter_grocery/features/splash/providers/splash_provider.dart';
import 'package:flutter_grocery/helper/checkout_helper.dart';
import 'package:flutter_grocery/helper/route_helper.dart';
import 'package:flutter_grocery/localization/language_constraints.dart';
import 'package:flutter_grocery/features/address/providers/location_provider.dart';
import 'package:flutter_grocery/features/order/providers/order_provider.dart';
import 'package:flutter_grocery/utill/dimensions.dart';
import 'package:flutter_grocery/utill/images.dart';
import 'package:flutter_grocery/utill/styles.dart';
import 'package:flutter_grocery/common/widgets/custom_button_widget.dart';
import 'package:flutter_grocery/features/address/widgets/adress_widget.dart';
import 'package:provider/provider.dart';

class AddAddressDialogWidget extends StatelessWidget {
  const AddAddressDialogWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final  OrderProvider orderProvider = Provider.of<OrderProvider>(context, listen: false);

    return Dialog(child: Consumer<LocationProvider>(
      builder: (context, locationProvider, _) {

        bool isNotEmptyAddress = (locationProvider.addressList != null && locationProvider.addressList!.isNotEmpty);

        return Container(
          constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height * 0.8),
          width: (Dimensions.webScreenWidth / 2),
          child: Column(mainAxisSize: MainAxisSize.min, children: [

            Align(alignment: Alignment.topRight,
              child: IconButton(
                onPressed: ()=> Navigator.pop(context),
                icon: Icon(Icons.clear, color: Theme.of(context).disabledColor),
              ),
            ),

            Text(getTranslated(isNotEmptyAddress ? 'select_form_saved_address' : 'you_have_to_save_address' , context),
              style: poppinsMedium.copyWith(fontSize: Dimensions.fontSizeLarge),
            ),
            const SizedBox(height: Dimensions.paddingSizeSmall),

            // if(isNotEmptyAddress) const CurrentLocationButton(isBorder: false),

            if(!isNotEmptyAddress) Image.asset(Images.locationBannerImage, height: 120, width: 120),

            if(!isNotEmptyAddress) Padding(
              padding: const EdgeInsets.symmetric(horizontal: Dimensions.fontSizeExtraSmall),
              child: Text(getTranslated('you_dont_have_any_saved_address_yet', context),
                style: poppinsLight,
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: Dimensions.paddingSizeLarge),

            Flexible(child: SingleChildScrollView(
              child: Column(mainAxisSize: MainAxisSize.min, children: [
                locationProvider.addressList != null ? locationProvider.addressList!.isNotEmpty ? ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                  itemCount: locationProvider.addressList?.length,
                  itemBuilder: (context, index) {

                    bool isDistanceWiseDelivery = CheckOutHelper.getDeliveryChargeType() == DeliveryChargeType.distance.name;
                    AddressModel? addressModel = locationProvider.addressList?[index];

                    bool isAddressAvailableForDelivery = true;

                    if(isDistanceWiseDelivery && (addressModel?.latitude == null && addressModel?.longitude == null)){
                      isAddressAvailableForDelivery = false;
                    }

                    return Center(child: SizedBox(width: 700, child: AddressWidget(
                      fromSelectAddress: true,
                      addressModel: locationProvider.addressList![index],
                      index: index,
                      isAvailableForDelivery: isAddressAvailableForDelivery,
                    )));
                  },
                ) : const SizedBox() : const Center(child: CircularProgressIndicator()),
              ]),
            )),
            const SizedBox(height: Dimensions.paddingSizeLarge),

            TextButton.icon(
              onPressed: () async {
                Navigator.pop(context);
                await Navigator.pushNamed(context, RouteHelper.getAddAddressRoute('checkout', 'add', AddressModel()));
                await locationProvider.initAddressList();

                CheckOutHelper.selectDeliveryAddressAuto(
                  isLoggedIn: true,
                  orderType: orderProvider.getCheckOutData?.orderType,
                  lastAddress: null,
                );
              },
              icon: Icon(Icons.add_circle_outline_sharp, color: Theme.of(context).primaryColor),
              label: Text(getTranslated('add_new_address', context), style: poppinsMedium.copyWith(color: Theme.of(context).primaryColor)),
            ),

            isNotEmptyAddress? CustomButtonWidget(
              margin: Dimensions.paddingSizeDefault,
              buttonText: getTranslated('select', context), onPressed: ()=>  Navigator.pop(context),
            ) : const SizedBox(height: Dimensions.paddingSizeDefault),

          ]),
        );
      },
    ));
  }
}