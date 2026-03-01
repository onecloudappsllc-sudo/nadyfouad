import 'package:flutter/material.dart';
import 'package:flutter_grocery/helper/responsive_helper.dart';
import 'package:flutter_grocery/localization/language_constraints.dart';
import 'package:flutter_grocery/features/search/providers/search_provider.dart';
import 'package:flutter_grocery/utill/dimensions.dart';
import 'package:flutter_grocery/utill/styles.dart';
import 'package:flutter_grocery/common/widgets/custom_button_widget.dart';
import 'package:flutter_xlider/flutter_xlider.dart';
import 'package:provider/provider.dart';

class FilterWidget extends StatefulWidget {
  final String? query;

  const FilterWidget({Key? key, this.query}) : super(key: key);

  @override
  State<FilterWidget> createState() => _FilterWidgetState();
}

class _FilterWidgetState extends State<FilterWidget> {

  @override
  void initState() {
    super.initState();

    Provider.of<SearchProvider>(context, listen: false).setLowerAndUpperValue(null, null, isUpdate: false);

  }

  @override
  Widget build(BuildContext context) {

    return Container(
      width: ResponsiveHelper.isDesktop(context) ? 500 : 700,
      padding: const EdgeInsets.all(Dimensions.paddingSizeLarge),
      child: Consumer<SearchProvider>(builder: (context, searchProvider, child) {
        final isNotEqualValue = (searchProvider.lowerValue ?? (searchProvider.searchProductModel?.minPrice ?? 0)) > (searchProvider.upperValue ?? (searchProvider.searchProductModel?.maxPrice ?? 0)) ;

        return SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [

                  const SizedBox(),

                  Align(
                    alignment: Alignment.center,
                    child: Text(
                      getTranslated('filter', context),
                      textAlign: TextAlign.center,
                      style: poppinsMedium.copyWith(
                        fontSize: Dimensions.fontSizeLarge,
                      ),
                    ),
                  ),

                  InkWell(
                    onTap: () => Navigator.of(context).pop(),
                    child: Icon(Icons.close, size: 25, color: Theme.of(context).disabledColor),
                  ),

                ],
              ),
              const SizedBox(height: 15),
              Text(
                getTranslated('price', context),
                style: poppinsMedium,
              ),

              // price range
              FlutterSlider(
                values: [searchProvider.lowerValue ?? (searchProvider.searchProductModel?.minPrice ?? 0),  (searchProvider.upperValue ?? (searchProvider.searchProductModel?.maxPrice ?? 0) + (isNotEqualValue ? 0 : 1))],
                rangeSlider: true,
                max: (searchProvider.searchProductModel?.maxPrice ?? 0) + (isNotEqualValue ? 0 : 1),
                min: searchProvider.searchProductModel?.minPrice ?? 0,
                handlerHeight: 25,
                handlerWidth: 25,
                trackBar: FlutterSliderTrackBar(activeTrackBar: BoxDecoration(color: Theme.of(context).primaryColor), activeTrackBarHeight: 6),
                handler: FlutterSliderHandler(decoration: BoxDecoration(color: Theme.of(context).primaryColor, shape: BoxShape.circle), child: const SizedBox()),
                rightHandler: FlutterSliderHandler(decoration: BoxDecoration(color: Theme.of(context).primaryColor, shape: BoxShape.circle), child: const SizedBox()),
                onDragging: (handlerIndex, lowerValue, upperValue) {
                  searchProvider.setLowerAndUpperValue(lowerValue, upperValue);
                },
              ),
              const SizedBox(height: Dimensions.paddingSizeDefault),

              Text(getTranslated('sort_by', context), style: poppinsMedium),
              const SizedBox(height: Dimensions.paddingSizeSmall),

              ListView.builder(
                itemCount: searchProvider.allSortBy.length,
                shrinkWrap: true,
                itemBuilder: (context, index) => InkWell(
                  onTap: () => searchProvider.setFilterValue(searchProvider.allSortBy[index]),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: Dimensions.paddingSizeSmall,
                      vertical: Dimensions.paddingSizeSmall,
                    ),

                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [

                        Container(
                          padding: const EdgeInsets.all(2),
                          width: 20,
                          height: 20,
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                  color: searchProvider.selectedFilter == searchProvider.allSortBy[index]
                                      ? Theme.of(context).primaryColor
                                      : Theme.of(context).hintColor.withOpacity(0.6),
                                  width: 2)),
                          child: searchProvider.selectedFilter == searchProvider.allSortBy[index]
                              ? Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Theme.of(context).primaryColor,
                            ),
                          )
                              : const SizedBox.shrink(),
                        ),
                        if(!ResponsiveHelper.isDesktop(context))const SizedBox(width: Dimensions.paddingSizeDefault),

                        if(!ResponsiveHelper.isDesktop(context))  Text(
                          getTranslated('${searchProvider.allSortBy[index]}', context),
                          style: poppinsRegular.copyWith(color: Theme.of(context).textTheme.bodyLarge?.color?.withOpacity(0.6)),
                        ),



                        if(ResponsiveHelper.isDesktop(context))
                          const SizedBox(width: Dimensions.paddingSizeDefault),

                        if(ResponsiveHelper.isDesktop(context))  Text(
                          getTranslated('${searchProvider.allSortBy[index]}', context),
                          style: poppinsRegular.copyWith(color: Theme.of(context).textTheme.bodyLarge?.color?.withOpacity(0.6)),
                        ),
                      ],
                    ),
                  ),
                ),

              ),
              const SizedBox(height: 30),

              Row(
                children: [
                  Expanded(
                    child: Container(height: 45,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(Dimensions.radiusSizeTen),
                        border: Border.all(color: Theme.of(context).disabledColor),
                      ),
                      child: CustomButtonWidget(
                        backgroundColor: Theme.of(context).cardColor,
                        textColor: Theme.of(context).disabledColor,
                        buttonText: getTranslated('reset', context),
                        onPressed: () {
                          searchProvider.setLowerAndUpperValue(null, null);
                          searchProvider.setFilterValue(null);
                        },
                      ),
                    ),
                  ),
                  const SizedBox(width: Dimensions.paddingSizeSmall),

                  Expanded(
                    child: SizedBox(height: 45,
                      child: CustomButtonWidget(
                        buttonText: getTranslated('apply', context),
                        onPressed: () {
                          searchProvider.getSearchProduct(
                            offset: 1, query: widget.query ?? '',
                            priceLow: searchProvider.lowerValue,
                            priceHigh: searchProvider.upperValue,
                            filterType: searchProvider.selectedFilter,
                            isUpdate: true,
                          );
                          Navigator.pop(context);
                        },
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 15),
            ],
          ),
        );
      }),
    );
  }
}
