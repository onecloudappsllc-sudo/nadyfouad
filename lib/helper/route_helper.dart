import 'dart:convert';
import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:flutter_grocery/common/models/config_model.dart';
import 'package:flutter_grocery/common/models/place_order_model.dart';
import 'package:flutter_grocery/features/address/domain/models/address_model.dart';
import 'package:flutter_grocery/features/auth/screens/otp_registration_screen.dart';
import 'package:flutter_grocery/features/auth/screens/send_otp_screen.dart';
import 'package:flutter_grocery/features/order/domain/models/order_model.dart';
import 'package:flutter_grocery/features/profile/domain/models/userinfo_model.dart';
import 'package:flutter_grocery/common/enums/html_type_enum.dart';
import 'package:flutter_grocery/helper/maintenance_helper.dart';
import 'package:flutter_grocery/helper/responsive_helper.dart';
import 'package:flutter_grocery/main.dart';
import 'package:flutter_grocery/features/splash/providers/splash_provider.dart';
import 'package:flutter_grocery/features/address/screens/add_new_address_screen.dart';
import 'package:flutter_grocery/features/address/screens/address_list_screen.dart';
import 'package:flutter_grocery/features/address/screens/select_location_screen.dart';
import 'package:flutter_grocery/features/auth/screens/create_account_screen.dart';
import 'package:flutter_grocery/features/auth/screens/login_screen.dart';
import 'package:flutter_grocery/features/maintainance/screens/maintainance_screen.dart';
import 'package:flutter_grocery/features/cart/screens/cart_screen.dart';
import 'package:flutter_grocery/features/category/screens/all_categories_screen.dart';
import 'package:flutter_grocery/features/chat/screens/chat_screen.dart';
import 'package:flutter_grocery/features/checkout/screens/checkout_screen.dart';
import 'package:flutter_grocery/features/checkout/screens/order_success_screen.dart';
import 'package:flutter_grocery/features/payment/screens/payment_screen.dart';
import 'package:flutter_grocery/features/payment/screens/web_payment_screen.dart';
import 'package:flutter_grocery/features/support/screens/support_screen.dart';
import 'package:flutter_grocery/features/coupon/screens/coupon_screen.dart';
import 'package:flutter_grocery/features/auth/screens/create_new_password_screen.dart';
import 'package:flutter_grocery/features/auth/screens/forgot_password_screen.dart';
import 'package:flutter_grocery/features/auth/screens/verification_screen.dart';
import 'package:flutter_grocery/features/home/screens/home_item_screen.dart';
import 'package:flutter_grocery/features/html/screens/html_viewer_screen.dart';
import 'package:flutter_grocery/features/wallet_and_loyalty/screens/loyalty_screen.dart';
import 'package:flutter_grocery/features/menu/screens/menu_screen.dart';
import 'package:flutter_grocery/features/not_found/screens/not_found_screen.dart';
import 'package:flutter_grocery/features/notification/screens/notification_screen.dart';
import 'package:flutter_grocery/features/onboarding/screens/on_boarding_screen.dart';
import 'package:flutter_grocery/features/order/screens/order_list_screen.dart';
import 'package:flutter_grocery/features/order/screens/order_details_screen.dart';
import 'package:flutter_grocery/features/order/screens/order_search_screen.dart';
import 'package:flutter_grocery/features/order/screens/track_order_screen.dart';
import 'package:flutter_grocery/features/product/screens/category_product_screen.dart';
import 'package:flutter_grocery/features/product/screens/product_image_screen.dart';
import 'package:flutter_grocery/features/product/screens/product_details_screen.dart';
import 'package:flutter_grocery/features/profile/screens/profile_edit_screen.dart';
import 'package:flutter_grocery/features/profile/screens/profile_screen.dart';
import 'package:flutter_grocery/features/refer_and_earn/screens/refer_and_earn_screen.dart';
import 'package:flutter_grocery/features/search/screens/search_result_screen.dart';
import 'package:flutter_grocery/features/search/screens/search_screen.dart';
import 'package:flutter_grocery/features/menu/screens/setting_screen.dart';
import 'package:flutter_grocery/features/splash/screens/splash_screen.dart';
import 'package:flutter_grocery/features/update/screens/update_screen.dart';
import 'package:flutter_grocery/features/wallet_and_loyalty/screens/wallet_screen.dart';
import 'package:flutter_grocery/features/wishlist/screens/wishlist_screen.dart';
import 'package:provider/provider.dart';

