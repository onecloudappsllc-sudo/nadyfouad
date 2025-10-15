import 'package:flutter/material.dart';
import 'package:flutter_grocery/common/enums/popup_menu_type_enum.dart';
import 'package:flutter_grocery/common/models/language_model.dart';
import 'package:flutter_grocery/common/providers/cart_provider.dart';
import 'package:flutter_grocery/common/providers/language_provider.dart';
import 'package:flutter_grocery/common/providers/localization_provider.dart';
import 'package:flutter_grocery/common/providers/theme_provider.dart';
import 'package:flutter_grocery/common/widgets/custom_image_widget.dart';
import 'package:flutter_grocery/common/widgets/custom_text_field_widget.dart';
import 'package:flutter_grocery/common/widgets/language_hover_widget.dart';
import 'package:flutter_grocery/common/widgets/on_hover_widget.dart';
import 'package:flutter_grocery/common/widgets/profile_hover_widget.dart';
import 'package:flutter_grocery/common/widgets/text_hover_widget.dart';
import 'package:flutter_grocery/features/auth/providers/auth_provider.dart';
import 'package:flutter_grocery/features/category/domain/models/category_model.dart';
import 'package:flutter_grocery/features/category/providers/category_provider.dart';
import 'package:flutter_grocery/features/menu/widgets/currency_dialog_widget.dart';
import 'package:flutter_grocery/features/profile/providers/profile_provider.dart';
import 'package:flutter_grocery/features/search/providers/search_provider.dart';
import 'package:flutter_grocery/features/search/screens/search_result_screen.dart';
import 'package:flutter_grocery/features/splash/providers/splash_provider.dart';
import 'package:flutter_grocery/features/wishlist/providers/wishlist_provider.dart';
import 'package:flutter_grocery/helper/dialog_helper.dart';
import 'package:flutter_grocery/helper/route_helper.dart';
import 'package:flutter_grocery/localization/app_localization.dart';
import 'package:flutter_grocery/localization/language_constraints.dart';
import 'package:flutter_grocery/utill/app_constants.dart';
import 'package:flutter_grocery/utill/color_resources.dart';
import 'package:flutter_grocery/utill/dimensions.dart';
import 'package:flutter_grocery/utill/images.dart';
import 'package:flutter_grocery/utill/styles.dart';
import 'package:provider/provider.dart';


class WebAppBarWidget extends StatefulWidget implements PreferredSizeWidget {
  const WebAppBarWidget({Key? key}) : super(key: key);


  @override
  State<WebAppBarWidget> createState() => _WebAppBarWidgetState();

  @override
  // TODO: implement preferredSize
  Size get preferredSize => throw UnimplementedError();
}

class _WebAppBarWidgetState extends State<WebAppBarWidget> {
  String? chooseLanguage;

