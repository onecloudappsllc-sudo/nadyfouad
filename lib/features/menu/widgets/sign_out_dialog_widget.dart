import 'package:flutter/material.dart';
import 'package:flutter_grocery/helper/responsive_helper.dart';
import 'package:flutter_grocery/helper/route_helper.dart';
import 'package:flutter_grocery/localization/language_constraints.dart';
import 'package:flutter_grocery/features/auth/providers/auth_provider.dart';
import 'package:flutter_grocery/utill/dimensions.dart';
import 'package:flutter_grocery/utill/styles.dart';
import 'package:flutter_grocery/common/widgets/custom_loader_widget.dart';
import 'package:flutter_grocery/helper/custom_snackbar_helper.dart';
import 'package:provider/provider.dart';

class SignOutDialogWidget extends StatelessWidget {
  const SignOutDialogWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {


    return Consumer<AuthProvider>(
      builder: (context, auth, child) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child:  SizedBox(
          width: 300,
          child: Column(mainAxisSize: MainAxisSize.min, children: [

            const SizedBox(height: 20),
            ClipRRect(
              borderRadius: BorderRadius.circular(30),
              child: Icon(Icons.contact_support, size: 50, color: Theme.of(context).primaryColor),
            ),

            Padding(
              padding: const EdgeInsets.all(Dimensions.paddingSizeLarge),
              child: Text(getTranslated('want_to_sign_out', context), style: poppinsBold, textAlign: TextAlign.center),
            ),

            Divider(height: 0, color: Theme.of(context).hintColor.withOpacity(0.6)),
            !auth.isLoading ? Row(children: [

             Expanded(child: InkWell(
               onTap: () async {
                 auth.signOut().then((value) {
                  if(context.mounted ) {
                    showCustomSnackBarHelper(getTranslated('logout_successful', context), isError: false);


                    if(ResponsiveHelper.isWeb()) {
                      Navigator.pushNamedAndRemoveUntil(context, RouteHelper.getMainRoute(), (route) => false);
                    }else {
                      Navigator.pushNamedAndRemoveUntil(context, RouteHelper.getLoginRoute(), (route) => false);
                    }
                  }
                });
               },
                child: Container(
                  padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                  alignment: Alignment.center,
                  decoration: const BoxDecoration(borderRadius: BorderRadius.only(bottomLeft: Radius.circular(10))),
                  child: Text(getTranslated('yes', context), style: poppinsBold.copyWith(color: Theme.of(context).primaryColor)),
                ),
              )),

             Expanded(child: InkWell(
                onTap: () => Navigator.pop(context),
                child: Container(
                  padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(color: Theme.of(context).primaryColor, borderRadius: const BorderRadius.only(bottomRight: Radius.circular(10))),
                  child: Text(getTranslated('no', context), style: poppinsBold.copyWith(color: Colors.white)),
                ),
              )),

            ]) : Center(child: CustomLoaderWidget(color: Theme.of(context).primaryColor)),
          ]),
        )
      ),
    );
  }
}