class RouteHelper {
  static final FluroRouter router = FluroRouter();

  static String splash = '/splash';
  static String orderDetails = '/order-details';
  static String onBoarding = '/on-boarding';
  static String menu = '/';
  static String login = '/login';
  static String favorite = '/favorite';
  static String forgetPassword = '/forget-password';
  static String verification = '/verification';
  static String createAccount = '/create-account';
  static String resetPassword = '/reset-password';
  static String updateAddress = '/update-address';
  static String selectLocation = '/select-location/';
  static String orderSuccessful = '/order-successful';
  static String payment = '/payment';
  static String checkout = '/checkout';
  static String notification = '/notification';
  static String trackOrder = '/track-order';
  static String categoryProducts = '/category-products';
  static String productDetails = '/product-details';
  static String productImages = '/product-images';
  static String profile = '/profile';
  static String searchProduct = '/search-product';
  static String profileEdit = '/profile-edit';
  static String searchResult = '/search-result';
  static String cart = '/cart';
  static String categories = '/categories';
  static String profileMenus = '/menus';
  static String orderListScreen = '/order-list';
  static String address = '/address';
  static String coupon = '/coupon';
  static const String chatScreen = '/chat-screen';
  static String settings = '/settings';
  static const String termsScreen = '/terms';
  static const String policyScreen = '/privacy-policy';
  static const String aboutUsScreen = '/about-us';
  static const String faqScreen = '/faqScreen';
  static const String homeItem = '/home-item';
  static const String maintenance = '/maintenance';
  static const String contactScreen = '/contact';
  static const String update = '/update';
  static const String addAddressScreen = '/add-address';
  static const String orderWebPayment = '/order-web-payment';
  static const String wallet = '/wallet';
  static const String referAndEarn = '/referAndEarn';
  static const String returnPolicyScreen = '/return-policy';
  static const String refundPolicyScreen = '/refund-policy';
  static const String cancellationPolicyScreen = '/cancellation-policy';
  static const String orderSearchScreen = '/order-search';
  static const String loyaltyScreen = '/loyalty';
  static const String sendOtp = '/send-otp-verification';
  static const String otpRegistration = '/otp-registration';



  static String getMainRoute() => menu;
  static String getLoginRoute() => login;
  static String getTermsRoute() => termsScreen;
  static String getPolicyRoute() => policyScreen;
  static String getAboutUsRoute() => aboutUsScreen;
  static String getFaqRoute() => faqScreen;
  static String getUpdateRoute() => update;
  static String getSelectLocationRoute() => selectLocation;
  static String getSendOtpScreen() => sendOtp;
  static String getOtpRegistration(String? tempToken, String userInput, {String? userName}){

    print("-------------------------(BEFORE ENCODING)---------$tempToken , $userInput");

    String data = '';
    if(tempToken?.isNotEmpty ?? false){
      data = Uri.encodeComponent(jsonEncode(tempToken));
    }
    String input = Uri.encodeComponent(jsonEncode(userInput));
    String name = '';
    name = Uri.encodeComponent(jsonEncode(userName ?? ''));
    return '$otpRegistration?tempToken=$data&input=$input&userName=$name';
  }

  static String getSplashRoute() => splash;


