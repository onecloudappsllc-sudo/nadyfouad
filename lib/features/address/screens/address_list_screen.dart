import 'package:flutter/material.dart';
import 'package:flutter_grocery/common/enums/footer_type_enum.dart';
import 'package:flutter_grocery/features/address/domain/models/address_model.dart';
import 'package:flutter_grocery/helper/responsive_helper.dart';
import 'package:flutter_grocery/helper/route_helper.dart';
import 'package:flutter_grocery/localization/language_constraints.dart';
import 'package:flutter_grocery/features/auth/providers/auth_provider.dart';
import 'package:flutter_grocery/features/address/providers/location_provider.dart';
import 'package:flutter_grocery/utill/dimensions.dart';
import 'package:flutter_grocery/utill/styles.dart';
import 'package:flutter_grocery/common/widgets/app_bar_base_widget.dart';
import 'package:flutter_grocery/common/widgets/custom_loader_widget.dart';
import 'package:flutter_grocery/common/widgets/footer_web_widget.dart';
import 'package:flutter_grocery/common/widgets/no_data_widget.dart';
import 'package:flutter_grocery/common/widgets/not_login_widget.dart';
import 'package:flutter_grocery/features/address/widgets/adress_widget.dart';
import 'package:flutter_grocery/common/widgets/web_app_bar_widget.dart';
import 'package:provider/provider.dart';
import 'add_new_address_screen.dart';


class AddressListScreen extends StatefulWidget {

  final AddressModel? addressModel;
  const AddressListScreen({Key? key, this.addressModel}) : super(key: key);

  @override
  State<AddressListScreen> createState() => _AddressListScreenState();
}

class _AddressListScreenState extends State<AddressListScreen> {
  late bool _isLoggedIn;

  @override
  void initState() {
    super.initState();

    _isLoggedIn = Provider.of<AuthProvider>(context, listen: false).isLoggedIn();
    if(_isLoggedIn) {
      Provider.of<LocationProvider>(context, listen: false).initAddressList();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ResponsiveHelper.isMobilePhone() ? null : (ResponsiveHelper.isDesktop(context)
          ? const PreferredSize(preferredSize: Size.fromHeight(120), child: WebAppBarWidget())
          : const AppBarBaseWidget()) as PreferredSizeWidget?,

      body: _isLoggedIn ? Consumer<LocationProvider>(
        builder: (context, locationProvider, child) {
          return RefreshIndicator(
            onRefresh: () async {
              await locationProvider.initAddressList();
            },
            backgroundColor: Theme.of(context).primaryColor,
            child: CustomScrollView(slivers: [
              SliverToBoxAdapter(child: Center(child: SizedBox(
                width: Dimensions.webScreenWidth,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    Center(child: Container(
                      width: Dimensions.webScreenWidth,
                      padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                      margin: EdgeInsets.only(top: ResponsiveHelper.isDesktop(context) ? 20 : 0),
                      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [

                        Text(
                          getTranslated('saved_address', context),
                          style: poppinsRegular.copyWith(color: Theme.of(context).textTheme.bodyLarge?.color?.withOpacity(0.6)),
                        ),

                        InkWell(
                          onTap:() {locationProvider.updateAddressStatusMessage(message: '');
                          Navigator.of(context).pushNamed(RouteHelper.getAddAddressRoute('address', 'add', AddressModel()), arguments: const AddNewAddressScreen());
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 5),
                            decoration: BoxDecoration(
                              color: ResponsiveHelper.isDesktop(context)? Theme.of(context).primaryColor : Colors.transparent,
                              borderRadius: BorderRadius.circular(5),

                            ),
                            child: Row(children: [
                              Icon(Icons.add, color: ResponsiveHelper.isDesktop(context) ? Colors.white : Theme.of(context).textTheme.bodyLarge?.color?.withOpacity(0.6)),

                              Text(
                                  getTranslated('add_new', context), style: poppinsRegular.copyWith(
                                color: ResponsiveHelper.isDesktop(context)
                                    ? Colors.white
                                    : Theme.of(context).textTheme.bodyLarge?.color?.withOpacity(0.6),
                              )),
                            ]),
                          ),
                        ),
                      ],
                      ),
                    )),


                    locationProvider.addressList == null ? CustomLoaderWidget(color: Theme.of(context).primaryColor) : (locationProvider.addressList?.isNotEmpty ?? false) ? Column(
                      children: [
                        Center(
                          child: ResponsiveHelper.isDesktop(context) ?  GridView.builder(
                            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisSpacing: 13,
                              mainAxisSpacing: 13,
                              childAspectRatio: 4.5,
                              crossAxisCount:  2,
                            ),
                            itemCount: locationProvider.addressList?.length,
                            padding: const EdgeInsets.symmetric(
                              horizontal: Dimensions.paddingSizeDefault,
                              vertical: Dimensions.paddingSizeDefault,
                            ),
                            physics: const NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemBuilder: (BuildContext context, int index) {
                              return AddressWidget(
                                addressModel: locationProvider.addressList![index],
                                index: index,
                              );
                            },
                          ) : ListView.builder(
                            padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                            itemCount: locationProvider.addressList?.length,
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemBuilder: (context, index) => AddressWidget(
                              addressModel: locationProvider.addressList![index],
                              index: index,
                            ),
                          ),
                        ),

                        (locationProvider.addressList?.length ?? 0) <= 4 ?  const SizedBox(height: 300) : const SizedBox(),

                      ],
                    ) :  NoDataWidget(title: getTranslated('no_address_found', context)),
                  ],
                ),
              ))),

              const FooterWebWidget(footerType: FooterType.sliver),
            ]),
          );
        },
      ) : const NotLoggedInWidget(),
    );
  }
}