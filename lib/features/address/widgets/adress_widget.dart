
import 'package:flutter/material.dart';
import 'package:flutter_grocery/features/address/domain/models/address_model.dart';
import 'package:flutter_grocery/common/models/config_model.dart';
import 'package:flutter_grocery/features/order/enums/delivery_charge_type.dart';
import 'package:flutter_grocery/helper/checkout_helper.dart';
import 'package:flutter_grocery/helper/route_helper.dart';
import 'package:flutter_grocery/localization/language_constraints.dart';
import 'package:flutter_grocery/features/address/providers/location_provider.dart';
import 'package:flutter_grocery/features/order/providers/order_provider.dart';
import 'package:flutter_grocery/features/splash/providers/splash_provider.dart';
import 'package:flutter_grocery/utill/dimensions.dart';
import 'package:flutter_grocery/utill/styles.dart';
import 'package:flutter_grocery/helper/custom_snackbar_helper.dart';
import 'package:provider/provider.dart';
class AddressWidget extends StatelessWidget {

  final AddressModel addressModel;
  final int index;
  final bool fromSelectAddress;
  final bool? isAvailableForDelivery;
  const AddressWidget({super.key, required this.addressModel, required this.index, this.fromSelectAddress = false, this.isAvailableForDelivery});

  @override
  Widget build(BuildContext context) {
    final LocationProvider locationProvider = Provider.of<LocationProvider>(context, listen: false);
    final OrderProvider orderProvider = Provider.of<OrderProvider>(context, listen: false);
    final ConfigModel configModel = Provider.of<SplashProvider>(context, listen: false).configModel!;

      return Padding(
        padding: const EdgeInsets.only(bottom: Dimensions.paddingSizeSmall),
        child: InkWell(
          onTap: () async {
            if(fromSelectAddress && (isAvailableForDelivery ?? false)){
              if((configModel.googleMapStatus ?? false) && CheckOutHelper.getDeliveryChargeType() == DeliveryChargeType.distance.name){
                bool isAvailable = CheckOutHelper.isBranchAvailable(
                  branches: configModel.branches ?? [],
                  selectedBranch: configModel.branches![orderProvider.branchIndex],
                  selectedAddress: locationProvider.addressList![index],
                );

                print("-----------(ADDRESS WIDGET)-----------------------IsAvailable: $isAvailable, Index: $index");

                CheckOutHelper.selectDeliveryAddress(
                  isAvailable: isAvailable, index: index, configModel: configModel,
                  locationProvider: locationProvider, orderProvider: orderProvider,
                  fromAddressList: true,
                );
              }else{
                CheckOutHelper.selectDeliveryAddress(
                  isAvailable: true, index: index, configModel: configModel,
                  locationProvider: locationProvider, orderProvider: orderProvider,
                  fromAddressList: true,
                );
              }

              final isDialogOpen = ModalRoute.of(context).runtimeType == DialogRoute;
              if(isDialogOpen){
                Navigator.pop(context);
              }
            }
          },
          child: Stack(children: [

            Container(
              padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
              decoration: BoxDecoration(
                border: fromSelectAddress && index == locationProvider.selectAddressIndex ? Border.all(width: 1, color: Theme.of(context).primaryColor) : null,
                borderRadius: BorderRadius.circular(7),
                color: Theme.of(context).cardColor,
                boxShadow: [
                  BoxShadow(color: Theme.of(context).shadowColor, spreadRadius: 0.5, blurRadius: 0.5)
                ],
              ),
              child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [

                Expanded(flex: 2, child: Row(children: [
                  fromSelectAddress ? Radio(
                    activeColor: Theme.of(context).primaryColor,
                    value: index,
                    groupValue: locationProvider.selectAddressIndex,
                    onChanged: (_){},
                  ) : Icon(Icons.location_on, color: Theme.of(context).primaryColor, size: 25),
                  const SizedBox(width: Dimensions.paddingSizeDefault),

                  Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.center, children: [

                    Text(addressModel.addressType!, style: poppinsMedium.copyWith(
                      fontSize: Dimensions.fontSizeLarge,
                    )),

                    Text(addressModel.address!, maxLines: fromSelectAddress ? 1 : 3, style: poppinsRegular.copyWith(
                      color: Theme.of(context).textTheme.bodyLarge?.color?.withOpacity(0.6), fontSize: Dimensions.fontSizeLarge,
                    )),

                  ]))

                ])),

                if(!fromSelectAddress) PopupMenuButton<String>(
                  padding: const EdgeInsets.all(0),
                  onSelected: (String result) {
                    if (result == 'delete') {
                      showDialog(context: context, barrierDismissible: false, builder: (context) => Center(
                        child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor),
                        ),
                      ));

                      Provider.of<LocationProvider>(context, listen: false).deleteUserAddressByID(addressModel.id, index, (bool isSuccessful, String message) {
                        Navigator.pop(context);showCustomSnackBarHelper(message, isError: isSuccessful);
                      });

                    }else {
                      Provider.of<LocationProvider>(context, listen: false).updateAddressStatusMessage(message: '');
                      Navigator.of(context).pushNamed(RouteHelper.getUpdateAddressRoute(addressModel),
                        // arguments: AddNewAddressScreen(isEnableUpdate: true, address: addressModel),
                      );
                    }
                  },
                  itemBuilder: (BuildContext c) => <PopupMenuEntry<String>>[

                    PopupMenuItem<String>(
                      value: 'edit',
                      child: Text(getTranslated('edit', context), style: poppinsMedium),
                    ),

                    PopupMenuItem<String>(
                      value: 'delete',
                      child: Text(getTranslated('delete', context), style: poppinsMedium),
                    ),

                  ],
                ),
              ]),
            ),

            if(fromSelectAddress && !(isAvailableForDelivery ?? false))...[
              Positioned.fill(
                child: Container(
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(Dimensions.paddingSizeSmall),
                    color: Theme.of(context).textTheme.bodyMedium?.color?.withOpacity(0.6),
                  ),
                  child: Text(
                    getTranslated('out_of_coverage_for_this_branch', context),
                    textAlign: TextAlign.center, maxLines: 2, overflow: TextOverflow.ellipsis,
                    style: poppinsRegular.copyWith(color: Colors.white, fontSize: 10),
                  ),
                ),

              ),
            ],

          ]),
        ),
      );
    }
}
