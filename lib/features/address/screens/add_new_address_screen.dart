
import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_grocery/common/enums/footer_type_enum.dart';
import 'package:flutter_grocery/common/widgets/custom_app_bar_widget.dart';
import 'package:flutter_grocery/common/widgets/footer_web_widget.dart';
import 'package:flutter_grocery/common/widgets/web_app_bar_widget.dart';
import 'package:flutter_grocery/features/address/domain/models/address_model.dart';
import 'package:flutter_grocery/features/address/providers/location_provider.dart';
import 'package:flutter_grocery/features/address/widgets/add_address_widget.dart';
import 'package:flutter_grocery/features/address/widgets/address_details_widget.dart';
import 'package:flutter_grocery/features/address/widgets/map_with_lable_widget.dart';
import 'package:flutter_grocery/features/auth/providers/auth_provider.dart';
import 'package:flutter_grocery/features/auth/widgets/country_code_picker_widget.dart';
import 'package:flutter_grocery/features/profile/providers/profile_provider.dart';
import 'package:flutter_grocery/features/splash/providers/splash_provider.dart';
import 'package:flutter_grocery/helper/responsive_helper.dart';
import 'package:flutter_grocery/localization/language_constraints.dart';
import 'package:flutter_grocery/utill/dimensions.dart';
import 'package:flutter_grocery/utill/styles.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

class AddNewAddressScreen extends StatefulWidget {
  final bool isEnableUpdate;
  final bool fromCheckout;
  final AddressModel? address;
  const AddNewAddressScreen({super.key, this.isEnableUpdate = true, this.address, this.fromCheckout = false});

  @override
  State<AddNewAddressScreen> createState() => _AddNewAddressScreenState();
}

class _AddNewAddressScreenState extends State<AddNewAddressScreen> {

  final TextEditingController _contactPersonNameController = TextEditingController();
  final TextEditingController _contactPersonNumberController = TextEditingController();
  final TextEditingController _streetNumberController = TextEditingController();
  final TextEditingController _houseNumberController = TextEditingController();
  final TextEditingController _florNumberController = TextEditingController();

  final FocusNode _addressNode = FocusNode();
  final FocusNode _nameNode = FocusNode();
  final FocusNode _numberNode = FocusNode();
  final FocusNode _stateNode = FocusNode();
  final FocusNode _houseNode = FocusNode();
  final FocusNode _floorNode = FocusNode();


  String? countryCode;



  @override
  void initState() {
    super.initState();

    _initLoading();

    if(widget.address != null && !widget.fromCheckout) {
      Provider.of<LocationProvider>(context, listen: false).setAddress = widget.address?.address;
    }



  }

