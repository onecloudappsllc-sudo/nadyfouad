import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_grocery/features/address/domain/models/address_model.dart';
import 'package:flutter_grocery/common/models/config_model.dart';
import 'package:flutter_grocery/features/order/enums/delivery_charge_type.dart';
import 'package:flutter_grocery/helper/checkout_helper.dart';
import 'package:flutter_grocery/localization/language_constraints.dart';
import 'package:flutter_grocery/features/address/providers/location_provider.dart';
import 'package:flutter_grocery/features/order/providers/order_provider.dart';
import 'package:flutter_grocery/features/splash/providers/splash_provider.dart';
import 'package:flutter_grocery/utill/dimensions.dart';
import 'package:flutter_grocery/utill/styles.dart';
import 'package:flutter_grocery/common/widgets/custom_shadow_widget.dart';
import 'package:flutter_grocery/features/checkout/widgets/add_address_dialog.dart';
import 'package:provider/provider.dart';
import 'package:shimmer_animation/shimmer_animation.dart';

class DeliveryAddressWidget extends StatelessWidget {
  final bool selfPickup;

  const DeliveryAddressWidget({
    Key? key, required this.selfPickup,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ConfigModel configModel = Provider.of<SplashProvider>(context, listen: false).configModel!;

    return !selfPickup ? CustomShadowWidget(
      margin: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault, vertical: Dimensions.paddingSizeSmall),
      child: Consumer<LocationProvider>(
        builder: (context, locationProvider, _) => Consumer<OrderProvider>(builder: (context, orderProvider, _) {

          bool isAvailable = false;

          AddressModel? deliveryAddress = CheckOutHelper.getDeliveryAddress(
            addressList: locationProvider.addressList,
            selectedAddress: orderProvider.addressIndex == -1 ? null : locationProvider.addressList?[orderProvider.addressIndex],
            lastOrderAddress: null,
          );

          print("-------------(CHECKOUT SCREEN DELIVERY ADDRESS)-------------${deliveryAddress?.toJson().toString()}");

          if(deliveryAddress != null &&
              (configModel.googleMapStatus ?? false) &&
              CheckOutHelper.getDeliveryChargeType() == DeliveryChargeType.distance.name
              && ((deliveryAddress.latitude != null && deliveryAddress.latitude!.isNotEmpty) && (deliveryAddress.longitude != null && deliveryAddress.longitude!.isNotEmpty))
          )
          {
            isAvailable = CheckOutHelper.isBranchAvailable(
              branches: configModel.branches ?? [],
              selectedBranch: configModel.branches![orderProvider.branchIndex],
              selectedAddress: deliveryAddress,
            );

            if(!isAvailable) {
              deliveryAddress = null;
            }
          }

          return locationProvider.addressList == null ? const _DeliverySectionShimmer() :  Padding(
            padding:  const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall, vertical: Dimensions.paddingSizeExtraSmall),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

              Row(mainAxisAlignment: MainAxisAlignment.start, children: [

                Text('${getTranslated('delivery_to', context)} -', style: poppinsMedium.copyWith(fontSize: Dimensions.fontSizeLarge)),
                const Expanded(child: SizedBox()),

                TextButton(
                  onPressed: ()=> showDialog(context: context, builder: (_)=> const AddAddressDialogWidget()),
                  child: Text(getTranslated(deliveryAddress == null || orderProvider.addressIndex == -1  ? 'add' : 'change', context), style: poppinsBold.copyWith(color: Theme.of(context).primaryColor)),
                ),

              ]),
              const SizedBox(height: Dimensions.paddingSizeDefault),

              deliveryAddress == null || orderProvider.addressIndex == -1 ? Padding(
                padding: const EdgeInsets.only(bottom: Dimensions.paddingSizeDefault),
                child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [

                  Icon(Icons.info_outline_rounded, color: Theme.of(context).colorScheme.error),
                  const SizedBox(width: Dimensions.paddingSizeSmall),

                  Text(getTranslated('no_contact_info_added', context), style: poppinsRegular.copyWith(color: Theme.of(context).colorScheme.error)),

                ]),
              ) : Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

                Row(children: [
                  Icon(Icons.person, color: Theme.of(context).primaryColor.withOpacity(0.5)),
                  const SizedBox(width: Dimensions.paddingSizeSmall),

                  Flexible(child: Text(deliveryAddress.contactPersonName ?? '')),

                ]),
                const SizedBox(height: Dimensions.paddingSizeSmall),

                Row(children: [
                  Icon(Icons.call, color: Theme.of(context).primaryColor.withOpacity(0.5)),
                  const SizedBox(width: Dimensions.paddingSizeSmall),

                  Text(deliveryAddress.contactPersonNumber ?? ''),
                ]),

                const Divider(height: Dimensions.paddingSizeDefault),

                Text(deliveryAddress.address ?? '', maxLines: 1, overflow: TextOverflow.ellipsis),
                const SizedBox(height: Dimensions.paddingSizeSmall),

                Row(mainAxisAlignment: MainAxisAlignment.start,children: [

                  if(deliveryAddress.houseNumber != null) Text(
                    '${getTranslated('house', context)} - ${deliveryAddress.houseNumber}',
                    maxLines: 1, overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(width: Dimensions.paddingSizeSmall),

                  if(deliveryAddress.floorNumber != null) Text(
                    '${getTranslated('floor', context)} - ${deliveryAddress.floorNumber}',
                    maxLines: 1, overflow: TextOverflow.ellipsis,
                  ),
                ]),
                const SizedBox(height: Dimensions.paddingSizeDefault),

              ]),

            ]),
          );
        }),
      ),
    ) : const SizedBox();
  }
}


class _DeliverySectionShimmer extends StatelessWidget {
  const _DeliverySectionShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer(child: Column(children: [
      Container(
        margin:  const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeSmall, horizontal: Dimensions.paddingSizeDefault),
        child: Column(children: [
          const SizedBox(height: Dimensions.paddingSizeSmall),

          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Container(height: 14, width: 200, decoration: BoxDecoration(color: Theme.of(context).shadowColor, borderRadius: BorderRadius.circular(2))),
            Container(height: 14, width: 50, decoration: BoxDecoration(color: Theme.of(context).shadowColor, borderRadius: BorderRadius.circular(2))),
          ]),

          const Divider(height: Dimensions.paddingSizeDefault),

          Column(
            children: [
              Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Container(height: Dimensions.paddingSizeLarge, width: Dimensions.paddingSizeLarge, decoration: BoxDecoration(color: Theme.of(context).shadowColor, borderRadius: BorderRadius.circular(2))),
                const SizedBox(width: Dimensions.paddingSizeLarge),

                Container(height: 14, width: 200, decoration: BoxDecoration(
                  color: Theme.of(context).shadowColor, borderRadius: BorderRadius.circular(2),
                )),
              ]),
              const SizedBox(height: Dimensions.paddingSizeSmall),

              Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Container(height: Dimensions.paddingSizeLarge, width: Dimensions.paddingSizeLarge, decoration: BoxDecoration(color: Theme.of(context).shadowColor, borderRadius: BorderRadius.circular(2))),
                const SizedBox(width: Dimensions.paddingSizeLarge),

                Container(height: 14, width: 250, decoration: BoxDecoration(
                  color: Theme.of(context).shadowColor, borderRadius: BorderRadius.circular(2),
                )),
              ]),
            ],
          ),

          const SizedBox(height: Dimensions.paddingSizeDefault),



        ]),
      ),


    ]));
  }
}