  @override
  Widget build(BuildContext context) {
    final ThemeProvider themeProvider =  Provider.of<ThemeProvider>(context, listen: false);
    Provider.of<LanguageProvider>(context, listen: false).initializeAllLanguages(context);
    final SplashProvider splashProvider = Provider.of<SplashProvider>(context, listen: false);
    final AuthProvider authProvider = Provider.of<AuthProvider>(context, listen: false);

    LanguageModel currentLanguage = AppConstants.languages.firstWhere((language) => language.languageCode == Provider.of<LocalizationProvider>(context, listen: false).locale.languageCode);

    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.10),
            blurRadius: 20,
            offset: const Offset(0,10),
          )
        ]
      ),
      child: Column(
        children: [
          Container(
            color: Theme.of(context).secondaryHeaderColor,
            height: 40,
            child: Center(
              child: SizedBox( width: Dimensions.webScreenWidth,
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeExtraSmall),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [

                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeExtraSmall),
                        child: Text('dark_mode'.tr, style: poppinsMedium.copyWith(
                          color: Theme.of(context).textTheme.bodyLarge?.color,
                          fontSize: Dimensions.paddingSizeDefault,
                        )),
                      ),
                      // StatusWidget(),
                      Transform.scale(
                        scale: 0.6,
                        child: Switch(
                          onChanged: (bool isActive) => themeProvider.toggleTheme(),
                          value: themeProvider.darkTheme,
                          activeTrackColor: Theme.of(context).primaryColor,
                          inactiveThumbColor: Colors.white,
                          activeColor: Colors.white,
                          inactiveTrackColor: Theme.of(context).primaryColor,

                        ),
                      ),
                      const SizedBox(width: Dimensions.paddingSizeSmall),

                      SizedBox(
                        height: Dimensions.paddingSizeLarge,

                        child: MouseRegion(
                          onHover: (details){
                            _showPopupMenu(details.position, context, PopupMenuType.language);
                          },
                          child: InkWell(
                            onTap: () => showDialogHelper(context, const CurrencyDialogWidget()),
                            // onTap: () => Navigator.pushNamed(context, RouteHelper.getLanguageRoute('menu')),
                            child: Row(
                              children: [
                                Text('${currentLanguage.languageCode?.toUpperCase()}',style: poppinsMedium.copyWith(color: Theme.of(context).textTheme.bodyLarge?.color)),
                                const SizedBox(width: Dimensions.paddingSizeExtraSmall),
                                Icon(Icons.expand_more, color: Theme.of(context).textTheme.bodyLarge?.color)
                              ],
                            ),
                          ),
                        ),
                      ),

                    ],
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: Container(color: Theme.of(context).cardColor,
              child: Center(
                child: SizedBox(
                    width: 1170,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Row(children: [
                          InkWell(
                            onTap: () {
                              if(ModalRoute.of(context)!.settings.name != RouteHelper.getMainRoute()) {
                                Navigator.pushNamed(context, RouteHelper.menu, arguments: false);
                              }
                            },
                            child: Row(
                              children: [
                                SizedBox(height: 50,
                                    child: Consumer<SplashProvider>(
                                      builder:(context, splash, child) => CustomImageWidget(
                                        placeholder: Images.webBarLogoPlaceHolder,
                                        image: splash.baseUrls != null ? '${splash.baseUrls!.ecommerceImageUrl}/${splash.configModel!.ecommerceLogo}' : '',
                                        fit: BoxFit.contain,
                                        width: 115,
                                      ),
                                    )),

                              ],
                            ),
                          ),
                          const SizedBox(width: 30),

                          TextHoverWidget(builder: (isHovered) {
                            return InkWell(
                              onTap: () {
                                if(ModalRoute.of(context)!.settings.name != RouteHelper.getMainRoute()) {
                                  Navigator.pushNamed(context, RouteHelper.menu, arguments: false);
                                }
                              },
                              child: Text('home'.tr, style: isHovered ?
                              poppinsSemiBold.copyWith(color: Theme.of(context).primaryColor,
                                  fontSize: Dimensions.fontSizeLarge) :
                              poppinsMedium.copyWith(color: Theme.of(context).textTheme.bodyLarge?.color,
                                  fontSize: Dimensions.fontSizeLarge)),
                            );
                          }),
                          const SizedBox(width: 30),

                          TextHoverWidget(
                            builder: (isHovered) {
                              return MouseRegion(onHover: (details){
                                if(Provider.of<CategoryProvider>(context, listen: false).categoryList != null){
                                  _showPopupMenu(details.position, context, PopupMenuType.category);
                                }

                              },
                                child: Row(children: [

                                  Text('categories'.tr,
                                      style: isHovered ? poppinsSemiBold.copyWith(color: Theme.of(context).primaryColor, fontSize: Dimensions.fontSizeLarge) :
                                        poppinsMedium.copyWith(color: Theme.of(context).textTheme.bodyLarge?.color,
                                        fontSize: Dimensions.fontSizeLarge),
                                    ),
                                  const SizedBox(width: Dimensions.paddingSizeExtraSmall),

                                  Icon(Icons.expand_more, color: Theme.of(context).primaryColor, size: 20),

                                ]),
                              );
                            }),
                        ]),


                        Row(children: [
                          Container(
                            width: 500,
                            decoration: BoxDecoration(
                              color:  Theme.of(context).disabledColor.withOpacity(0.05),
                              borderRadius: BorderRadius.circular(Dimensions.radiusSizeDefault),
                            ),
                            padding: const EdgeInsets.symmetric(horizontal: 0,vertical: 2),
                            child: Consumer<SearchProvider>(
                                builder: (context,search,_) {
                                  return CustomTextFieldWidget(
                                    hintText: getTranslated('search_for_products', context),
                                    isShowBorder: false,
                                    fillColor: Colors.transparent,
                                    isElevation: false,
                                    isShowSuffixIcon: true,
                                    imageColor: Theme.of(context).primaryColor,
                                    suffixAssetUrl: !search.isSearch ? Images.close : Images.search,
                                    onChanged: (str){
                                      str.length = 0;
                                      search.setSearchValue(str);
                                      },

                                    onSuffixTap: () {
                                      if(search.searchController.text.isNotEmpty && search.isSearch == true){

                                        Navigator.pushNamed(context, RouteHelper.getSearchResultRoute(search.searchController.text),
                                            arguments: SearchResultScreen(searchString: search.searchController.text));
                                        search.onChangeSearchStatus();
                                      }
                                      else if (search.searchController.text.isNotEmpty && search.isSearch == false) {
                                        search.searchController.clear();
                                        search.setSearchValue('');
                                        search.onChangeSearchStatus();
                                      }
                                    },
                                    controller: search.searchController,
                                    inputAction: TextInputAction.search,
                                    isIcon: true,
                                    onSubmit: (text) {
                                      if (search.searchController.text.isNotEmpty) {

                                        Navigator.pushNamed(context, RouteHelper.getSearchResultRoute(search.searchController.text));

                                        search.onChangeSearchStatus();
                                      }

                                    },);
                                }
                            ),
                          ),
                          const SizedBox(width: 70),

                          OnHoverWidget(child: InkWell(
                            onTap: () => Navigator.pushNamed(context, RouteHelper.favorite),
                            child: Consumer<WishListProvider>(builder: (context, wishListProvider, _)=> _ItemCountView(
                              count: wishListProvider.wishList?.length ?? 0, icon: Icons.favorite,
                            )),
                          )),
                          const SizedBox(width: Dimensions.paddingSizeExtraLarge),

                          OnHoverWidget(child: InkWell(
                            onTap: () => Navigator.pushNamed(context, RouteHelper.cart),
                            child: Consumer<CartProvider>(builder: (context, cartProvider, _)=> _ItemCountView(
                              count: cartProvider.cartList.length, icon: Icons.shopping_cart,
                            )),
                          )),
                          const SizedBox(width: Dimensions.paddingSizeExtraLarge),

                          Consumer<AuthProvider>(builder: (context, authProvider, _)=> InkWell(
                            onTap: () => !authProvider.isLoggedIn() ? Navigator.pushNamed(context, RouteHelper.login) : (){},
                            child: TextHoverWidget(builder: (isHover)=> OnHoverWidget(child: MouseRegion(
                              onHover: (details){
                                if(authProvider.isLoggedIn()) {
                                  _showPopupMenu(details.position, context, PopupMenuType.profile);
                                }
                              },
                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeExtraSmall),
                                child: authProvider.isLoggedIn() ? Consumer<ProfileProvider>(
                                  builder: (context, profileProvider, _) {
                                    return ClipRRect(
                                      borderRadius: BorderRadius.circular(Dimensions.radiusSizeDefault),
                                      child: CustomImageWidget(
                                        image: '${splashProvider.baseUrls!.customerImageUrl}/${profileProvider.userInfoModel != null ? profileProvider.userInfoModel!.image : ''}',
                                        placeholder: Images.profile,
                                        height: 32,
                                        width: 32,
                                      ),
                                    );
                                  }
                                ) : Icon(
                                  Icons.person, size: Dimensions.paddingSizeExtraLarge,
                                  color: isHover ? Theme.of(context).primaryColor : Theme.of(context).focusColor,
                                ),
                              )))),

                          )),

                          const SizedBox(width: Dimensions.paddingSizeExtraLarge),

                          IconButton(
                            onPressed: () => Navigator.pushNamed(context, RouteHelper.profileMenus),
                            icon: Icon(Icons.menu,size: Dimensions.fontSizeOverLarge, color: Theme.of(context).primaryColor),
                          ),
                        ]),
                      ],
                    )
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<PopupMenuEntry<Object>> _popUpMenuList(BuildContext context) {
    List<PopupMenuEntry<Object>> list = <PopupMenuEntry<Object>>[];
    List<CategoryModel>? categoryList =  Provider.of<CategoryProvider>(context, listen: false).categoryList;

    list.add(PopupMenuItem(
      padding: EdgeInsets.zero,
      value: categoryList,
      child: _CategoryHoverWidget(categoryList: categoryList),
    ));

    return list;
  }

  List<PopupMenuEntry<Object>> _popUpLanguageList(BuildContext context) {
    List<PopupMenuEntry<Object>> languagePopupMenuEntryList = <PopupMenuEntry<Object>>[];
    List<LanguageModel> languageList =  AppConstants.languages;
    languagePopupMenuEntryList.add(
        PopupMenuItem(
          padding: EdgeInsets.zero,
          value: languageList,
          child: MouseRegion(
            onExit: (_)=> Navigator.of(context).pop(),
            child: LanguageHoverWidget(languageList: languageList),
          ),
        ));
    return languagePopupMenuEntryList;
  }

  List<PopupMenuEntry<Object>> _profilePopUpMenuList(BuildContext context) {
    List<PopupMenuEntry<Object>> profilePopupMenuEntryList = <PopupMenuEntry<Object>>[];

    profilePopupMenuEntryList.add( PopupMenuItem(
      padding: EdgeInsets.zero,
      child: ProfileHoverWidget(currentRoute: ModalRoute.of(context)?.settings.name),
    ));

    return profilePopupMenuEntryList;
  }

  List<PopupMenuEntry<Object>> _getPopupItems(PopupMenuType type){
    switch (type) {
      case PopupMenuType.language:
        return _popUpLanguageList(context);
      case PopupMenuType.category:
        return _popUpMenuList(context);
      case PopupMenuType.profile:
        return _profilePopUpMenuList(context);
    }
  }

  void _showPopupMenu(Offset offset, BuildContext context, PopupMenuType type) async {
    double left = offset.dx;
    double top = offset.dy;
    final RenderBox overlay = Overlay.of(context).context.findRenderObject() as RenderBox;

    await showMenu(
      context: context,
      position: RelativeRect.fromLTRB(left, top, overlay.size.width, overlay.size.height),
      items: _getPopupItems(type),
      elevation: 8.0,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(
        Radius.circular(12),
      )),
    );

  }

  Size get preferredSize => const Size(double.maxFinite, 160);
}