  static String getOrderDetailsRoute(String? id, {String? phoneNumber}) => '$orderDetails?id=$id&phone=${Uri.encodeComponent('$phoneNumber')}';
  static String getVerifyRoute(String userInput, String fromPage, {String? session}) {

    print("Session is $session");
    print("UserInput is $userInput");
    print("FromPage is $fromPage");

    String data = Uri.encodeComponent(jsonEncode(userInput));
    String authSession = base64Url.encode(utf8.encode(session ?? ''));
    return '$verification?page=$fromPage&userInput=$data&session=$authSession';
  }
  static String getNewPassRoute(String? userInput, String token) => '$resetPassword?email=${Uri.encodeComponent('$userInput')}&token=$token';
  //static String getAddAddressRoute(String page) => '$addAddress?page=$page';
  static String getAddAddressRoute(String page, String action, AddressModel addressModel) {
    String data = base64Url.encode(utf8.encode(jsonEncode(addressModel.toJson())));
    return '$addAddressScreen?page=$page&action=$action&address=$data';
  }
  static String getUpdateAddressRoute(AddressModel addressModel,) {
    String data = base64Url.encode(utf8.encode(jsonEncode(addressModel.toJson())));
    return '$updateAddress?address=$data';
  }
  static String getPaymentRoute({String? id = '', String? url, PlaceOrderModel? placeOrderBody}) {
    String uri = url != null ? Uri.encodeComponent(base64Encode(utf8.encode(url))) : 'null';
    String data = placeOrderBody != null ? base64Url.encode(utf8.encode(jsonEncode(placeOrderBody.toJson()))) : '';
    return '$payment?id=$id&uri=$uri&place_order=$data';
  }
  static String getCheckoutRoute(double amount, double? tax, double? discount, double? couponDiscount, String? type, String code, String freeDelivery, double weight) {
    if(freeDelivery.isNotEmpty){
      freeDelivery = base64Encode(utf8.encode(freeDelivery));
    }
    return '$checkout?amount=${base64Encode(utf8.encode('$amount'))}&tax=${base64Encode(utf8.encode('$tax'))}&discount=${base64Encode(utf8.encode('$discount'))}&couponDiscount=${base64Encode(utf8.encode('$couponDiscount'))}&type=$type&code=${base64Encode(utf8.encode(code))}&c-type=$freeDelivery&weight=${base64Encode(utf8.encode('$weight'))}';
  }

  static String getOrderTrackingRoute(int? id, String? phoneNumber) => '$trackOrder?id=$id&phone=${Uri.encodeComponent('$phoneNumber')}';

  static String getCategoryProductsRoute({required String categoryId, String? subCategory}) {
    return '$categoryProducts?category_id=$categoryId&subcategory=${Uri.encodeFull(subCategory ?? '')}';
  }

  static String getProductDetailsRoute({required int? productId, bool formSearch = false}) {
    String fromSearch = jsonEncode(formSearch);

    return '$productDetails?product_id=$productId&search=$fromSearch';
  }
  static String getProductImagesRoute(String? name, String images, String baseUrl) => '$productImages?name=$name&images=$images&base_url=${Uri.encodeComponent(baseUrl)}';
  static String getProfileEditRoute() => profileEdit;
  static String getHomeItemRoute(String productType) {
    return '$homeItem?item=$productType';
  }

  static String getMaintenanceRoute() => maintenance;
  static String getSearchResultRoute(String text) {
    List<int> encoded = utf8.encode(text);
    String data = base64Encode(encoded);
    return '$searchResult?text=$data';
  }
  static String getChatRoute({OrderModel? orderModel}) {
    String orderModel0 = base64Encode(utf8.encode(jsonEncode(orderModel)));
    return '$chatScreen?order=$orderModel0';
  }
  static String getContactRoute() => contactScreen;
  static String getFavoriteRoute() => favorite;
  static String getWalletRoute({String? token, String? status}) => '$wallet?token=$token&flag=$status';
  static String getReferAndEarnRoute() => referAndEarn;
  static String getReturnPolicyRoute() => returnPolicyScreen;
  static String getCancellationPolicyRoute() => cancellationPolicyScreen;
  static String getRefundPolicyRoute() => refundPolicyScreen;
  static String getLoyaltyScreen() => loyaltyScreen;
  static String getCreateAccount() => createAccount;
  static String getCartScreen() => cart;



  static final Handler _splashHandler = Handler(handlerFunc: (BuildContext? context, Map<String, dynamic> params) {
    return _routeHandler(child: const SplashScreen());
  });

