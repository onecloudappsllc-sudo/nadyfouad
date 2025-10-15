import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_grocery/common/models/product_model.dart';
import 'package:flutter_grocery/common/widgets/custom_slider_list_widget.dart';
import 'package:flutter_grocery/utill/product_type.dart';
import 'package:flutter_grocery/helper/responsive_helper.dart';
import 'package:flutter_grocery/features/home/providers/flash_deal_provider.dart';
import 'package:flutter_grocery/common/providers/product_provider.dart';
import 'package:flutter_grocery/utill/dimensions.dart';
import 'package:flutter_grocery/common/widgets/product_widget.dart';
import 'package:flutter_grocery/common/widgets/web_product_shimmer_widget.dart';
import 'package:provider/provider.dart';

class HomeItemWidget extends StatefulWidget {
  final List<Product>? productList;
  final bool isFlashDeal;
  final bool isFeaturedItem;

  const HomeItemWidget({Key? key, this.productList, this.isFlashDeal = false, this.isFeaturedItem = false}) : super(key: key);

  @override
  State<HomeItemWidget> createState() => _HomeItemWidgetState();
}

class _HomeItemWidgetState extends State<HomeItemWidget> {
  final ScrollController scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Consumer<FlashDealProvider>(builder: (context, flashDealProvider, child) {
        return Consumer<ProductProvider>(builder: (context, productProvider, child) {


          return widget.productList != null ? Column(children: [
              widget.isFlashDeal ? SizedBox(
              height: 340,
              child: CarouselSlider.builder(
                itemCount: widget.productList!.length,
                options: CarouselOptions(
                  height: 340,
                  autoPlay: true,
                  autoPlayInterval: const Duration(seconds: 5),
                  autoPlayAnimationDuration: const Duration(milliseconds: 1000),
                  autoPlayCurve: Curves.fastOutSlowIn,
                  enlargeCenterPage: true,
                  viewportFraction: 0.6,
                  enlargeFactor: 0.2,
                  onPageChanged: (index, reason) {
                    flashDealProvider.setCurrentIndex(index);
                  },
                ),
                itemBuilder: (context, index, realIndex) {
                  return ProductWidget(
                    isGrid: true,
                    product: widget.productList![index],
                    productType: ProductType.flashSale,
                  );
                },
              )) : SizedBox(
                height: widget.isFeaturedItem ? 150 : 340,
                child: CustomSliderListWidget(
                  controller: scrollController,
                  verticalPosition: widget.isFeaturedItem ? 50 :  120,
                  isShowForwardButton: (widget.productList?.length ?? 0) > 3,
                  child: ListView.builder(
                    controller: scrollController,
                    padding: EdgeInsets.symmetric(horizontal: ResponsiveHelper.isDesktop(context) ? 0 : Dimensions.paddingSizeSmall),
                    itemCount: widget.productList?.length,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index) {
                      return Container(
                        width: widget.isFeaturedItem ? ResponsiveHelper.isDesktop(context) ?  370 : MediaQuery.of(context).size.width * 0.90 : 260,
                        // width: ResponsiveHelper.isDesktop(context) ? widget.isFeaturedItem ? 370 : 260 : widget.isFeaturedItem ? MediaQuery.of(context).size.width * 0.90 : MediaQuery.of(context).size.width * 0.65,
                        padding: const EdgeInsets.all(5),
                        child: ProductWidget(
                          isGrid: widget.isFeaturedItem ? false : true,
                          product: widget.productList![index],
                          productType: ProductType.dailyItem,
                        ),
                      );
                      },
                  ),
                ),
              ),
          ]) : SizedBox(
            height: 250,
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall),
              itemCount: 10,
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) {
                return Container(
                  width: 195,
                  padding: const EdgeInsets.all(5),
                  child: const WebProductShimmerWidget(isEnabled: true),
                );
              },
            ),
          );
        });
      }
    );
  }
}