class _ItemCountView extends StatelessWidget {
  final int count;
  final IconData icon;
  const _ItemCountView({
    super.key, required this.count, required this.icon,
  });

  @override
  Widget build(BuildContext context) {

    final AuthProvider authProvider = Provider.of<AuthProvider>(context, listen: false);

    return TextHoverWidget(builder: (isHover)=> Stack(clipBehavior: Clip.none, children: [
      Icon(icon, color: isHover ? Theme.of(context).primaryColor : Theme.of(context).focusColor,
        size: Dimensions.paddingSizeExtraLarge,
      ),

      if(count > 0 && ( (icon == Icons.favorite && authProvider.isLoggedIn()) || (icon != Icons.favorite))) Positioned(top: -15, right: -10, child: Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: Theme.of(context).cardColor, width: 2),
        ),
        child: Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Theme.of(context).primaryColor,
          ),
          padding: const EdgeInsets.all(Dimensions.paddingSizeExtraSmall),
          child: Text('$count',style: poppinsRegular.copyWith(
            color: Colors.white,
            fontSize: Dimensions.fontSizeExtraSmall,
          )),
        ),
      )),
    ]));
  }
}



class _CategoryHoverWidget extends StatefulWidget {
  final List<CategoryModel>? categoryList;
  const _CategoryHoverWidget({Key? key, required this.categoryList}) : super(key: key);