  @override
  Widget build(BuildContext context) {


    return Scaffold(
      appBar: (ResponsiveHelper.isDesktop(context)
          ? const PreferredSize(preferredSize: Size.fromHeight(120), child: WebAppBarWidget())
          : CustomAppBarWidget(title: widget.isEnableUpdate
          ? getTranslated('update_address', context)
          : getTranslated('add_new_address', context),
      )) as PreferredSizeWidget?,

      body: Consumer<LocationProvider>(builder: (context, locationProvider, child) {
        return Column(children: [
          Expanded(child: CustomScrollView(slivers: [
            SliverToBoxAdapter(child: Padding(
              padding: const EdgeInsets.all(Dimensions.paddingSizeLarge),
              child: Center(child: SizedBox(width: Dimensions.webScreenWidth, child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  if(!ResponsiveHelper.isDesktop(context)) MapWithLabelWidget(
                    isEnableUpdate: widget.isEnableUpdate,
                    fromCheckout: widget.fromCheckout,
                    address: widget.address,
                  ),

                  // for label us
                  if(!ResponsiveHelper.isDesktop(context)) AddressDetailsWidget(
                    contactPersonNameController: _contactPersonNameController,
                    contactPersonNumberController: _contactPersonNumberController,
                    addressNode: _addressNode, nameNode: _nameNode,
                    numberNode: _numberNode, fromCheckout: widget.fromCheckout,
                    address: widget.address, isEnableUpdate: widget.isEnableUpdate,
                    streetNumberController: _streetNumberController,
                    houseNumberController: _houseNumberController,
                    houseNode: _houseNode,
                    stateNode: _stateNode,
                    florNumberController: _florNumberController,
                    florNode: _floorNode,
                    countryCode: countryCode!,
                    onValueChange: (code){
                      countryCode = code;
                    },
                  ),


                  if(ResponsiveHelper.isDesktop(context))...[
                    Center(child: Text(
                      getTranslated('delivery_address', context),
                      style: poppinsMedium.copyWith(
                        color: Theme.of(context).textTheme.bodyMedium?.color,
                        fontSize: Dimensions.fontSizeLarge,
                      )),
                    ),
                    const SizedBox(height: Dimensions.paddingSizeDefault),
                  ],


                  if(ResponsiveHelper.isDesktop(context)) IntrinsicHeight(
                    child: AddressDetailsWidget(
                      contactPersonNameController: _contactPersonNameController,
                      contactPersonNumberController: _contactPersonNumberController,
                      addressNode: _addressNode, nameNode: _nameNode,
                      numberNode: _numberNode, isEnableUpdate: widget.isEnableUpdate,
                      address: widget.address, fromCheckout: widget.fromCheckout,
                      streetNumberController: _streetNumberController,
                      houseNumberController: _houseNumberController,
                      houseNode: _houseNode,
                      stateNode: _stateNode,
                      florNumberController: _florNumberController,
                      florNode: _floorNode,
                      countryCode: countryCode!,
                      onValueChange: (code){
                        countryCode = code;
                      },
                    ),
                  ),

                ],
              ))),
            )),

            const FooterWebWidget(footerType: FooterType.sliver),

          ])),

          if(!ResponsiveHelper.isDesktop(context)) AddAddressWidget(
            isEnableUpdate: widget.isEnableUpdate,
            fromCheckout: widget.fromCheckout,
            contactPersonNumberController:
            _contactPersonNumberController,
            contactPersonNameController: _contactPersonNameController,
            address: widget.address,
            streetNumberController: _streetNumberController,
            houseNumberController: _houseNumberController,
            floorNumberController: _florNumberController,
            countryCode: countryCode!,
          ),
        ]);
      }),
    );
  }


  Future<void> _initLoading() async {
    countryCode = CountryCode.fromCountryCode(Provider.of<SplashProvider>(context, listen: false).configModel!.country!).code;

    final locationProvider = Provider.of<LocationProvider>(context, listen: false);
    final AuthProvider authProvider = Provider.of<AuthProvider>(context, listen: false);
    final SplashProvider splashProvider = Provider.of<SplashProvider>(context, listen: false);
    final userModel =  Provider.of<ProfileProvider>(context, listen: false).userInfoModel ;

    locationProvider.setPickedAddressLatLon(null, null, isUpdate: false);

    if(widget.address == null) {
      locationProvider.setAddAddressData(false);
    }

    await locationProvider.initializeAllAddressType(context: context);
    locationProvider.updateAddressStatusMessage(message: '');
    locationProvider.onChangeErrorMessage(message: '');


    if (widget.isEnableUpdate && widget.address != null) {
      String? code = CountryPick.getCountryCode('${widget.address!.contactPersonNumber}');
      if(code != null){
        countryCode =  CountryCode.fromDialCode(code).code;
      }

      locationProvider.isUpdateAddress = false;

      if(splashProvider.configModel?.googleMapStatus ?? false){

        if((widget.address?.longitude?.isNotEmpty ?? false)  && (widget.address?.latitude?.isNotEmpty ?? false)){
          locationProvider.setPickedAddressLatLon(widget.address?.latitude ?? '', widget.address?.longitude ?? '');
          locationProvider.updatePosition(
            CameraPosition(target: LatLng(
              double.parse(widget.address?.latitude ?? '0'),
              double.parse(widget.address?.longitude ?? '0'),
            )),
            true, widget.address!.address, forceNotify: false,
          );
        }
      }

      _contactPersonNameController.text = '${widget.address?.contactPersonName}';
      _contactPersonNumberController.text = '${widget.address?.contactPersonNumber}';
      _streetNumberController.text = widget.address?.streetNumber ?? '';
      _houseNumberController.text = widget.address?.houseNumber ?? '';
      _florNumberController.text = widget.address?.floorNumber ?? '';

      if (widget.address?.addressType == 'Home') {
        locationProvider.updateAddressIndex(0, false);

      } else if (widget.address!.addressType == 'Workplace') {
        locationProvider.updateAddressIndex(1, false);

      } else {
        locationProvider.updateAddressIndex(2, false);
      }

    }else {
      if(authProvider.isLoggedIn()){
        String? code = CountryPick.getCountryCode(userModel?.phone);

        if(code != null){
          countryCode = CountryCode.fromDialCode(code).code;
        }
        _contactPersonNameController.text = '${userModel?.fName ?? ''}' ' ${userModel?.lName ?? ''}';
        _contactPersonNumberController.text = (code != null ? (userModel?.phone ?? '').replaceAll(code, '') : userModel?.phone ?? '');
      }
    }

    print("----------------(ADD NEW ADDRESS SCREEN)-------------${locationProvider.pickedAddressLatitude} and ${locationProvider.pickedAddressLongitude}");


  }


}





