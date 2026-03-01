import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_grocery/common/enums/footer_type_enum.dart';
import 'package:flutter_grocery/helper/responsive_helper.dart';
import 'package:flutter_grocery/helper/route_helper.dart';
import 'package:flutter_grocery/localization/language_constraints.dart';
import 'package:flutter_grocery/features/order/providers/order_provider.dart';
import 'package:flutter_grocery/features/splash/providers/splash_provider.dart';
import 'package:flutter_grocery/utill/dimensions.dart';
import 'package:flutter_grocery/utill/images.dart';
import 'package:flutter_grocery/utill/styles.dart';
import 'package:flutter_grocery/common/widgets/custom_app_bar_widget.dart';
import 'package:flutter_grocery/common/widgets/custom_button_widget.dart';
import 'package:flutter_grocery/common/widgets/custom_loader_widget.dart';
import 'package:flutter_grocery/helper/custom_snackbar_helper.dart';
import 'package:flutter_grocery/common/widgets/custom_text_field_widget.dart';
import 'package:flutter_grocery/common/widgets/footer_web_widget.dart';
import 'package:flutter_grocery/common/widgets/phone_number_field_widget.dart';
import 'package:flutter_grocery/common/widgets/web_app_bar_widget.dart';
import 'package:flutter_grocery/features/order/widgets/track_order_web_widget.dart';
import 'package:provider/provider.dart';

class OrderSearchScreen extends StatefulWidget {
  const OrderSearchScreen({Key? key}) : super(key: key);

  @override
  State<OrderSearchScreen> createState() => _OrderSearchScreenState();
}

class _OrderSearchScreenState extends State<OrderSearchScreen> {
  final TextEditingController orderIdTextController = TextEditingController();
  final TextEditingController phoneNumberTextController = TextEditingController();
  final FocusNode orderIdFocusNode = FocusNode();
  final FocusNode phoneFocusNode = FocusNode();
  String? countryCode;

  @override
  void initState() {
    countryCode = CountryCode.fromCountryCode(Provider.of<SplashProvider>(context, listen: false).configModel!.country!).code;

    Provider.of<OrderProvider>(context, listen: false).clearPrevData();
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ResponsiveHelper.isDesktop(context) ? const PreferredSize(
        preferredSize: Size.fromHeight(100), child: WebAppBarWidget(),
      ) : CustomAppBarWidget(
        isBackButtonExist: !ResponsiveHelper.isMobile(),
        title: getTranslated('order_details', context),
        actionView: _TrackRefreshButtonView(
          orderIdTextController: orderIdTextController,
          phoneNumberTextController: phoneNumberTextController,
        ),
      ) as PreferredSizeWidget,

      body: CustomScrollView(slivers: [

        SliverToBoxAdapter(child: Container(
          margin: ResponsiveHelper.isDesktop(context) ? EdgeInsets.symmetric(horizontal: (MediaQuery.sizeOf(context).width - Dimensions.webScreenWidth) / 2).copyWith(top: Dimensions.paddingSizeDefault) : null,
          decoration: ResponsiveHelper.isDesktop(context) ? BoxDecoration(
            color: Theme.of(context).canvasColor, borderRadius: BorderRadius.circular(Dimensions.radiusSizeDefault),
            boxShadow: [BoxShadow(color: Theme.of(context).shadowColor, blurRadius: 5, spreadRadius: 1)],
          ) : null,
          child: Column(children: [
            if(ResponsiveHelper.isDesktop(context)) Center(child: Container(
              padding: const EdgeInsets.only(top: Dimensions.paddingSizeLarge),
              width: Dimensions.webScreenWidth,
              child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, crossAxisAlignment: CrossAxisAlignment.center, children: [
                const SizedBox(),
                Text(getTranslated('track_your_order', context), style: poppinsBold.copyWith(fontSize: Dimensions.fontSizeOverLarge)),

                _TrackRefreshButtonView(
                  orderIdTextController: orderIdTextController,
                  phoneNumberTextController: phoneNumberTextController,
                ),


              ]),
            )),

            Container(
              padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault),
              child: Column(children: [

                Padding(
                  padding: ResponsiveHelper.isDesktop(context) ? const EdgeInsets.symmetric(
                    horizontal: Dimensions.paddingSizeLarge, vertical: Dimensions.paddingSizeSmall,
                  ) : const EdgeInsets.only(top: Dimensions.paddingSizeSmall),
                  child: _InputView(
                    key: UniqueKey(),
                    orderIdTextController: orderIdTextController, orderIdFocusNode: orderIdFocusNode,
                    phoneFocusNode: phoneFocusNode, phoneNumberTextController: phoneNumberTextController,
                    onValueChange: (String code) {
                      setState(() {
                        countryCode = code;
                      });
                    },
                    countryCode: countryCode,

                  ),
                ),

               Consumer<OrderProvider>(builder: (context, orderProvider, _) {
                    return orderProvider.trackModel == null || orderProvider.trackModel?.id == null  ? Column(children: [
                      const SizedBox(height: Dimensions.paddingSizeLarge),
                      Image.asset(Images.outForDelivery, color: Theme.of(context).disabledColor.withOpacity(0.5), width:  70),
                      const SizedBox(height: Dimensions.paddingSizeDefault),

                      Text(getTranslated('enter_your_order_id', context), style: poppinsRegular.copyWith(
                        color: Theme.of(context).disabledColor,
                      ), maxLines: 2,  textAlign: TextAlign.center),
                      const SizedBox(height: 100),
                    ]) : ResponsiveHelper.isDesktop(context) ? TrackOrderWebWidget(
                      phoneNumber: '${CountryCode.fromCountryCode(countryCode!).dialCode}${phoneNumberTextController.text.trim()}',
                    ) : const SizedBox();
                }),


              ]),
            ),

          ]),
        )),

        const FooterWebWidget(footerType: FooterType.sliver),
      ]),
    );
  }
}


