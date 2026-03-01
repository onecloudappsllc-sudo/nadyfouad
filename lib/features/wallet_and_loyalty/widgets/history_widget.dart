import 'package:flutter/material.dart';
import 'package:flutter_grocery/features/wallet_and_loyalty/domain/models/wallet_model.dart';
import 'package:flutter_grocery/helper/date_converter_helper.dart';
import 'package:flutter_grocery/helper/price_converter_helper.dart';
import 'package:flutter_grocery/helper/responsive_helper.dart';
import 'package:flutter_grocery/localization/language_constraints.dart';
import 'package:flutter_grocery/features/splash/providers/splash_provider.dart';
import 'package:flutter_grocery/utill/dimensions.dart';
import 'package:flutter_grocery/utill/images.dart';
import 'package:flutter_grocery/utill/styles.dart';
import 'package:flutter_grocery/common/widgets/custom_directionality_widget.dart';
import 'package:provider/provider.dart';

class HistoryWidget extends StatelessWidget {
  final int index;
  final bool formEarning;
  final List<Transaction>? data;
  const HistoryWidget({Key? key, required this.index, required this.formEarning, required this.data}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: Dimensions.paddingSizeExtraSmall),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor, borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Theme.of(context).textTheme.bodyLarge!.color!.withOpacity(0.08))
      ),
      padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeExtraSmall, horizontal: Dimensions.paddingSizeDefault),
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

            Image.asset(formEarning ? Images.earningImage : Images.convertedImage,
              width: 20, height: 20,color: Theme.of(context).primaryColor,
            ),
            const SizedBox(height: Dimensions.paddingSizeExtraSmall,),

            Text(
              getTranslated(data![index].transactionType, context),
              style: poppinsRegular.copyWith(fontSize: Dimensions.fontSizeDefault, color: Theme.of(context).disabledColor), maxLines: 1, overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: Dimensions.paddingSizeExtraSmall),

           if(data![index].createdAt != null) Text(DateConverterHelper.formatDate(data![index].createdAt!),
              style: poppinsRegular.copyWith(fontSize: Dimensions.fontSizeSmall,color: Theme.of(context).disabledColor),
              maxLines: 1, overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: Dimensions.paddingSizeExtraSmall),
            ],
          ),

          Column(crossAxisAlignment: CrossAxisAlignment.center,mainAxisAlignment: MainAxisAlignment.center, children: [
            Text(
             '${formEarning ? data![index].credit : data![index].debit}',
              style: poppinsMedium.copyWith(fontSize: Dimensions.fontSizeExtraLarge,), maxLines: 1, overflow: TextOverflow.ellipsis,
            ),
            Text(
              getTranslated('points', context),
              style: poppinsRegular.copyWith(fontSize: Dimensions.fontSizeDefault, color: Theme.of(context).disabledColor), maxLines: 1, overflow: TextOverflow.ellipsis,
            ),
            ],
          ),

        ],),
    );
  }
}

class WalletHistory extends StatelessWidget {
  final Transaction? transaction;
  const WalletHistory({Key? key, this.transaction}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool isDebit =  transaction!.debit! > 0;

    return Container(
      padding: EdgeInsets.symmetric(vertical: ResponsiveHelper.isDesktop(context) ?  Dimensions.paddingSizeDefault : 0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(Dimensions.radiusSizeDefault),
        color: Theme.of(context).cardColor,
        boxShadow: [BoxShadow(color: Theme.of(context).primaryColor.withOpacity(0.08), blurRadius: 30, offset: const Offset(0, 3))]
      ),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: isDebit ? Theme.of(context).colorScheme.error.withGreen(100) : Theme.of(context).primaryColor,
          child: Text('${isDebit ? '-' : '+'}${Provider.of<SplashProvider>(context, listen: false).configModel?.currencySymbol}', style: poppinsRegular.copyWith(
            fontSize: Dimensions.fontSizeLarge, color: Colors.white,
          )),
        ),
        title: CustomDirectionalityWidget(child: Text(
        PriceConverterHelper.convertPrice(context, isDebit ? transaction!.debit : transaction!.credit),
        overflow: TextOverflow.ellipsis,
        maxLines: 1,
        style: poppinsBold.copyWith(fontSize: Dimensions.fontSizeLarge),
      )),
        subtitle: Text(
          getTranslated(transaction!.transactionType, context),
          style: poppinsRegular.copyWith(
            fontSize: Dimensions.fontSizeDefault, color: Theme.of(context).disabledColor,
          ), maxLines: 1, overflow: TextOverflow.ellipsis,
        ),
        trailing: transaction!.createdAt != null ? Text(
          DateConverterHelper.formatDate(transaction!.createdAt!.toLocal()),
          style: poppinsRegular.copyWith(fontSize: Dimensions.fontSizeSmall,color: Theme.of(context).disabledColor),
          maxLines: 1, overflow: TextOverflow.ellipsis,
        ): const SizedBox(),

      ),
    );
  }
}



class CustomLayoutDivider extends StatelessWidget {
  final double height;
  final double dashWidth;
  final Color color;
  final Axis axis;
  const CustomLayoutDivider({Key? key, this.height = 1, this.dashWidth = 5, this.color = Colors.black, this.axis = Axis.horizontal}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final boxWidth = constraints.constrainWidth();
        final dashHeight = height;
        final dashCount = (boxWidth / (2 * dashWidth)).floor();
        return Flex(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          direction: axis,
          children: List.generate(dashCount, (_) {
            return SizedBox(
              width: dashWidth,
              height: dashHeight,
              child: DecoratedBox(
                decoration: BoxDecoration(color: color),
              ),
            );
          }),
        );
      },
    );
  }
}