  static final Handler _orderDetailsHandler = Handler(handlerFunc: (BuildContext? context, Map<String, dynamic> params) {
    OrderDetailsScreen? orderDetailsScreen = ModalRoute.of(context!)!.settings.arguments as OrderDetailsScreen?;
    return _routeHandler(child: orderDetailsScreen ?? OrderDetailsScreen(
      orderId: int.parse(params['id'][0]), orderModel: null,
      phoneNumber: Uri.decodeComponent(params['phone'][0]),
    ));
  });

  static final Handler _onBoardingHandler = Handler(handlerFunc: (BuildContext? context, Map<String, dynamic> params) => _routeHandler(child: OnBoardingScreen()));

  static final Handler _menuHandler = Handler(handlerFunc: (BuildContext? context, Map<String, dynamic> params) {
    bool? isLoad = ModalRoute.of(context!)?.settings.arguments as bool?;
    return _routeHandler(child: MenuScreen(isReload: isLoad ?? true));
  });

  static final Handler _loginHandler = Handler(handlerFunc: (BuildContext? context, Map<String, dynamic> params) => _routeHandler(child: const LoginScreen()));

  static final Handler _forgetPassHandler = Handler(handlerFunc: (BuildContext? context, Map<String, dynamic> params) => _routeHandler(child: const ForgotPasswordScreen()));


  static final Handler _verificationHandler = Handler(handlerFunc: (BuildContext? context, Map<String, dynamic> params) {

    return _routeHandler(child: VerificationScreen(
      fromPage: params['page'][0],
      userInput: jsonDecode(params['userInput'][0]),
      session: params['session'][0] == 'null' ? null : utf8.decode(base64Url.decode(params['session'][0].replaceAll(' ', '+'))),
    ));

  });



  static final Handler _createAccountHandler = Handler(handlerFunc: (BuildContext? context, Map<String, dynamic> params) => _routeHandler(
    child: const CreateAccountScreen(),
  ));

  static final Handler _resetPassHandler = Handler(handlerFunc: (BuildContext? context, Map<String, dynamic> params) {
    CreateNewPasswordScreen? createPassScreen = ModalRoute.of(context!)!.settings.arguments as CreateNewPasswordScreen?;

    return _routeHandler(child: createPassScreen ?? CreateNewPasswordScreen(
      userInput: Uri.decodeComponent(params['email'][0]),
      resetToken: params['token'][0],
    ));
  });


  static final Handler _updateAddressHandler = Handler(handlerFunc: (BuildContext? context, Map<String, dynamic> params) {
    AddNewAddressScreen? addNewAddressScreen = ModalRoute.of(context!)!.settings.arguments as AddNewAddressScreen?;

    String decoded = utf8.decode(base64Url.decode(params['address'][0].replaceAll(' ', '+')));
    return _routeHandler(child: addNewAddressScreen ?? AddNewAddressScreen(
      isEnableUpdate: true, fromCheckout: false, address:  AddressModel.fromJson(jsonDecode(decoded)),
    ));
  });

  static final Handler _selectLocationHandler = Handler(handlerFunc: (context, Map<String, dynamic> params) {
    SelectLocationScreen? locationScreen =  ModalRoute.of(context!)!.settings.arguments as SelectLocationScreen?;
    return _routeHandler(child: locationScreen ?? const Text('Not Found'));
  });

  static final Handler _orderSuccessHandler = Handler(
      handlerFunc: (context, Map<String, dynamic> params) {
        int status = (params['status'][0] == 'success' || params['status'][0] == 'payment-success') ? 0
            : (params['status'][0] == 'fail' || params['status'][0] == 'payment-fail') ? 1 : 2;
        return _routeHandler(child: OrderSuccessScreen(orderID: params['id'][0], status: status));
      }
  );

  static final Handler _orderWebPaymentHandler = Handler(
      handlerFunc: (context, Map<String, dynamic> params) {
        return _routeHandler(child: WebPaymentScreen(token: params['token'][0],));
      }
  );


  static final Handler _paymentHandler = Handler(handlerFunc: (BuildContext? context, Map<String, dynamic> params) {
    return _routeHandler(child: PaymentScreen(
        orderId:  int.tryParse(params['id'][0]),
        url: Uri.decodeComponent(utf8.decode(base64Decode(params['uri'][0]))),
    ));
  });

