import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_grocery/helper/responsive_helper.dart';
import 'package:flutter_grocery/helper/route_helper.dart';
import 'package:flutter_grocery/localization/language_constraints.dart';
import 'package:flutter_grocery/features/search/providers/search_provider.dart';
import 'package:flutter_grocery/utill/dimensions.dart';
import 'package:flutter_grocery/utill/images.dart';
import 'package:flutter_grocery/utill/styles.dart';
import 'package:flutter_grocery/common/widgets/custom_text_field_widget.dart';
import 'package:flutter_grocery/common/widgets/web_app_bar_widget.dart';
import 'package:flutter_grocery/features/search/screens/search_result_screen.dart';
import 'package:provider/provider.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  int? pageSize;
  final ScrollController scrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    Provider.of<SearchProvider>(context, listen: false).initHistoryList();
    Provider.of<SearchProvider>(context, listen: false).initializeAllSortBy(notify: false);
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Theme.of(context).canvasColor,
      appBar: ResponsiveHelper.isDesktop(context)? const PreferredSize(preferredSize: Size.fromHeight(120), child: WebAppBarWidget()) :null,
      body: SafeArea(
        child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeLarge),
            child: Center(
              child: SizedBox(
                width: Dimensions.webScreenWidth,
                child: Consumer<SearchProvider>(
                  builder: (context, searchProvider, child) => Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 15),
                      Row(
                        children: [
                          Expanded(
                            child: CustomTextFieldWidget(
                              fillColor: Theme.of(context).disabledColor.withOpacity(0.001),
                              hintText: getTranslated('searchItem_here', context),
                              isShowBorder: true,
                              isShowPrefixIcon: true,
                              prefixAssetUrl: Images.search,
                              controller: _searchController,
                              inputAction: TextInputAction.search,
                              isIcon: true,
                              onSubmit: (text) {
                                if (_searchController.text.isNotEmpty) {
                                  List<int> encoded = utf8.encode(_searchController.text);
                                  String data = base64Encode(encoded);
                                  searchProvider.saveSearchAddress(_searchController.text);
                                  Navigator.pushNamed(context, '${RouteHelper.searchResult}?text=$data', arguments: SearchResultScreen(searchString: _searchController.text));
                                }
                              },
                            ),
                          ),
                          const SizedBox(width: 10),

                          InkWell(
                            onTap: () => Navigator.of(context).pop(),
                            child: Icon(Icons.close, color: Theme.of(context).disabledColor, size: 25),
                          ),

                        ],
                      ),
                      // for resent search section
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            getTranslated('recent_search', context),
                            style: poppinsMedium.copyWith(fontSize: Dimensions.fontSizeLarge),
                          ),
                          searchProvider.historyList.isNotEmpty
                              ? TextButton(
                                  onPressed: searchProvider.clearSearchAddress,
                                  child: Text(
                                    getTranslated('remove_all', context),
                                    style: poppinsMedium.copyWith(color: Theme.of(context).colorScheme.error,fontSize: Dimensions.fontSizeLarge),
                                  ))
                              : const SizedBox.shrink(),
                        ],
                      ),

                      // for recent search list section
                      Expanded(
                        child: ListView.builder(
                            itemCount: searchProvider.historyList.length,
                            physics: const BouncingScrollPhysics(),
                            itemBuilder: (context, index) => InkWell(
                                  onTap: () {
                                    List<int> encoded = utf8.encode(searchProvider.historyList[index]!);
                                    String data = base64Encode(encoded);
                                    searchProvider.getSearchProduct(offset: 1,query: searchProvider.historyList[index]!);
                                    Navigator.pushNamed(context, '${RouteHelper.searchResult}?text=$data', arguments: SearchResultScreen(searchString: searchProvider.historyList[index]));
                                   // Navigator.of(context).push(MaterialPageRoute(builder: (_) => SearchResultScreen(searchString: searchProvider.historyList[index])));
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.only(bottom: 9),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          children: [
                                            Icon(Icons.history, size: 16, color: Theme.of(context).hintColor.withOpacity(0.6)),
                                            const SizedBox(width: 13),
                                            Text(
                                              searchProvider.historyList[index]!,
                                            )
                                          ],
                                        ),
                                        Transform.rotate(
                                          angle: 45,
                                          child: const Icon(Icons.arrow_upward, size: 16),
                                        ),
                                      ],
                                    ),
                                  ),
                                )),
                      )
                    ],
                  ),
                ),
              ),
            )),
      ),
    );
  }
}