class _TrackRefreshButtonView extends StatelessWidget {
  const _TrackRefreshButtonView({
    Key? key,
    required this.orderIdTextController,
    required this.phoneNumberTextController,
  }) : super(key: key);

  final TextEditingController orderIdTextController;
  final TextEditingController phoneNumberTextController;

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton.extended(
      elevation: 0,
      backgroundColor: ResponsiveHelper.isDesktop(context) ? Theme.of(context).canvasColor : Theme.of(context).cardColor,
      onPressed: () {
        orderIdTextController.clear();
        phoneNumberTextController.clear();
        Provider.of<OrderProvider>(context, listen: false).clearPrevData(isUpdate: true);
      },
      label: Text(getTranslated('refresh', context), style: poppinsMedium.copyWith(color: Theme.of(context).textTheme.bodyLarge?.color)),
      icon: Icon(Icons.refresh, color: Theme.of(context).primaryColor),
    );
  }
}


class _InputView extends StatelessWidget {
  const _InputView({
    Key? key,
    required this.orderIdTextController,
    required this.orderIdFocusNode,
    required this.phoneFocusNode,
    required this.phoneNumberTextController,
    required this.countryCode,
    required this.onValueChange,
  }) : super(key: key);

  final TextEditingController orderIdTextController;
  final FocusNode orderIdFocusNode;
  final FocusNode phoneFocusNode;
  final TextEditingController phoneNumberTextController;
  final String? countryCode;
  final Function(String value) onValueChange;

