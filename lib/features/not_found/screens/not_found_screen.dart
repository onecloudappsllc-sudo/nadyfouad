import 'package:flutter/material.dart';
import 'package:flutter_grocery/common/enums/footer_type_enum.dart';
import 'package:flutter_grocery/helper/responsive_helper.dart';
import 'package:flutter_grocery/localization/language_constraints.dart';
import 'package:flutter_grocery/utill/styles.dart';
import 'package:flutter_grocery/common/widgets/footer_web_widget.dart';
import 'package:flutter_grocery/common/widgets/web_app_bar_widget.dart';

class NotFoundScreen extends StatelessWidget {
  const NotFoundScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: ResponsiveHelper.isDesktop(context)
          ? const PreferredSize(preferredSize: Size.fromHeight(100), child: WebAppBarWidget())
          : null,
      body: SingleChildScrollView(child: Column(children: [

        ConstrainedBox(
          constraints: BoxConstraints(
            minHeight: !ResponsiveHelper.isDesktop(context)
                && height < 600 ? height : height - 400,
          ),
          child: Center(child: TweenAnimationBuilder(
            curve: Curves.bounceOut,
            duration: const Duration(seconds: 2),
            tween: Tween<double>(begin: 12.0,end: 30.0),
            builder: (BuildContext context, dynamic value, Widget? child){
              return Text(
                getTranslated('page_not_found', context),
                style: poppinsBold,
              );
            },

          )),
        ),

        const FooterWebWidget(footerType: FooterType.nonSliver),
      ])),
    );
  }
}