  static final Handler _checkoutHandler = Handler(handlerFunc: (BuildContext? context, Map<String, dynamic> params) {
    print("-------------------------(CHECKOUT HANDLER)-------------C-Type----${params['c-type'][0]}");
    print("----------------(CHECKOUT HANDLER)-----------Free Delivery ${utf8.decode(base64Decode(params['c-type'][0]))}");
    CheckoutScreen? checkoutScreen = ModalRoute.of(context!)!.settings.arguments as CheckoutScreen?;
    return _routeHandler(
      child: checkoutScreen ?? CheckoutScreen(
        orderType: params['type'][0],
        tax: double.parse(utf8.decode(base64Decode(params['tax'][0]))),
        discount: double.parse(utf8.decode(base64Decode(params['discount'][0]))),
        couponDiscount: double.parse(utf8.decode(base64Decode(params['couponDiscount'][0]))),
        amount: double.parse(utf8.decode(base64Decode(params['amount'][0]))),
        couponCode: utf8.decode(base64Decode(params['code'][0])),
        freeDeliveryType: utf8.decode(base64Decode(params['c-type'][0])),
        weight: double.parse(utf8.decode(base64Decode(params['weight'][0]))),
      ),
    );
  });

  static final Handler _notificationHandler = Handler(handlerFunc: (BuildContext? context, Map<String, dynamic> params) => _routeHandler(child: const NotificationScreen()));

  static final Handler _trackOrderHandler = Handler(handlerFunc: (BuildContext? context, Map<String, dynamic> params) {
    TrackOrderScreen? trackOrderScreen = ModalRoute.of(context!)!.settings.arguments as TrackOrderScreen?;
    return _routeHandler(child: trackOrderScreen ?? TrackOrderScreen(
      orderID: params['id'][0],
      phone: Uri.decodeComponent(params['phone'][0]),
    ));
  });

  static final Handler _categoryProductsHandlerNew = Handler(handlerFunc: (BuildContext? context, Map<String, dynamic> params) {
    return _routeHandler(child: CategoryProductScreen(
      categoryId: params['category_id'][0],
      subCategoryName: params['subcategory'][0],
    ));
  });


  static final Handler _productDetailsHandler = Handler(handlerFunc: (BuildContext? context, Map<String, dynamic> params) {
    bool? fromSearch = jsonDecode(params['search'][0]);
    //jsonDecode(params['search']);
    return _routeHandler(child: ProductDetailsScreen(productId: params['product_id'][0], fromSearch: fromSearch));
  });

  ///...............
  static final Handler _productImagesHandler = Handler(handlerFunc: (BuildContext? context, Map<String, dynamic> params) {
    ProductImageScreen? productImageScreen = ModalRoute.of(context!)!.settings.arguments as ProductImageScreen?;
    return _routeHandler(
      child: productImageScreen ?? ProductImageScreen(
        title: params['name'][0],
        baseUrl: Uri.decodeComponent(params['base_url'][0]),
        imageList: jsonDecode(params['images'][0]),
      ),
    );
  });

  static final Handler _profileHandler = Handler(handlerFunc: (BuildContext? context, Map<String, dynamic> params) => _routeHandler(child: const ProfileScreen()));

  static final Handler _searchProductHandler = Handler(handlerFunc: (BuildContext? context, Map<String, dynamic> params) => _routeHandler(child: const SearchScreen()));

  static final Handler _profileEditHandler = Handler(handlerFunc: (BuildContext? context, Map<String, dynamic> params) {
    return _routeHandler(child: const ProfileEditScreen());
  });

