import 'package:flutter/material.dart';
import 'package:flutter_grocery/localization/language_constraints.dart';
import 'package:flutter_grocery/features/wallet_and_loyalty/providers/wallet_provider.dart';
import 'package:flutter_grocery/utill/dimensions.dart';
import 'package:flutter_grocery/common/widgets/custom_loader_widget.dart';
import 'package:flutter_grocery/common/widgets/no_data_widget.dart';
import 'package:flutter_grocery/features/wallet_and_loyalty/widgets/history_widget.dart';
import 'package:flutter_grocery/features/wallet_and_loyalty/widgets/wallet_shimmer_widget.dart';
import 'package:provider/provider.dart';


class WalletHistoryListWidget extends StatelessWidget {
  const WalletHistoryListWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault),
      child: Consumer<WalletAndLoyaltyProvider>(builder: (context, walletProvider, _) => Center(child: SizedBox(
        width: Dimensions.webScreenWidth,
        child: Column(children: [
          Column(children: [

            walletProvider.transactionList != null ? walletProvider.transactionList!.isNotEmpty ? ListView.builder(
              key: UniqueKey(),
              physics:  const NeverScrollableScrollPhysics(),
              shrinkWrap:  true,
              itemCount: walletProvider.transactionList!.length ,
              itemBuilder: (context, index) => WalletHistory(transaction: walletProvider.transactionList![index]),
            ) : NoDataWidget(isFooter: false, title: getTranslated('no_result_found', context),) : WalletShimmerWidget(isEnable: walletProvider.transactionList == null),

            walletProvider.paginationLoader ? Center(child: Padding(
              padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
              child: CustomLoaderWidget(color: Theme.of(context).primaryColor),
            )) : const SizedBox(),
          ])
        ]),
      ))),
    );
  }
}

