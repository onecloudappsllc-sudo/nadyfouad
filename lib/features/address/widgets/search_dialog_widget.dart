
import 'package:flutter/material.dart';
import 'package:flutter_grocery/common/widgets/custom_loader_widget.dart';
import 'package:flutter_grocery/common/widgets/no_data_widget.dart';
import 'package:flutter_grocery/features/address/domain/models/prediction_model.dart';
import 'package:flutter_grocery/features/address/widgets/search_item_widget.dart';
import 'package:flutter_grocery/helper/responsive_helper.dart';
import 'package:flutter_grocery/localization/language_constraints.dart';
import 'package:flutter_grocery/features/address/providers/location_provider.dart';
import 'package:flutter_grocery/utill/dimensions.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

class SearchDialogWidget extends StatelessWidget {
  final GoogleMapController? mapController;
  const SearchDialogWidget({super.key, required this.mapController});

  @override
  Widget build(BuildContext context) {
    final LocationProvider locationProvider = Provider.of<LocationProvider>(context, listen: false);

    return Container(
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(Dimensions.radiusSizeDefault)),
      margin: EdgeInsets.only(
        top: ResponsiveHelper.isDesktop(context) ? 160 : 75,
        right: Dimensions.paddingSizeSmall, left: Dimensions.paddingSizeSmall,
      ),
      alignment: Alignment.topCenter,
      child: SizedBox(width: 650, child: TypeAheadField<PredictionModel>(
        suggestionsCallback: (pattern) async => await locationProvider.searchLocation(context, pattern),
        builder: (context, controller, focusNode) => TextField(
          controller: controller,
          focusNode: focusNode,
          textInputAction: TextInputAction.search,
          autofocus: true,
          textCapitalization: TextCapitalization.words,
          keyboardType: TextInputType.streetAddress,

          decoration: InputDecoration(
            hintText: getTranslated('search_location', context),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(style: BorderStyle.none, width: 0),
            ),
            hintStyle: Theme.of(context).textTheme.displayMedium!.copyWith(
              fontSize: Dimensions.fontSizeDefault, color: Theme.of(context).disabledColor,
            ),
            filled: true,
            fillColor: Theme.of(context).cardColor,

          ),
          style: Theme.of(context).textTheme.displayMedium!.copyWith(
            color: Theme.of(context).textTheme.bodyLarge!.color,
            fontSize: Dimensions.fontSizeLarge,
          ),
        ),
        itemBuilder: (context, suggestion) => SearchItemWidget(suggestion: suggestion),
        onSelected: (PredictionModel suggestion) {
          locationProvider.setLocation(suggestion.placeId, suggestion.description, mapController);
          Navigator.pop(context);
        },
        loadingBuilder: (context) => CustomLoaderWidget(color: Theme.of(context).primaryColor),
        errorBuilder: (context, error) => const SearchItemWidget(),
        emptyBuilder: (context) => const SearchItemWidget(),
      )),
    );
  }
}

