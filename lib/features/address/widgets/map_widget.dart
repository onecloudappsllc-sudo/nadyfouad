
import 'package:flutter/material.dart';
import 'package:flutter_grocery/features/address/domain/models/address_model.dart';
import 'package:flutter_grocery/features/address/providers/location_provider.dart';
import 'package:flutter_grocery/features/address/screens/select_location_screen.dart';
import 'package:flutter_grocery/features/address/widgets/search_dialog_widget.dart';
import 'package:flutter_grocery/features/splash/providers/splash_provider.dart';
import 'package:flutter_grocery/helper/address_helper.dart';
import 'package:flutter_grocery/helper/responsive_helper.dart';
import 'package:flutter_grocery/helper/route_helper.dart';
import 'package:flutter_grocery/utill/dimensions.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

class MapWidget extends StatelessWidget {
  final bool isEnableUpdate;
  final bool fromCheckout;
  final AddressModel? address;

  const MapWidget({
    Key? key, required this.isEnableUpdate, this.address, required this.fromCheckout,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final LocationProvider locationProvider = Provider.of<LocationProvider>(context, listen: false);

    final branch = Provider.of<SplashProvider>(context, listen: false).configModel!.branches![0];

    print("-----(MAP WIDGET)-------------${locationProvider.pickedAddressLatitude} and ${locationProvider.pickedAddressLongitude} and Is Enable Update : $isEnableUpdate");
    return SizedBox(
      height: ResponsiveHelper.isMobile() ? 130 : 250,
      width: MediaQuery.of(context).size.width,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(Dimensions.paddingSizeSmall),
        child: Stack(
            clipBehavior: Clip.none, children: [
          GoogleMap(
            minMaxZoomPreference: const MinMaxZoomPreference(0, 16),
            mapType: MapType.normal,
            initialCameraPosition: CameraPosition(
              target: (isEnableUpdate && (locationProvider.pickedAddressLatitude?.isNotEmpty ?? false) && (locationProvider.pickedAddressLongitude?.isNotEmpty ?? false)) ? LatLng(
                double.parse(locationProvider.pickedAddressLatitude!),
                double.parse(locationProvider.pickedAddressLongitude!),
              ) : LatLng(locationProvider.position.latitude.toInt()  == 0
                  ? double.parse(branch.latitude!)
                  : locationProvider.position.latitude, locationProvider.position.longitude.toInt() == 0
                  ? double.parse(branch.longitude!)
                  : locationProvider.position.longitude,
              ),
              zoom: 8,
            ),
            zoomControlsEnabled: false,
            compassEnabled: false,
            indoorViewEnabled: true,
            mapToolbarEnabled: false,
            onCameraIdle: () {
              if(address != null && !fromCheckout) {
                locationProvider.updatePosition(locationProvider.cameraPosition, true, null);
                locationProvider.isUpdateAddress = true;
              }else {
                if(locationProvider.isUpdateAddress) {
                  locationProvider.updatePosition(locationProvider.cameraPosition, true, null);
                }else {
                  locationProvider.isUpdateAddress = true;
                }
              }

            },
            onCameraMove: ((position) => locationProvider.cameraPosition = position),
            onMapCreated: (GoogleMapController controller) {

              if (!isEnableUpdate && locationProvider.mapController != null) {
                AddressHelper.checkPermission(() =>
                    locationProvider.getCurrentLocation(
                      context, true, mapController: locationProvider.mapController,
                    ));
              }


              locationProvider.mapController = controller;

              print("----------------(WHEN CREATING LAT LON)----------------${locationProvider.pickedAddressLatitude} and ${locationProvider.pickedAddressLongitude}");

              if (!isEnableUpdate && locationProvider.mapController != null) {
                if(locationProvider.pickedAddressLatitude == null && locationProvider.pickedAddressLongitude == null){
                  print("Hello ");
                  AddressHelper.checkPermission(()=>locationProvider.getCurrentLocation(
                    context, true, mapController: locationProvider.mapController,
                  ));
                }else{
                  print("Hello From Else");
                  Future.delayed(const Duration(milliseconds: 800)).then((value) {
                    locationProvider.mapController = controller;
                    locationProvider.mapController!.moveCamera(CameraUpdate.newCameraPosition(CameraPosition(
                      target:  LatLng(
                        double.parse(locationProvider.pickedAddressLatitude ?? '0'),
                        double.parse(locationProvider.pickedAddressLongitude ?? '0'),
                      ), zoom: 17,
                    )));
                  });
                }
              }else{
                Future.delayed(const Duration(milliseconds: 800)).then((value) {
                  locationProvider.mapController = controller;
                  double latitude = double.tryParse(locationProvider.pickedAddressLatitude ?? '') ?? 0;
                  double longitude = double.tryParse(locationProvider.pickedAddressLongitude ?? '') ?? 0;
                  locationProvider.mapController!.moveCamera(CameraUpdate.newCameraPosition(CameraPosition(
                    target:  LatLng(latitude, longitude), zoom: 17,
                  )));
                });
              }

            },
          ),
          locationProvider.loading ? Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor),
              )) : const SizedBox(),

          Container(
              width: MediaQuery.of(context).size.width,
              alignment: Alignment.center,
              height: MediaQuery.of(context).size.height,
              child:Icon(
                Icons.location_on,
                color: Theme.of(context).primaryColor,
                size: 35,
              )
          ),

          Positioned(
            bottom: 10,
            right: 0,
            child: InkWell(
              onTap: () => AddressHelper.checkPermission(()=>locationProvider.getCurrentLocation(
                context, true, mapController: locationProvider.mapController,
              )),
              child: Container(
                width: ResponsiveHelper.isDesktop(context) ? 40 : 30,
                height: ResponsiveHelper.isDesktop(context) ? 40 : 30,
                margin: const EdgeInsets.only(right: Dimensions.paddingSizeLarge),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(Dimensions.paddingSizeSmall),
                  color: Colors.white,
                ),
                child: Icon(
                  Icons.my_location,
                  color: Theme.of(context).primaryColor,
                  size: 20,
                ),
              ),
            ),
          ),

          if(ResponsiveHelper.isDesktop(context)) Positioned.fill(
            child: Align(
              alignment: Alignment.topLeft,
              child: SizedBox(
                width: 500,
                child: SearchBarView(margin: Dimensions.paddingSizeSmall, onTap: (){
                  showDialog(context: context, builder: (context) => Container(
                    width: 400,
                    margin: const EdgeInsets.only(left:  600, top: 50),
                    child: SearchDialogWidget(mapController: locationProvider.mapController),
                  ), barrierDismissible: true);
                }),
              ),
            ),
          ),

          Positioned(
            top: 10,
            right: 0,
            child: InkWell(
              onTap: () {
                Navigator.pushNamed(
                  context, RouteHelper.getSelectLocationRoute(),
                  arguments: SelectLocationScreen(googleMapController: locationProvider.mapController),
                );
              },
              child: Container(
                width: ResponsiveHelper.isDesktop(context) ? 55 : 30,
                height: ResponsiveHelper.isDesktop(context) ? 55 : 30,
                margin: const EdgeInsets.only(right: Dimensions.paddingSizeLarge),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(Dimensions.paddingSizeSmall),
                  color: Theme.of(context).cardColor,
                ),
                child: Icon(
                  Icons.fullscreen,
                  color: Theme.of(context).primaryColor,
                  size: ResponsiveHelper.isDesktop(context) ? Dimensions.paddingSizeExtraLarge : Dimensions.paddingSizeLarge,
                ),
              ),
            ),
          ),

        ]),
      ),
    );
  }
}
