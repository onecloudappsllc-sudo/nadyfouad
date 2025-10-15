import 'package:flutter/material.dart';
import 'package:flutter_grocery/helper/responsive_helper.dart';
import 'package:flutter_grocery/localization/language_constraints.dart';
import 'package:flutter_grocery/features/wallet_and_loyalty/providers/wallet_provider.dart';
import 'package:flutter_grocery/utill/dimensions.dart';
import 'package:flutter_grocery/utill/styles.dart';
import 'package:provider/provider.dart';

class WalletUsesManualWidget extends StatelessWidget {
  const WalletUsesManualWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<String> walletNoteList = Provider.of<WalletAndLoyaltyProvider>(context, listen: false).walletNoteList;

    return Padding(
      padding: ResponsiveHelper.isMobile() ? const EdgeInsets.fromLTRB(20,70,20,0) : EdgeInsets.zero,
      child: Column(mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                if(ResponsiveHelper.isMobile())
                  InkWell(
                    child: const Row(mainAxisAlignment: MainAxisAlignment.end, children: [Icon(Icons.highlight_remove,size: 20)]),
                    onTap: ()=> Navigator.pop(context),
                  ),

                Padding(
                  padding: const EdgeInsets.fromLTRB(0,Dimensions.paddingSizeSmall,0,Dimensions.paddingSizeSmall),
                  child: Text(getTranslated('how_to_use', context), style: poppinsBold.copyWith(
                    fontSize: Dimensions.fontSizeLarge, color: Theme.of(context).primaryColor,
                  )),
                ),

                Column(children: walletNoteList.map((item) => Column(children: [
                  Row(crossAxisAlignment: CrossAxisAlignment.start,children: [
                    const Padding(
                      padding: EdgeInsets.only(
                        left: Dimensions.paddingSizeSmall, right: Dimensions.paddingSizeSmall,top: 5,
                      ),
                      child: Icon(Icons.circle,size: 7,),
                    ),

                    Expanded(child: Text(getTranslated(item, context), style: poppinsRegular.copyWith(
                      color: Theme.of(context).textTheme.bodySmall!.color,
                    ))),

                  ]),

                  const SizedBox(height: Dimensions.paddingSizeSmall),

                ])).toList()),

              ]),
          ),
        ],
      ),
    );
  }
}


