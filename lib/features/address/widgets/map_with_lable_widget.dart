
import 'package:flutter/material.dart';
import 'package:flutter_grocery/common/models/config_model.dart';
import 'package:flutter_grocery/common/widgets/custom_asset_image_widget.dart';
import 'package:flutter_grocery/common/widgets/custom_button_widget.dart';
import 'package:flutter_grocery/features/address/domain/models/address_model.dart';
import 'package:flutter_grocery/features/address/providers/location_provider.dart';
import 'package:flutter_grocery/features/address/screens/select_location_screen.dart';
import 'package:flutter_grocery/features/address/widgets/map_widget.dart';
import 'package:flutter_grocery/features/splash/providers/splash_provider.dart';
import 'package:flutter_grocery/helper/responsive_helper.dart';
import 'package:flutter_grocery/localization/language_constraints.dart';
import 'package:flutter_grocery/utill/color_resources.dart';
import 'package:flutter_grocery/utill/dimensions.dart';
import 'package:flutter_grocery/utill/images.dart';
import 'package:flutter_grocery/utill/styles.dart';
import 'package:provider/provider.dart';

class MapWithLabelWidget extends StatelessWidget {
  final bool isEnableUpdate;
  final bool fromCheckout;
  final AddressModel? address;

  const MapWithLabelWidget({
    super.key,
    required this.isEnableUpdate,
    required this.fromCheckout,
    this.address,
  });

  @override
  Widget build(BuildContext context) {
    final LocationProvider locationProvider = Provider.of<LocationProvider>(context, listen: false);
    final ConfigModel? configModel = Provider.of<SplashProvider>(context, listen: false).configModel;
    final Size size = MediaQuery.of(context).size;

    print("-------(MAP with Label Widget)-------${locationProvider.pickedAddressLatitude} and ${locationProvider.pickedAddressLongitude} and ${address?.toJson()}");

    return Container(
      padding: ResponsiveHelper.isDesktop(context) ?  const EdgeInsets.symmetric(
        horizontal: Dimensions.paddingSizeLarge,vertical: Dimensions.paddingSizeLarge,
      ) : EdgeInsets.zero,

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          if((configModel?.googleMapStatus ?? false))...[


            if(address != null)...[

              if(locationProvider.pickedAddressLatitude == null && locationProvider.pickedAddressLongitude == null)...[
                ClipRRect(
                  borderRadius: BorderRadius.circular(Dimensions.paddingSizeSmall),
                  child:  Stack(clipBehavior: Clip.none, children: [

                    CustomAssetImageWidget(
                      Images.noMapBackground,
                      fit: BoxFit.cover,
                      height: ResponsiveHelper.isDesktop(context) ? size.height * 0.5 : size.height * 0.2,
                      width: MediaQuery.of(context).size.width,
                      color: Colors.black.withOpacity(0.5),
                      colorBlendMode: BlendMode.darken,
                    ),

                    Positioned.fill(child: Center(
                      child: Column(mainAxisAlignment: MainAxisAlignment.center,children: [

                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeLarge),
                          child: Text(getTranslated('add_location_from_map_your_precise_location', context),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.center,
                            style: poppinsRegular.copyWith(color: Theme.of(context).cardColor, fontSize: Dimensions.fontSizeLarge
                            ),
                          ),
                        ),
                        const SizedBox(height: Dimensions.paddingSizeExtraLarge),

                        Row(children: [

                          Expanded(child: Container()),

                          Expanded(child: CustomButtonWidget(
                            isLoading: locationProvider.isLoading,
                            buttonText: getTranslated('go_to_map', context),
                            onPressed: ()async{

                              Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) =>  const SelectLocationScreen(),
                              ));

                            },
                            backgroundColor: Theme.of(context).cardColor,
                            textStyle: poppinsBold.copyWith(
                              color: Theme.of(context).primaryColor,
                            ),
                          ),
                          ),

                          Expanded(child: Container()),
                        ]),


                      ]),
                    ),),

                  ],),
                )
              ],

              if(locationProvider.pickedAddressLatitude != null && locationProvider.pickedAddressLongitude != null)...[
                if(ResponsiveHelper.isDesktop(context)) Expanded(child: MapWidget(
                  fromCheckout: fromCheckout,
                  isEnableUpdate: isEnableUpdate,
                  address: address,
                )),

                if(!ResponsiveHelper.isDesktop(context)) MapWidget(
                  fromCheckout: fromCheckout,
                  isEnableUpdate: isEnableUpdate,
                  address: address,
                ),

                Padding(padding: const EdgeInsets.only(top: 10), child: Center(child: Text(
                  getTranslated('add_the_location_correctly', context),
                  style: poppinsRegular.copyWith(
                    color: Theme.of(context).textTheme.bodyLarge!.color,
                    fontSize: Dimensions.fontSizeSmall,
                  ),
                ))),
              ],

            ],

            if(address == null)...[
              if(ResponsiveHelper.isDesktop(context)) Expanded(child: MapWidget(
                fromCheckout: fromCheckout,
                isEnableUpdate: isEnableUpdate,
                address: address,
              )),

              if(!ResponsiveHelper.isDesktop(context)) MapWidget(
                fromCheckout: fromCheckout,
                isEnableUpdate: isEnableUpdate,
                address: address,
              ),

              Padding(padding: const EdgeInsets.only(top: 10), child: Center(child: Text(
                getTranslated('add_the_location_correctly', context),
                style: poppinsRegular.copyWith(
                  color: Theme.of(context).textTheme.bodyLarge!.color,
                  fontSize: Dimensions.fontSizeSmall,
                ),
              ))),
            ],


          ],






        ],
      ),
    );
  }
}
