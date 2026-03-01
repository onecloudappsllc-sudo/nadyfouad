import 'package:flutter/material.dart';
import 'package:flutter_grocery/features/order/domain/models/order_model.dart';
import 'package:flutter_grocery/localization/language_constraints.dart';
import 'package:flutter_grocery/utill/color_resources.dart';
import 'package:flutter_grocery/utill/dimensions.dart';
import 'package:flutter_grocery/utill/images.dart';
import 'package:flutter_grocery/utill/styles.dart';
import 'package:flutter_grocery/common/widgets/custom_app_bar_widget.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class OrderMapInfoWidget extends StatefulWidget {
  final DeliveryAddress? address;
  const OrderMapInfoWidget({Key? key, required this.address}) : super(key: key);

  @override
  State<OrderMapInfoWidget> createState() => _OrderMapInfoWidgetState();
}

class _OrderMapInfoWidgetState extends State<OrderMapInfoWidget> {
  late LatLng _latLng;
  Set<Marker> _markers = {};


  @override
  void initState() {
    super.initState();

    _latLng = LatLng(double.parse(widget.address!.latitude!), double.parse(widget.address!.longitude!));


    _setMarker();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:  CustomAppBarWidget(title: getTranslated('delivery_address', context)),
      body: Stack(children: [
        GoogleMap(
          minMaxZoomPreference: const MinMaxZoomPreference(0, 16),
          initialCameraPosition: CameraPosition(target: _latLng, zoom: 16),
          zoomGesturesEnabled: true,
          myLocationButtonEnabled: false,
          zoomControlsEnabled: false,
          indoorViewEnabled: true,
          markers:_markers,
        ),

        Positioned(
          left: Dimensions.paddingSizeLarge, right: Dimensions.paddingSizeLarge, bottom: Dimensions.paddingSizeLarge,
          child: Container(
            padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              color: Theme.of(context).cardColor,
              boxShadow: [BoxShadow(color: Theme.of(context).shadowColor, spreadRadius: 3, blurRadius: 10)],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                Row(children: [

                  Icon(
                    widget.address!.addressType == 'Home' ? Icons.home_outlined : widget.address!.addressType == 'Workplace'
                        ? Icons.work_outline : Icons.list_alt_outlined,
                    size: 30, color: Theme.of(context).primaryColor,
                  ),
                  const SizedBox(width: 10),

                  Expanded(
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.center, children: [

                      Text(widget.address!.addressType!, style: poppinsRegular.copyWith(
                        fontSize: Dimensions.fontSizeSmall, color: ColorResources.getGreyColor(context),
                      )),

                      Text(widget.address!.address!, style: poppinsRegular),

                    ]),
                  ),
                ]),

                Text('- ${widget.address!.contactPersonName}', style: poppinsRegular.copyWith(
                  color: Theme.of(context).primaryColor,
                  fontSize: Dimensions.fontSizeLarge,
                )),

                Text('- ${widget.address!.contactPersonNumber}', style: poppinsRegular),

              ],
            ),
          ),
        ),
      ]),
    );
  }

  void _setMarker() async {
     await BitmapDescriptor.fromAssetImage(const ImageConfiguration(size: Size(30, 50)), Images.restaurantMarker).then((marker) {
      _markers = {};
      _markers.add(Marker(
        markerId: const MarkerId('marker'),
        position: _latLng,
        icon: marker,
      ));

      setState(() {});
    });
  }


}
