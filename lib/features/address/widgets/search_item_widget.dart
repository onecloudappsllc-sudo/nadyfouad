import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_grocery/features/address/domain/models/prediction_model.dart';
import 'package:flutter_grocery/localization/language_constraints.dart';
import 'package:flutter_grocery/utill/dimensions.dart';

class SearchItemWidget extends StatelessWidget {
  final PredictionModel? suggestion;
  const SearchItemWidget({
    Key? key, this.suggestion,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
      child: Row(children: [
        const Icon(Icons.location_on),

        Expanded(child: Text(
          suggestion?.description ?? getTranslated('no_address_found', context), maxLines: 1, overflow: TextOverflow.ellipsis,
          style: Theme.of(context).textTheme.displayMedium?.copyWith(
            color: Theme.of(context).textTheme.bodyLarge?.color, fontSize: Dimensions.fontSizeLarge,
          ),
        )),
      ]),
    );
  }
}