  @override
  Widget build(BuildContext context) {

    return !ResponsiveHelper.isDesktop(context) ? Column(children: [
      FormField(builder: (builder)=> Column(children: [
        _OrderIdTextField(
          orderIdTextController: orderIdTextController,
          orderIdFocusNode: orderIdFocusNode,
          phoneFocusNode: phoneFocusNode,
        ),
        const SizedBox(height: Dimensions.paddingSizeLarge),

        PhoneNumberFieldWidget(
          onValueChange: onValueChange,
          countryCode: countryCode,
          phoneNumberTextController: phoneNumberTextController,
          phoneFocusNode: phoneFocusNode,
        ),
        const SizedBox(height: Dimensions.paddingSizeLarge),

      ])),
      const SizedBox(height: Dimensions.paddingSizeDefault),

      TrackOrderButtonView(
        key: UniqueKey(),
        orderIdTextController: orderIdTextController,
        countryCode: countryCode,
        phoneNumberTextController: phoneNumberTextController,
      ),
    ]) : Center(child: SizedBox(
      width: Dimensions.webScreenWidth,
      child: FormField(builder: (builder)=> Row(children: [
        Expanded(child: _OrderIdTextField(
          orderIdTextController: orderIdTextController,
          orderIdFocusNode: orderIdFocusNode,
          phoneFocusNode: phoneFocusNode,
        )),
        const SizedBox(width: Dimensions.paddingSizeLarge),

        Expanded(child: PhoneNumberFieldWidget(
          onValueChange: onValueChange, countryCode: countryCode,
          phoneNumberTextController: phoneNumberTextController,
          phoneFocusNode: phoneFocusNode,
        )),
        const SizedBox(width: Dimensions.paddingSizeLarge),


        SizedBox(
          width: 200,
          child: TrackOrderButtonView(
            key: UniqueKey(),
            orderIdTextController: orderIdTextController,
            countryCode: countryCode,
            phoneNumberTextController: phoneNumberTextController,
          ),
        ),
      ])),
    ));
  }
}

class TrackOrderButtonView extends StatelessWidget {
  const TrackOrderButtonView({
    Key? key,
    required this.orderIdTextController,
    required this.countryCode,
    required this.phoneNumberTextController,
  }) : super(key: key);

  final TextEditingController orderIdTextController;
  final String? countryCode;
  final TextEditingController phoneNumberTextController;

  @override
  Widget build(BuildContext context) {
    return Consumer<OrderProvider>(
      builder: (context, orderProvider, _) {
        return orderProvider.isLoading ? CustomLoaderWidget(color: Theme.of(context).primaryColor) : CustomButtonWidget(
          borderRadius: ResponsiveHelper.isDesktop(context) ? Dimensions.radiusSizeDefault : Dimensions.radiusSizeLarge,
          buttonText: getTranslated('search_order', context),
          onPressed: (){
            final String orderId = orderIdTextController.text.trim();
            final dialCode = CountryCode.fromCountryCode(countryCode!).dialCode;

            final String phoneNumber = '$dialCode${phoneNumberTextController.text.trim()}';

            if(orderId.isEmpty){
              showCustomSnackBarHelper(getTranslated('enter_order_id', context));
            }else if(phoneNumberTextController.text.trim().isEmpty){
              showCustomSnackBarHelper(getTranslated('enter_phone_number', context));
            }else{
              if(ResponsiveHelper.isDesktop(context)){
                orderProvider.trackOrder(orderId, null, context, true, phoneNumber: phoneNumber);
              }else{
                Navigator.of(context).pushNamed(
                  RouteHelper.getOrderTrackingRoute(int.parse(orderId),  phoneNumber),
                );
              }
            }

          },
        );
      }
    );
  }
}



class _OrderIdTextField extends StatelessWidget {
  const _OrderIdTextField({
    Key? key,
    required this.orderIdTextController,
    required this.orderIdFocusNode,
    required this.phoneFocusNode,
  }) : super(key: key);

  final TextEditingController orderIdTextController;
  final FocusNode orderIdFocusNode;
  final FocusNode phoneFocusNode;

  @override
  Widget build(BuildContext context) {
    return CustomTextFieldWidget(
      controller: orderIdTextController,
      focusNode: orderIdFocusNode,
      nextFocus: phoneFocusNode,
      isShowBorder: true,
      hintText: getTranslated('order_id', context),
      prefixAssetUrl: Images.order,
      isShowPrefixIcon: true,
      suffixAssetUrl: Images.order,
      inputType: const TextInputType.numberWithOptions(decimal: false),

    );
  }
}