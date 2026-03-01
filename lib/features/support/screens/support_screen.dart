import 'package:flutter/material.dart';
import 'package:flutter_grocery/common/enums/footer_type_enum.dart';
import 'package:flutter_grocery/helper/responsive_helper.dart';
import 'package:flutter_grocery/helper/route_helper.dart';
import 'package:flutter_grocery/localization/language_constraints.dart';
import 'package:flutter_grocery/features/splash/providers/splash_provider.dart';
import 'package:flutter_grocery/utill/dimensions.dart';
import 'package:flutter_grocery/utill/images.dart';
import 'package:flutter_grocery/utill/styles.dart';
import 'package:flutter_grocery/common/widgets/custom_button_widget.dart';
import 'package:flutter_grocery/common/widgets/footer_web_widget.dart';
import 'package:flutter_grocery/common/widgets/web_app_bar_widget.dart';
import 'package:flutter_grocery/features/product/widgets/details_app_bar_widget.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher_string.dart';

class SupportScreen extends StatelessWidget {
  const SupportScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: ResponsiveHelper.isDesktop(context)
          ? const PreferredSize(preferredSize: Size.fromHeight(120), child: WebAppBarWidget()) : const DetailsAppBarWidget(),

      body: CustomScrollView(slivers: [
        SliverToBoxAdapter(child: Center(child: Padding(
            padding: const EdgeInsets.all(Dimensions.paddingSizeLarge),
            child: Container(
              width: width > 700 ? 700 : width,
              padding: width > 700 ? const EdgeInsets.all(Dimensions.paddingSizeDefault) : null,
              decoration: width > 700 ? BoxDecoration(
                color: Theme.of(context).cardColor, borderRadius: BorderRadius.circular(10),
                boxShadow: [BoxShadow(color: Theme.of(context).shadowColor, blurRadius: 5, spreadRadius: 1)],
              ) : null,
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

                Align(
                  alignment: Alignment.center,
                  child: Image.asset(Images.support,height: 300,width: 300),
                ),
                const SizedBox(height: 20),

                Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  Icon(Icons.location_on, color: Theme.of(context).primaryColor, size: 25),
                  Text(getTranslated('store_address', context), style: poppinsMedium),
                ]),
                const SizedBox(height: 10),

                Text(
                  Provider.of<SplashProvider>(context, listen: false).configModel!.ecommerceAddress ?? 'no address',
                  style: poppinsRegular, textAlign: TextAlign.center,
                ),
                const Divider(thickness: 2),
                const SizedBox(height: 50),

                Padding(
                  padding: ResponsiveHelper.isDesktop(context)
                      ?  const EdgeInsets.all(Dimensions.paddingSizeLarge)
                      : const EdgeInsets.all(Dimensions.paddingSizeExtraSmall),
                  child: Row(children: [
                    Expanded(child: TextButton(
                      style: TextButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                          side: BorderSide(width: 2, color: Theme.of(context).primaryColor),
                        ),
                        minimumSize: const Size(1, 50),
                      ),
                      onPressed: () {
                        launchUrlString('tel:${Provider.of<SplashProvider>(context, listen: false).configModel!.ecommercePhone}');
                      },
                      child: Text(getTranslated('call_now', context), style: Theme.of(context).textTheme.displaySmall!.copyWith(
                        color: Theme.of(context).primaryColor,
                        fontSize: Dimensions.fontSizeLarge,
                      )),
                    )),
                    const SizedBox(width: 10),

                    Expanded(child: SizedBox(height: 50, child: CustomButtonWidget(
                      buttonText: getTranslated('send_a_message', context),
                      onPressed: () async {
                        Navigator.pushNamed(context, RouteHelper.getChatRoute(orderModel: null));
                      },
                    ))),
                  ]),
                ),

              ]),
            )))),

        const FooterWebWidget(footerType: FooterType.sliver),
      ]),
    );
  }
}