  static final Handler _searchResultHandler = Handler(handlerFunc: (BuildContext? context, Map<String, dynamic> params) {
    List<int> decode = base64Decode(params['text'][0]);
    String data = utf8.decode(decode);
    return _routeHandler(child: SearchResultScreen(searchString: data));
  });
  static final Handler _cartHandler = Handler(handlerFunc: (BuildContext? context, Map<String, dynamic> params) => _routeHandler(child: const CartScreen()));
  static final Handler _categoriesHandler = Handler(handlerFunc: (BuildContext? context, Map<String, dynamic> params) {
    return _routeHandler(child: const AllCategoriesScreen());
  } );
  static final Handler _profileMenusHandler = Handler(handlerFunc: (BuildContext? context, Map<String, dynamic> params) => _routeHandler(child: const MenuWidget()));
  static final Handler _orderListScreenHandler = Handler(handlerFunc: (BuildContext? context, Map<String, dynamic> params) => _routeHandler(child: const OrderListScreen()));
  static final Handler _addressHandler = Handler(handlerFunc: (BuildContext? context, Map<String, dynamic> params) => _routeHandler(child: const AddressListScreen()));
  static final Handler _couponHandler = Handler(handlerFunc: (BuildContext? context, Map<String, dynamic> params) => _routeHandler(child: const CouponScreen()));
  static final Handler _chatHandler = Handler(handlerFunc: (context, Map<String, dynamic> params) {
    final orderModel = jsonDecode(utf8.decode(base64Url.decode(params['order'][0].replaceAll(' ', '+'))));
    return _routeHandler(child: ChatScreen(orderModel : orderModel != null ? OrderModel.fromJson(orderModel) : null));
  });
  static final Handler _settingsHandler = Handler(handlerFunc: (BuildContext? context, Map<String, dynamic> params) => _routeHandler(child: const SettingsScreen()));
  static final Handler _termsHandler = Handler(handlerFunc: (context, Map<String, dynamic> params) => _routeHandler(child: const HtmlViewerScreen(htmlType: HtmlType.termsAndCondition)));

  static final Handler _policyHandler = Handler(handlerFunc: (context, Map<String, dynamic> params) => _routeHandler(child: const HtmlViewerScreen(htmlType: HtmlType.privacyPolicy)));

  static final Handler _aboutUsHandler = Handler(handlerFunc: (context, Map<String, dynamic> params) => _routeHandler(child: const HtmlViewerScreen(htmlType: HtmlType.aboutUs)));
  static final Handler _faqHandler = Handler(handlerFunc: (context, Map<String, dynamic> params) => _routeHandler(child: const HtmlViewerScreen(htmlType: HtmlType.faq)));

  static final Handler _homeItemHandler = Handler(handlerFunc: (context, Map<String, dynamic> params) {
    return _routeHandler(child: HomeItemScreen(productType: params['item'][0]));
  });
  static final Handler _maintenanceHandler = Handler(handlerFunc: (context, Map<String, dynamic> params) => _routeHandler(child: const MaintenanceScreen()));
  static final Handler _contactHandler = Handler(handlerFunc: (context, Map<String, dynamic> params) => _routeHandler(child: const SupportScreen()));
  static final Handler _sendOtpHandler = Handler(handlerFunc: (context, Map<String, dynamic> params) => _routeHandler(child: const SendOtpScreen()));

  static final Handler _updateHandler = Handler(handlerFunc: (context, Map<String, dynamic> params) => _routeHandler(child: const UpdateScreen()));
  static final Handler _newAddressHandler = Handler(handlerFunc: (context, Map<String, dynamic> params) {
    bool isUpdate = params['action'][0] == 'update';
    AddressModel? addressModel;
    if(isUpdate) {
      String decoded = utf8.decode(base64Url.decode(params['address'][0].replaceAll(' ', '+')));
      addressModel = AddressModel.fromJson(jsonDecode(decoded));
    }
    return _routeHandler(child: AddNewAddressScreen(fromCheckout: params['page'][0] == 'checkout', isEnableUpdate: isUpdate, address: isUpdate ? addressModel : null));
  });

  static final Handler _otpRegistrationHandler = Handler(handlerFunc: (context, Map<String, dynamic> params) {

    print("-------------------------(After ENCODING)---------");
    print("-------------------TempToken : ${jsonDecode(params['tempToken'][0] ?? '')}");
    print("-------------------Input : ${jsonDecode(params['input'][0] ?? '')}");
    print("-------------------UserName : ${jsonDecode(params['userName'][0] ?? '')}");

    return _routeHandler(
      child: OtpRegistrationScreen(
        tempToken: jsonDecode(params['tempToken'][0] ?? ''),
        userInput: jsonDecode(params['input'][0] ?? ''),
        userName : jsonDecode(params['userName'][0] ?? ''),
      ),
    );
  });


