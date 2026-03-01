import 'package:flutter/material.dart';
import 'package:flutter_grocery/common/enums/footer_type_enum.dart';
import 'package:flutter_grocery/helper/responsive_helper.dart';
import 'package:flutter_grocery/helper/route_helper.dart';
import 'package:flutter_grocery/localization/app_localization.dart';
import 'package:flutter_grocery/utill/images.dart';
import 'package:flutter_grocery/utill/styles.dart';
import 'package:flutter_grocery/common/widgets/custom_button_widget.dart';

import 'footer_web_widget.dart';


class NotLoggedInWidget extends StatelessWidget {
  const NotLoggedInWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(slivers: [
        SliverToBoxAdapter(child: Center(
          child: Container(
            padding: EdgeInsets.symmetric(vertical: ResponsiveHelper.isDesktop(context) ? 50 : 0),
            height: ResponsiveHelper.isDesktop(context) ? null : MediaQuery.of(context).size.height * 0.8,
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Image.asset(
                    Images.orderPlaced,
                    width: MediaQuery.of(context).size.height*0.25,
                    height: MediaQuery.of(context).size.height*0.25,
                    color: Theme.of(context).primaryColor,
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height*0.03),

                  Text(
                    'guest_mode'.tr,
                    style: poppinsRegular.copyWith(fontSize: MediaQuery.of(context).size.height*0.023),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height*0.02),

                  Text(
                    'now_you_are_in_guest_mode'.tr,
                    style: poppinsRegular.copyWith(fontSize: MediaQuery.of(context).size.height*0.0175),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height*0.03),

                  SizedBox(
                    width: 100,
                    height: 45,
                    child: CustomButtonWidget(buttonText: 'login'.tr, onPressed: () {
                      // Navigator.push(context, MaterialPageRoute(builder: (_) => LoginScreen()));
                      Navigator.pushNamed(context, RouteHelper.login);
                    }),
                  ),
                ],),
            ),
          ),
        )),

      const FooterWebWidget(footerType: FooterType.sliver),

    ]);
  }
}