  @override
  State<_CategoryHoverWidget> createState() => _CategoryHoverWidgetState();
}

class _CategoryHoverWidgetState extends State<_CategoryHoverWidget> {
  bool isExited = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onExit: isExited ? null : (_)=> Navigator.of(context).pop(),
      child: Container(
        color: Theme.of(context).cardColor,
        padding: const EdgeInsets.all(Dimensions.paddingSizeExtraSmall),
        child: Column(
            children: widget.categoryList!.map((category) => InkWell(
              onTap: () async {
                setState(() {
                  isExited = true;
                });

                Future.delayed(const Duration(milliseconds: 0)).then((value) async{
                  Navigator.of(context).pushNamed(
                    RouteHelper.getCategoryProductsRoute(categoryId: category.id.toString()),
                  );
                });
              },
              child: TextHoverWidget(
                  builder: (isHover) {
                    return Container(
                      padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeExtraSmall, horizontal: Dimensions.paddingSizeDefault),
                      decoration: BoxDecoration(color: isHover ? ColorResources.getGreyColor(context) : Theme.of(context).cardColor, borderRadius: BorderRadius.circular(8)),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SizedBox(width: 200,child: Text(category.name ?? '', overflow: TextOverflow.ellipsis,maxLines: 1,)),
                        ],
                      ),
                    );
                  }
              ),
            )).toList()
        ),
      ),
    );
  }
}