  static final Handler _favoriteHandler = Handler(handlerFunc: (context, Map<String, dynamic> params) => _routeHandler(child: const WishListScreen()));

  static final Handler _walletHandler = Handler(
    handlerFunc: (context, Map<String, dynamic> params) =>
        _routeHandler(child: WalletScreen(token: params['token'][0], status: params['flag'][0])),
  );

  static final Handler _referAndEarnHandler = Handler(
      handlerFunc: (context, Map<String, dynamic> params) =>
          _routeHandler(child: const ReferAndEarnScreen(),)
  );


  static final Handler _returnPolicyHandler = Handler(
    handlerFunc: (context, Map<String, dynamic> params) => _routeHandler(child: const HtmlViewerScreen(htmlType: HtmlType.returnPolicy)),
  );

  static final Handler _refundPolicyHandler = Handler(
    handlerFunc: (context, Map<String, dynamic> params) => _routeHandler(child: const HtmlViewerScreen(htmlType: HtmlType.refundPolicy)),
  );

  static final Handler _cancellationPolicyHandler = Handler(
    handlerFunc: (context, Map<String, dynamic> params) => _routeHandler(child: const HtmlViewerScreen(htmlType: HtmlType.cancellationPolicy)),
  );

  static final Handler _orderSearchHandler = Handler(
    handlerFunc: (context, Map<String, dynamic> params) => _routeHandler(child: const OrderSearchScreen()),
  );

  static final Handler _notFoundHandler = Handler(
    handlerFunc: (context, Map<String, dynamic> params) => _routeHandler(child: const NotFoundScreen()),
  );
  static final Handler _loyaltyHandler = Handler(
    handlerFunc: (context, Map<String, dynamic> params) => _routeHandler(child: const LoyaltyScreen()),
  );



  static void setupRouter(){
    router.define(splash, handler: _splashHandler, transitionType: TransitionType.fadeIn);
    router.define(orderDetails, handler: _orderDetailsHandler, transitionType: TransitionType.fadeIn);
    router.define(onBoarding, handler: _onBoardingHandler, transitionType: TransitionType.fadeIn);
    router.define(menu, handler: _menuHandler, transitionType: TransitionType.fadeIn);
    router.define(login, handler: _loginHandler, transitionType: TransitionType.fadeIn);
    router.define(forgetPassword, handler: _forgetPassHandler, transitionType: TransitionType.fadeIn);
    router.define(sendOtp, handler: _sendOtpHandler, transitionType: TransitionType.fadeIn);
    router.define(otpRegistration, handler: _otpRegistrationHandler, transitionType: TransitionType.fadeIn);
    router.define(verification, handler: _verificationHandler, transitionType: TransitionType.fadeIn);
    router.define(createAccount, handler: _createAccountHandler, transitionType: TransitionType.fadeIn);
    router.define(resetPassword, handler: _resetPassHandler, transitionType: TransitionType.fadeIn);
    router.define(updateAddress, handler: _updateAddressHandler, transitionType: TransitionType.fadeIn);
    router.define(selectLocation, handler: _selectLocationHandler, transitionType: TransitionType.fadeIn);
    router.define('$orderSuccessful/:id/:status', handler: _orderSuccessHandler, transitionType: TransitionType.fadeIn);
    router.define('$orderWebPayment/:status?:token', handler: _orderWebPaymentHandler, transitionType: TransitionType.fadeIn);
    router.define('$wallet/:status?:flag::token', handler: _walletHandler, transitionType: TransitionType.fadeIn);

    router.define(payment, handler: _paymentHandler, transitionType: TransitionType.fadeIn);
    router.define(checkout, handler: _checkoutHandler, transitionType: TransitionType.fadeIn);
    router.define(notification, handler: _notificationHandler, transitionType: TransitionType.fadeIn);
    router.define(trackOrder, handler: _trackOrderHandler, transitionType: TransitionType.fadeIn);
    router.define(categoryProducts, handler: _categoryProductsHandlerNew, transitionType: TransitionType.fadeIn);
    router.define(productDetails, handler: _productDetailsHandler, transitionType: TransitionType.fadeIn);
    router.define(productImages, handler: _productImagesHandler, transitionType: TransitionType.fadeIn);
    router.define(profile, handler: _profileHandler, transitionType: TransitionType.fadeIn);
    router.define(searchProduct, handler: _searchProductHandler, transitionType: TransitionType.fadeIn);
    router.define(profileEdit, handler: _profileEditHandler, transitionType: TransitionType.fadeIn);
    router.define(searchResult, handler: _searchResultHandler, transitionType: TransitionType.fadeIn);
    router.define(cart, handler: _cartHandler, transitionType: TransitionType.fadeIn);
    router.define(categories, handler: _categoriesHandler, transitionType: TransitionType.fadeIn);
    router.define(profileMenus, handler: _profileMenusHandler, transitionType: TransitionType.fadeIn);
    router.define(orderListScreen, handler: _orderListScreenHandler, transitionType: TransitionType.fadeIn);
    router.define(address, handler: _addressHandler, transitionType: TransitionType.fadeIn);
    router.define(coupon, handler: _couponHandler, transitionType: TransitionType.fadeIn);
    router.define(chatScreen, handler: _chatHandler, transitionType: TransitionType.fadeIn);
    router.define(settings, handler: _settingsHandler, transitionType: TransitionType.fadeIn);
    router.define(termsScreen, handler: _termsHandler, transitionType: TransitionType.fadeIn);
    router.define(policyScreen, handler: _policyHandler, transitionType: TransitionType.fadeIn);
    router.define(aboutUsScreen, handler: _aboutUsHandler, transitionType: TransitionType.fadeIn);
    router.define(faqScreen, handler: _faqHandler, transitionType: TransitionType.fadeIn);
    router.define(homeItem, handler: _homeItemHandler, transitionType: TransitionType.fadeIn);
    router.define(maintenance, handler: _maintenanceHandler, transitionType: TransitionType.fadeIn);
    router.define(contactScreen, handler: _contactHandler, transitionType: TransitionType.fadeIn);
    router.define(update, handler: _updateHandler, transitionType: TransitionType.fadeIn);
    router.define(addAddressScreen, handler: _newAddressHandler, transitionType: TransitionType.fadeIn);
    router.define(favorite, handler: _favoriteHandler, transitionType: TransitionType.fadeIn);
    router.define(wallet, handler: _walletHandler, transitionType: TransitionType.fadeIn);
    router.define(referAndEarn, handler: _referAndEarnHandler, transitionType: TransitionType.material);
    router.define(returnPolicyScreen, handler: _returnPolicyHandler, transitionType: TransitionType.fadeIn);
    router.define(refundPolicyScreen, handler: _refundPolicyHandler, transitionType: TransitionType.fadeIn);
    router.define(cancellationPolicyScreen, handler: _cancellationPolicyHandler, transitionType: TransitionType.fadeIn);
    router.define(orderSearchScreen, handler: _orderSearchHandler, transitionType: TransitionType.fadeIn);
    router.define(loyaltyScreen, handler: _loyaltyHandler, transitionType: TransitionType.fadeIn);
    router.notFoundHandler = _notFoundHandler;
  }

  static  Widget _routeHandler({required Widget child}) {
    return isMaintenance(Provider.of<SplashProvider>(Get.context!, listen: false).configModel)
        ? const MaintenanceScreen() :   child ;

  }

  static isMaintenance(ConfigModel? configModel) {
    if(MaintenanceHelper.isMaintenanceModeEnable(configModel)){
      if(MaintenanceHelper.checkWebMaintenanceMode(configModel) || MaintenanceHelper.checkCustomerMaintenanceMode(configModel)){
        return true;
      }else{
        return false;
      }
    }else{
      return false;
    }
  }


}