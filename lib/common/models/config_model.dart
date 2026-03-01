import 'package:flutter_grocery/features/auth/enum/from_page_enum.dart';

class ConfigModel {
  String? _ecommerceName;
  String? _ecommerceLogo;
  String? _ecommerceAddress;
  String? _ecommercePhone;
  String? _ecommerceEmail;
  EcommerceLocationCoverage? _ecommerceLocationCoverage;
  double? _minimumOrderValue;
  int? _selfPickup;
  BaseUrls? _baseUrls;
  String? _currencySymbol;
  double? _deliveryCharge;
  bool? _cashOnDelivery;
  String? _digitalPayment;
  List<Branches>? _branches;
  String? _termsAndConditions;
  String? _privacyPolicy;
  String? _aboutUs;
  bool? _emailVerification;
  bool? _phoneVerification;
  String? _currencySymbolPosition;
  String? _country;
  DeliveryManagement? _deliveryManagement;
  PlayStoreConfig? _playStoreConfig;
  AppStoreConfig? _appStoreConfig;
  List<SocialMediaLink>? _socialMediaLink;
  String? _footerCopyright;
  int? _decimalPointSettings;
  String? _timeFormat;
  String? _faq;
  SocialStatus? _socialLoginStatus;
  double? _loyaltyPointItemPurchasePoint;
  bool? _loyaltyPointStatus;
  double?  _loyaltyPointMinimumPoint;
  double? _loyaltyPointExchangeRate;
  bool? _referEarningStatus;
  bool? _walletStatus;
  Whatsapp? _whatsapp;
  CookiesManagement? _cookiesManagement;
  bool? _offlinePayment;
  double? _freeDeliveryOverAmount;
  bool? _freeDeliveryStatus;
  bool? _isVatTexInclude;
  String? _cancellationPolicy;
  String? _returnPolicy;
  String? _refundPolicy;
  Telegram? _telegram;
  Messenger? _messenger;
  bool? _featuredProductStatus;
  bool? _trendingProductStatus;
  bool? _mostReviewedProductStatus;
  bool? _recommendedProductStatus;
  bool? _flashDealProductStatus;
  double? _maxOrderForCODAmount;
  bool? _maxAmountCodStatus;
  bool? _returnPolicyStatus;
  bool? _refundPolicyStatus;
  bool? _cancellationPolicyStatus;
  int? _otpResendTime;
  bool? _isGuestCheckout;
  List<PaymentMethod>? _activePaymentMethodList;
  bool? _isOfflinePayment;
  bool? _isPartialPayment;
  bool? _isAddFundToWallet;
  String? _partialPaymentCombineWith;
  AppleLogin? _appleLogin;
  bool? _isFirebaseOTPVerification;
  bool? _orderImageStatus;
  CustomerLogin? _customerLogin;
  String? _orderImageLabelName;
  MaintenanceMode? _maintenanceMode;
  CustomerVerification? _customerVerification;
  bool? _googleMapStatus;
  ForgetPassword? _forgetPassword;







  ConfigModel(
      {String? ecommerceName,
        String? ecommerceLogo,
        String? ecommerceAddress,
        String? ecommercePhone,
        String? ecommerceEmail,
        EcommerceLocationCoverage? ecommerceLocationCoverage,
        double? minimumOrderValue,
        int? selfPickup,
        BaseUrls? baseUrls,
        String? currencySymbol,
        double? deliveryCharge,
        bool? cashOnDelivery,
        String? digitalPayment,
        List<Branches>? branches,
        String? termsAndConditions,
        bool? emailVerification,
        bool? phoneVerification,
        String? currencySymbolPosition,
        String? country,
        DeliveryManagement? deliveryManagement,
        PlayStoreConfig? playStoreConfig,
        AppStoreConfig? appStoreConfig,
        List<SocialMediaLink>? socialMediaLink,
        String? footerCopyright,
        int? decimalPointSettings,
        String? timeFormat,
        String? faq,
        SocialStatus? socialLoginStatus,
        double? loyaltyPointItemPurchasePoint,
        bool? loyaltyPointStatus,
        double? loyaltyPointMinimumPoint,
        double? loyaltyPointExchangeRate,
        bool? referEarningStatus,
        bool? walletStatus,
        Whatsapp? whatsapp,
        CookiesManagement? cookiesManagement,
        bool? offlinePayment,
        double? freeDeliveryOverAmount,
        bool? freeDeliveryStatus,
        bool? isVatTexInclude,
        String? cancellationPolicy,
        String? returnPolicy,
        String? refundPolicy,
        Telegram? telegram,
        Messenger? messenger,
        bool? featuredProductStatus,
        bool? trendingProductStatus,
        bool? mostReviewedProductStatus,
        bool? recommendedProductStatus,
        bool? maxAmountCodStatus,
        double? maxOrderForCODAmount,
        bool? flashDealProductStatus,
        bool? returnPolicyStatus,
        bool? refundPolicyStatus,
        bool? cancellationPolicyStatus,
        int? otpResendTime,
        bool? isGuestCheckout,
        List<PaymentMethod>? activePaymentMethodList,
        bool? isOfflinePayment,
        bool? isPartialPayment,
        bool? isAddFundToWallet,
        String? partialPaymentCombineWith,
        AppleLogin? appleLogin,
        bool? isFirebaseOTPVerification,
        bool? orderImageStatus,
        String? orderImageLabelName,
        CustomerLogin? customerLogin,
        MaintenanceMode? maintenanceMode,
        CustomerVerification? customerVerification,
        bool? googleMapStatus,
        ForgetPassword? forgetPassword
      }) {
    _ecommerceName = ecommerceName;
    _ecommerceLogo = ecommerceLogo;
    _ecommerceAddress = ecommerceAddress;
    _ecommercePhone = ecommercePhone;
    _ecommerceEmail = ecommerceEmail;
    _ecommerceLocationCoverage = ecommerceLocationCoverage;
    _minimumOrderValue = minimumOrderValue;
    _selfPickup = selfPickup;
    _baseUrls = baseUrls;
    _currencySymbol = currencySymbol;
    _deliveryCharge = deliveryCharge;
    _cashOnDelivery = cashOnDelivery;
    _digitalPayment = digitalPayment;
    _branches = branches;
    _termsAndConditions = termsAndConditions;
    _aboutUs = aboutUs;
    _privacyPolicy = privacyPolicy;
    _emailVerification = emailVerification;
    _phoneVerification = phoneVerification;
    _currencySymbolPosition = currencySymbolPosition;
    _country = country;
    _deliveryManagement = deliveryManagement;
    _playStoreConfig = playStoreConfig;
    _appStoreConfig = appStoreConfig;
    _socialMediaLink = socialMediaLink;
    _footerCopyright = footerCopyright;
    _decimalPointSettings = decimalPointSettings;
    _timeFormat = timeFormat;
    _faq = faq;
    _socialLoginStatus = socialLoginStatus;
    _loyaltyPointItemPurchasePoint = loyaltyPointItemPurchasePoint;
    _loyaltyPointStatus = _loyaltyPointStatus;
    _loyaltyPointMinimumPoint = loyaltyPointMinimumPoint;
    _loyaltyPointExchangeRate = loyaltyPointExchangeRate;
    _referEarningStatus = referEarningStatus;
    _walletStatus = walletStatus;
    _whatsapp = whatsapp;
    _cookiesManagement = cookiesManagement;
    _offlinePayment = offlinePayment;
    _freeDeliveryOverAmount = freeDeliveryOverAmount;
    _maxOrderForCODAmount = maxOrderForCODAmount;
    _freeDeliveryStatus = freeDeliveryStatus;
    _isVatTexInclude = isVatTexInclude;
    _returnPolicy = returnPolicy;
    _refundPolicy = refundPolicy;
    _cancellationPolicy = cancellationPolicy;
    _telegram = telegram;
    _messenger = messenger;
    _featuredProductStatus = featuredProductStatus;
    _trendingProductStatus = trendingProductStatus;
    _mostReviewedProductStatus = mostReviewedProductStatus;
    _recommendedProductStatus = recommendedProductStatus;
    _maxAmountCodStatus = maxAmountCodStatus;
    _flashDealProductStatus = flashDealProductStatus;
    _cancellationPolicyStatus = cancellationPolicyStatus;
    _refundPolicyStatus = refundPolicyStatus;
    _returnPolicyStatus = returnPolicyStatus;
    _otpResendTime = otpResendTime;
    _isGuestCheckout = isGuestCheckout;
    _activePaymentMethodList = activePaymentMethodList;
    _isOfflinePayment = isOfflinePayment;
    _isPartialPayment = isPartialPayment;
    _isAddFundToWallet = isAddFundToWallet;
    _partialPaymentCombineWith = partialPaymentCombineWith;
    _appleLogin = appleLogin;
    _customerVerification = customerVerification;
    _isFirebaseOTPVerification = isFirebaseOTPVerification;
    _orderImageStatus = orderImageStatus;
    _orderImageLabelName = orderImageLabelName;
    _googleMapStatus = googleMapStatus;
    if(customerLogin != null){
      _customerLogin = customerLogin;
    }
    if (maintenanceMode != null) {
      _maintenanceMode = maintenanceMode;
    }
    if(forgetPassword != null){
      _forgetPassword = forgetPassword;
    }

  }

  String? get ecommerceName => _ecommerceName;
  String? get ecommerceLogo => _ecommerceLogo;
  String? get ecommerceAddress => _ecommerceAddress;
  String? get ecommercePhone => _ecommercePhone;
  String? get ecommerceEmail => _ecommerceEmail;
  EcommerceLocationCoverage? get ecommerceLocationCoverage => _ecommerceLocationCoverage;
  double? get minimumOrderValue => _minimumOrderValue;
  int? get selfPickup => _selfPickup;
  BaseUrls? get baseUrls => _baseUrls;
  String? get currencySymbol => _currencySymbol;
  double? get deliveryCharge => _deliveryCharge;
  bool? get cashOnDelivery => _cashOnDelivery;
  String? get digitalPayment => _digitalPayment;
  List<Branches>? get branches => _branches;
  String? get termsAndConditions => _termsAndConditions;
  String? get aboutUs=> _aboutUs;
  String? get privacyPolicy=> _privacyPolicy;
  bool? get emailVerification => _emailVerification;
  bool? get phoneVerification => _phoneVerification;
  String? get currencySymbolPosition => _currencySymbolPosition;
  String? get country => _country;
  DeliveryManagement? get deliveryManagement => _deliveryManagement;
  PlayStoreConfig? get playStoreConfig => _playStoreConfig;
  AppStoreConfig? get appStoreConfig => _appStoreConfig;
  List<SocialMediaLink>? get socialMediaLink => _socialMediaLink;
  String? get footerCopyright => _footerCopyright;
  int? get decimalPointSettings => _decimalPointSettings;
  String? get timeFormat => _timeFormat;
  String? get faq => _faq;
  SocialStatus? get socialLoginStatus => _socialLoginStatus;
  double? get loyaltyPointItemPurchasePoint => _loyaltyPointItemPurchasePoint;
  bool? get loyaltyPointStatus => _loyaltyPointStatus;
  double? get loyaltyPointMinimumPoint => _loyaltyPointMinimumPoint;
  double? get loyaltyPointExchangeRate => _loyaltyPointExchangeRate;
  bool? get referEarnStatus => _referEarningStatus;
  bool? get walletStatus => _walletStatus;
  Whatsapp? get whatsapp => _whatsapp;
  CookiesManagement? get cookiesManagement => _cookiesManagement;
  bool? get offlinePayment => _offlinePayment;
  double? get freeDeliveryOverAmount => _freeDeliveryOverAmount;
  bool? get freeDeliveryStatus => _freeDeliveryStatus;
  bool? get isVatTexInclude => _isVatTexInclude;
  String? get cancellationPolicy => _cancellationPolicy;
  String? get refundPolicy => _refundPolicy;
  String? get returnPolicy => _returnPolicy;
  Telegram? get telegram => _telegram;
  Messenger? get messenger => _messenger;
  bool? get featuredProductStatus => _featuredProductStatus;
  bool? get trendingProductStatus => _trendingProductStatus;
  bool? get mostReviewedProductStatus => _mostReviewedProductStatus;
  bool? get recommendedProductStatus => _recommendedProductStatus;
  bool? get flashDealProductStatus => _flashDealProductStatus;
  double? get maxOrderForCODAmount => _maxOrderForCODAmount;
  bool? get maxAmountCodStatus => _maxAmountCodStatus;
  bool? get returnPolicyStatus => _returnPolicyStatus;
  bool? get refundPolicyStatus => _refundPolicyStatus;
  bool? get cancellationPolicyStatus => _cancellationPolicyStatus;
  int? get otpResendTime => _otpResendTime;
  bool? get isGuestCheckout => _isGuestCheckout;
  List<PaymentMethod>? get activePaymentMethodList => _activePaymentMethodList;
  bool? get isOfflinePayment => _isOfflinePayment;
  bool? get isPartialPayment => _isPartialPayment;
  bool? get isAddFundToWallet => _isAddFundToWallet;
  String? get partialPaymentCombineWith => _partialPaymentCombineWith;
  AppleLogin? get appleLogin => _appleLogin;
  bool? get isFirebaseOTPVerification => _isFirebaseOTPVerification;
  bool? get orderImageStatus => _orderImageStatus;
  CustomerLogin? get customerLogin => _customerLogin;
  String? get orderImageLabelName => _orderImageLabelName;
  MaintenanceMode? get maintenanceMode => _maintenanceMode;
  CustomerVerification? get customerVerification => _customerVerification;
  bool? get googleMapStatus => _googleMapStatus;
  ForgetPassword? get forgetPassword => _forgetPassword;




  ConfigModel.fromJson(Map<String, dynamic> json) {
    _ecommerceName = json['ecommerce_name'];
    _ecommerceLogo = json['ecommerce_logo'];
    _ecommerceAddress = json['ecommerce_address'];
    _ecommercePhone = json['ecommerce_phone'];
    _ecommerceEmail = json['ecommerce_email'];
    _ecommerceLocationCoverage = json['ecommerce_location_coverage'] != null
        ? EcommerceLocationCoverage.fromJson(
        json['ecommerce_location_coverage'])
        : null;
    _minimumOrderValue = json['minimum_order_value'].toDouble();
    _selfPickup = json['self_pickup'];
    _baseUrls = json['base_urls'] != null
        ? BaseUrls.fromJson(json['base_urls'])
        : null;
    _currencySymbol = json['currency_symbol'];
    _deliveryCharge = double.parse('${json['delivery_charge']}');
    _cashOnDelivery = '${json['cash_on_delivery']}'.contains('true');
    _digitalPayment = json['digital_payment'];
    if (json['branches'] != null) {
      _branches = [];
      json['branches'].forEach((v) {
        _branches!.add(Branches.fromJson(v));
      });
    }
    _termsAndConditions = json['terms_and_conditions'];
    _privacyPolicy = json['privacy_policy'];
    _aboutUs = json['about_us'];
    _emailVerification = json['email_verification'];
    _phoneVerification = json['phone_verification'];
    _currencySymbolPosition = json['currency_symbol_position'];
    _country = json['country'];
    _deliveryManagement = json['delivery_management'] != null
        ? DeliveryManagement.fromJson(json['delivery_management'])
        : null;
    _customerLogin = json['customer_login'] != null
        ? CustomerLogin.fromJson(json['customer_login'])
        : null;
    _maintenanceMode = json['advance_maintenance_mode'] != null
        ? MaintenanceMode.fromJson(json['advance_maintenance_mode'])
        : null;
    _playStoreConfig = json['play_store_config'] != null
        ? PlayStoreConfig.fromJson(json['play_store_config'])
        : null;
    _forgetPassword = json['forgot_password'] != null
        ? ForgetPassword.fromJson(json['forgot_password'])
        : null;
    _appStoreConfig = json['app_store_config'] != null
        ? AppStoreConfig.fromJson(json['app_store_config'])
        : null;
    if (json['social_media_link'] != null) {
      _socialMediaLink = [];
      json['social_media_link'].forEach((v) {
        _socialMediaLink!.add(SocialMediaLink.fromJson(v));
      });
    }
    if(json['footer_text']!=null){
      _footerCopyright = json['footer_text'];
    }
    try{
      _decimalPointSettings = int.parse(json['decimal_point_settings'].toString());
      _timeFormat =  json['time_format'] ?? 12 as String?;
    }catch(e){
      _decimalPointSettings = 1;
      _timeFormat = '24';

    }
    _faq = json['faq'] ?? '';
    _socialLoginStatus = SocialStatus.fromJson(json['social_login']) ;

    _loyaltyPointItemPurchasePoint = double.tryParse('${json['loyalty_point_item_purchase_point']}');
    _loyaltyPointMinimumPoint = double.tryParse('${json['loyalty_point_minimum_point']}');
    _loyaltyPointExchangeRate = double.tryParse('${json['loyalty_point_exchange_rate']}');
    _referEarningStatus = '${json['ref_earning_status']}'.contains('1');
    _loyaltyPointStatus = '${json['loyalty_point_status']}'.contains('1');
    _walletStatus = '${json['wallet_status']}'.contains('1');
    _customerVerification = CustomerVerification.fromJson(json['customer_verification']);

    _cookiesManagement = json['cookies_management'] != null
        ? CookiesManagement.fromJson(json['cookies_management'])
        : null;

    _offlinePayment = '${json['offline_payment']}' == 'true';
    _freeDeliveryOverAmount = double.tryParse('${json['free_delivery_over_amount']}');
    _maxOrderForCODAmount = double.tryParse('${json['maximum_amount_for_cod_order']}');
    _maxAmountCodStatus = '${json['maximum_amount_for_cod_order_status']}'.contains('1');
    _freeDeliveryStatus = '${json['free_delivery_over_amount_status']}'.contains('1');
    _isVatTexInclude = '${json['product_vat_tax_status']}' == 'included';
    _returnPolicy =  '${json['return_policy']}';
    _refundPolicy =  '${json['refund_policy']}';
    _cancellationPolicy = '${json['cancellation_policy']}';
    _telegram = json['telegram'] != null ? Telegram.fromJson(json['telegram']) : null;
    _messenger = json['messenger'] != null ? Messenger.fromJson(json['messenger']) : null;
    _whatsapp = json['whatsapp'] != null ? Whatsapp.fromJson(json['whatsapp']) : null;

    _featuredProductStatus =  '${json['featured_product_status']}'.contains('1');
    _trendingProductStatus =  '${json['trending_product_status']}'.contains('1');
    _mostReviewedProductStatus =  '${json['most_reviewed_product_status']}'.contains('1');
    _recommendedProductStatus =  '${json['recommended_product_status']}'.contains('1');
    _flashDealProductStatus = '${json['flash_deal_product_status']}'.contains('1');
    _cancellationPolicyStatus =  '${json['cancellation_policy_status']}'.contains('1');
    _refundPolicyStatus =  '${json['refund_policy_status']}'.contains('1');
    _returnPolicyStatus =  '${json['return_policy_status']}'.contains('1');
    _otpResendTime =  int.tryParse('${json['otp_resend_time']}');
    _isGuestCheckout = '${json['guest_checkout']}'.contains('1');
    if (json['active_payment_method_list'] != null) {
      _activePaymentMethodList = <PaymentMethod>[];
      json['active_payment_method_list'].forEach((v) {
        activePaymentMethodList!.add(PaymentMethod.fromJson(v));
      });
    }
    _googleMapStatus = '${json['google_map_status']}' == '1';
    _isOfflinePayment = json['offline_payment'] == 'true';
    _isPartialPayment = '${json['partial_payment']}'.contains('1');
    _isAddFundToWallet = '${json['add_fund_to_wallet']}'.contains('1');
    _partialPaymentCombineWith = json['partial_payment_combine_with'];
    _appleLogin = AppleLogin.fromJson(json['apple_login']);
    _isFirebaseOTPVerification = '${json['firebase_otp_verification_status']}'.contains('1');
    _orderImageStatus = '${json['order_image_status']}'.contains('1');
    _orderImageLabelName = json['order_image_label_name'];

  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['ecommerce_name'] = _ecommerceName;
    data['ecommerce_logo'] = _ecommerceLogo;
    data['ecommerce_address'] = _ecommerceAddress;
    data['ecommerce_phone'] = _ecommercePhone;
    data['ecommerce_email'] = _ecommerceEmail;
    if (_ecommerceLocationCoverage != null) {
      data['ecommerce_location_coverage'] =
          _ecommerceLocationCoverage!.toJson();
    }
    data['minimum_order_value'] = _minimumOrderValue;
    data['self_pickup'] = _selfPickup;
    if (_baseUrls != null) {
      data['base_urls'] = _baseUrls!.toJson();
    }
    data['currency_symbol'] = _currencySymbol;
    data['delivery_charge'] = _deliveryCharge;
    data['cash_on_delivery'] = _cashOnDelivery;
    data['digital_payment'] = _digitalPayment;
    if (_branches != null) {
      data['branches'] = _branches!.map((v) => v.toJson()).toList();
    }
    data['termsAndConditions'] = _termsAndConditions;
    data['privacy_policy'] = _privacyPolicy;
    data['about_us'] = _aboutUs;
    data['email_verification'] = _emailVerification;
    data['phone_verification'] = _phoneVerification;
    data['currency_symbol_position'] = _currencySymbolPosition;
    data['country'] = _country;
    if (_deliveryManagement != null) {
      data['delivery_management'] = _deliveryManagement!.toJson();
    }
    if (_playStoreConfig != null) {
      data['play_store_config'] = _playStoreConfig!.toJson();
    }
    if (_appStoreConfig != null) {
      data['play_store_config'] = _appStoreConfig!.toJson();
    }
    if (customerLogin != null) {
      data['customer_login'] = customerLogin!.toJson();
    }
    if (maintenanceMode != null) {
      data['advance_maintenance_mode'] = maintenanceMode!.toJson();
    }
    if (forgetPassword != null) {
      data['forgot_password'] = forgetPassword!.toJson();
    }
    data['footer_text'] = _footerCopyright;
    data['faq'] = _faq;
    data['socialLogin'] = _socialLoginStatus;
    data['loyalty_point_item_purchase_point'] = _loyaltyPointItemPurchasePoint;
    data['loyalty_point_exchange_rate'] = _loyaltyPointExchangeRate;
    data['loyalty_point_minimum_point'] = _loyaltyPointMinimumPoint;
    data['ref_earning_status'] = _referEarningStatus;
    data['wallet_status'] = _walletStatus;
    data['customer_verification'] = _customerVerification?.toJson();
    if (_whatsapp != null) {
      data['whatsapp'] = _whatsapp!.toJson();
    }
    if (_cookiesManagement != null) {
      data['cookies_management'] = _cookiesManagement!.toJson();
    }
    data['product_vat_tax_status'] = _isVatTexInclude;
    data['otp_resend_time'] = _otpResendTime;
    data['google_map_status'] = googleMapStatus;
    return data;
  }
}

class EcommerceLocationCoverage {
  String? _longitude;
  String? _latitude;
  double? _coverage;

  EcommerceLocationCoverage({String? longitude, String? latitude, double? coverage}) {
    _longitude = longitude;
    _latitude = latitude;
    _coverage = coverage;
  }

  String? get longitude => _longitude;
  String? get latitude => _latitude;
  double? get coverage => _coverage;

  EcommerceLocationCoverage.fromJson(Map<String, dynamic> json) {
    _longitude = json['longitude'];
    _latitude = json['latitude'];
    _coverage = json['coverage'].toDouble();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['longitude'] = _longitude;
    data['latitude'] = _latitude;
    data['coverage'] = _coverage;
    return data;
  }
}

class PlayStoreConfig{
  bool? _status;
  String? _link;
  double? _minVersion;

  PlayStoreConfig({bool? status, String? link, double? minVersion}){
    _status = status;
    _link = link;
    _minVersion = minVersion;
  }
  bool? get status => _status;
  String? get link => _link;
  double? get minVersion =>_minVersion;

  PlayStoreConfig.fromJson(Map<String, dynamic> json) {
    _status = json['status'];
    if(json['link']!=null){
      _link = json['link'];
    }
    if(json['min_version']!=null && json['min_version']!='' ){
      _minVersion = double.parse(json['min_version'].toString());
    }else{
      _minVersion = 0;
    }
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = _status;
    data['link'] = _link;
    data['min_version'] = _minVersion;

    return data;
  }
}

class AppStoreConfig{
  bool? _status;
  String? _link;
  double? _minVersion;

  AppStoreConfig({bool? status, String? link, double? minVersion}){
    _status = status;
    _link = link;
    _minVersion = minVersion;
  }

  bool? get status => _status;
  String? get link => _link;
  double? get minVersion =>_minVersion;


  AppStoreConfig.fromJson(Map<String, dynamic> json) {
    _status = json['status'];
    if(json['link']!=null){
      _link = json['link'];
    }
    if(json['min_version'] !=null  && json['min_version']!=''){
      _minVersion = double.parse(json['min_version'].toString());
    }else{
      _minVersion = 0;
    }

  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = _status;
    data['link'] = _link;
    data['min_version'] = _minVersion;

    return data;
  }
}

class BaseUrls {
  String? productImageUrl;
  String? customerImageUrl;
  String? bannerImageUrl;
  String? categoryImageUrl;
  String? reviewImageUrl;
  String? notificationImageUrl;
  String? ecommerceImageUrl;
  String? deliveryManImageUrl;
  String? chatImageUrl;
  String? categoryBanner;
  String? flashSaleImageUrl;
  String? getWayImageUrl;
  String? orderImageUrl;

  BaseUrls({
    this.productImageUrl,
    this.customerImageUrl,
    this.bannerImageUrl,
    this.categoryImageUrl,
    this.reviewImageUrl,
    this.notificationImageUrl,
    this.ecommerceImageUrl,
    this.deliveryManImageUrl,
    this.chatImageUrl,
    this.categoryBanner,
    this.flashSaleImageUrl,
    this.getWayImageUrl,
    this.orderImageUrl,
  });

  factory BaseUrls.fromJson(Map<String, dynamic> json) {
    return BaseUrls(
      productImageUrl: json['product_image_url'],
      customerImageUrl: json['customer_image_url'],
      bannerImageUrl: json['banner_image_url'],
      categoryImageUrl: json['category_image_url'],
      reviewImageUrl: json['review_image_url'],
      notificationImageUrl: json['notification_image_url'],
      ecommerceImageUrl: json['ecommerce_image_url'],
      deliveryManImageUrl: json['delivery_man_image_url'],
      chatImageUrl: json['chat_image_url'],
      categoryBanner: json['category_banner_image_url'],
      flashSaleImageUrl: json['flash_sale_image_url'],
      getWayImageUrl: json['gateway_image_url'],
      orderImageUrl: json['order_image_url'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'product_image_url': productImageUrl,
      'customer_image_url': customerImageUrl,
      'banner_image_url': bannerImageUrl,
      'category_image_url': categoryImageUrl,
      'review_image_url': reviewImageUrl,
      'notification_image_url': notificationImageUrl,
      'ecommerce_image_url': ecommerceImageUrl,
      'delivery_man_image_url': deliveryManImageUrl,
      'chat_image_url': chatImageUrl,
      'category_banner_image_url': categoryBanner,
      'flash_sale_image_url': flashSaleImageUrl,
      'gateway_image_url': getWayImageUrl,
      'order_image_url': orderImageUrl,
    };
  }
}

class SocialMediaLink{
  int? _id;
  String? _name;
  String? _link;
  int? _status;
  String? _createdAt;
  String? _updatedAt;

  SocialMediaLink({int? id, String? name, String? link, int? status, String? createdAt, String? updatedAt}){
    _id = id;
    _name = name;
    _link = link;
    _status = status;
    _createdAt = createdAt;
    _updatedAt = updatedAt;
  }
  int? get id => _id;
  String? get name => _name;
  String? get link => _link;
  int? get status => _status;
  String? get createdAt => _createdAt;
  String? get updatedAt => _updatedAt;

  SocialMediaLink.fromJson(Map<String, dynamic> json) {
    _id = json['id'];
    _name = json['name'];
    _link = json['link'];
    _status = json['status'];
    _createdAt = json['created_at'];
    _updatedAt = json['updated_at'];

  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = _id;
    data['name'] = _name;
    data['link'] = _link;
    data['status'] = _status;
    data['created_at'] = _createdAt;
    data['updated_at'] = _updatedAt;
    return data;
  }

}

class Branches {
  int? _id;
  String? _name;
  String? _email;
  String? _longitude;
  String? _latitude;
  String? _address;
  double? _coverage;

  Branches(
      {int? id,
        String? name,
        String? email,
        String? longitude,
        String? latitude,
        String? address,
        double? coverage}) {
    _id = id;
    _name = name;
    _email = email;
    _longitude = longitude;
    _latitude = latitude;
    _address = address;
    _coverage = coverage;
  }

  int? get id => _id;
  String? get name => _name;
  String? get email => _email;
  String? get longitude => _longitude;
  String? get latitude => _latitude;
  String? get address => _address;
  double? get coverage => _coverage;

  Branches.fromJson(Map<String, dynamic> json) {
    _id = json['id'];
    _name = json['name'];
    _email = json['email'];
    _longitude = json['longitude'];
    _latitude = json['latitude'];
    _address = json['address'];
    _coverage = json['coverage'].toDouble();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = _id;
    data['name'] = _name;
    data['email'] = _email;
    data['longitude'] = _longitude;
    data['latitude'] = _latitude;
    data['address'] = _address;
    data['coverage'] = _coverage;
    return data;
  }
}

class DeliveryManagement {
  bool? _status;
  double? _minShippingCharge;
  double? _shippingPerKm;

  DeliveryManagement(
      {bool? status, double? minShippingCharge, double? shippingPerKm}) {
    _status = status;
    _minShippingCharge = minShippingCharge;
    _shippingPerKm = shippingPerKm;
  }

  bool? get status => _status;
  double? get minShippingCharge => _minShippingCharge;
  double? get shippingPerKm => _shippingPerKm;

  DeliveryManagement.fromJson(Map<String, dynamic> json) {
    _status = '${json['status']}'.contains('1');
    _minShippingCharge = json['min_shipping_charge'].toDouble();
    _shippingPerKm = json['shipping_per_km'].toDouble();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = _status;
    data['min_shipping_charge'] = _minShippingCharge;
    data['shipping_per_km'] = _shippingPerKm;
    return data;
  }
}

class SocialStatus{
  bool? isGoogle;
  bool? isFacebook;

  SocialStatus(this.isGoogle, this.isFacebook);

 SocialStatus.fromJson(Map<String, dynamic> json){
   isGoogle = '${json['google']}' == '1';
   isFacebook = '${json['facebook']}' == '1';
 }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['google'] = isGoogle;
    data['facebook'] = isFacebook;
    return data;
  }
}

class Whatsapp {
  bool? status;
  String? number;

  Whatsapp({this.status, this.number});

  Whatsapp.fromJson(Map<String, dynamic> json) {
    status = '${json['status']}'.contains('1');
    number = json['number'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['number'] = number;
    return data;
  }
}

class Telegram {
  bool? status;
  String? userName;

  Telegram({this.status, this.userName});

  Telegram.fromJson(Map<String, dynamic> json) {
    status = '${json['status']}'.contains('1');
    userName = json['user_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['user_name'] = userName;
    return data;
  }
}

class Messenger {
  bool? status;
  String? userName;

  Messenger({this.status, this.userName});

  Messenger.fromJson(Map<String, dynamic> json) {
    status = '${json['status']}'.contains('1');
    userName = json['user_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['user_name'] = userName;
    return data;
  }
}


class CookiesManagement {
  bool? status;
  String? content;

  CookiesManagement({this.status, this.content});

  CookiesManagement.fromJson(Map<String, dynamic> json) {
    status = '${json['status']}'.contains('1');
    content = json['text'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['text'] = content;
    return data;
  }
}

class PaymentMethod {
  String? getWay;
  String? getWayTitle;
  String? getWayImage;
  String? type;

  PaymentMethod({this.getWay, this.getWayTitle, this.getWayImage, this.type});

  PaymentMethod copyWith(String type){
    this.type = type;
    return this;
  }

  PaymentMethod.fromJson(Map<String, dynamic> json) {
    getWay = json['gateway'];
    getWayTitle = json['gateway_title'];
    getWayImage = json['gateway_image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['gateway'] = getWay;
    data['gateway_title'] = getWayTitle;
    data['gateway_image'] = getWayImage;
    return data;
  }
}

class AppleLogin {
  bool? status;
  String? medium;
  String? clientId;

  AppleLogin({this.status, this.medium});

  AppleLogin.fromJson(Map<String, dynamic> json) {
    status = '${json['status']}' == '1';
    medium = json['login_medium'];
    clientId = json['client_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['login_medium'] = medium;
    data['client_id'] = clientId;

    return data;
  }
}

class CustomerVerification{
  bool? status;
  bool? phone;
  bool? email;
  bool? firebase;

  CustomerVerification(this.status, this.phone, this.email, this.firebase);

  CustomerVerification.fromJson(Map<String, dynamic> json) {
    status = '${json['status']}' == '1';
    phone = '${json['phone']}' == '1';
    email = '${json['email']}' == '1';
    firebase = '${json['firebase']}' == '1';
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['phone'] = phone;
    data['email'] = email;
    data['firebase'] = firebase;

    return data;
  }
}

class CustomerLogin {
  LoginOption? loginOption;
  SocialMediaLoginOptions? socialMediaLoginOptions;

  CustomerLogin({this.loginOption, this.socialMediaLoginOptions});

  CustomerLogin.fromJson(Map<String, dynamic> json) {
    loginOption = json['login_option'] != null
        ? LoginOption.fromJson(json['login_option'])
        : null;
    socialMediaLoginOptions = json['social_media_login_options'] != null
        ? SocialMediaLoginOptions.fromJson(
        json['social_media_login_options'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (loginOption != null) {
      data['login_option'] = loginOption!.toJson();
    }
    if (socialMediaLoginOptions != null) {
      data['social_media_login_options'] =
          socialMediaLoginOptions!.toJson();
    }
    return data;
  }
}

class LoginOption {
  int? manualLogin;
  int? otpLogin;
  int? socialMediaLogin;

  LoginOption({this.manualLogin, this.otpLogin, this.socialMediaLogin});

  LoginOption.fromJson(Map<String, dynamic> json) {
    manualLogin = json['manual_login'];
    otpLogin = json['otp_login'];
    socialMediaLogin = json['social_media_login'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['manual_login'] = manualLogin;
    data['otp_login'] = otpLogin;
    data['social_media_login'] = socialMediaLogin;
    return data;
  }
}

class SocialMediaLoginOptions {
  bool? google;
  bool? facebook;
  bool? apple;

  SocialMediaLoginOptions({this.google, this.facebook, this.apple});

  SocialMediaLoginOptions.fromJson(Map<String, dynamic> json) {
    google = '${json['google']}'.contains('1');
    facebook = '${json['facebook']}'.contains('1');
    apple = '${json['apple']}'.contains('1');
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['google'] = google;
    data['facebook'] = facebook;
    data['apple'] = apple;
    return data;
  }
}

class MaintenanceMode {
  bool? maintenanceStatus;
  SelectedMaintenanceSystem? selectedMaintenanceSystem;
  MaintenanceMessages? maintenanceMessages;
  MaintenanceTypeAndDuration? maintenanceTypeAndDuration;

  MaintenanceMode(
      {this.maintenanceStatus,
        this.selectedMaintenanceSystem,
        this.maintenanceMessages, this.maintenanceTypeAndDuration});

  MaintenanceMode.fromJson(Map<String, dynamic> json) {
    maintenanceStatus = '${json['maintenance_status']}'.contains('1');
    selectedMaintenanceSystem = json['selected_maintenance_system'] != null
        ? SelectedMaintenanceSystem.fromJson(
        json['selected_maintenance_system'])
        : null;
    maintenanceMessages = json['maintenance_messages'] != null
        ? MaintenanceMessages.fromJson(json['maintenance_messages'])
        : null;

    maintenanceTypeAndDuration = json['maintenance_type_and_duration'] != null
        ? MaintenanceTypeAndDuration.fromJson(
        json['maintenance_type_and_duration'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['maintenance_status'] = maintenanceStatus;
    if (selectedMaintenanceSystem != null) {
      data['selected_maintenance_system'] =
          selectedMaintenanceSystem!.toJson();
    }
    if (maintenanceMessages != null) {
      data['maintenance_messages'] = maintenanceMessages!.toJson();
    }
    if (maintenanceTypeAndDuration != null) {
      data['maintenance_type_and_duration'] =
          maintenanceTypeAndDuration!.toJson();
    }
    return data;
  }
}

class SelectedMaintenanceSystem {
  bool? customerApp;
  bool? webApp;

  SelectedMaintenanceSystem(
      {this.customerApp, this.webApp});

  SelectedMaintenanceSystem.fromJson(Map<String, dynamic> json) {
    customerApp = '${json['customer_app']}'.contains('1');
    webApp = '${json['web_app']}'.contains('1');
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['customer_app'] = customerApp;
    data['web_app'] = webApp;
    return data;
  }
}

class MaintenanceMessages {
  bool? businessNumber;
  bool? businessEmail;
  String? maintenanceMessage;
  String? messageBody;

  MaintenanceMessages(
      {this.businessNumber,
        this.businessEmail,
        this.maintenanceMessage,
        this.messageBody});

  MaintenanceMessages.fromJson(Map<String, dynamic> json) {
    businessNumber = '${json['business_number']}'.contains('1');
    businessEmail = '${json['business_email']}'.contains('1');
    maintenanceMessage = json['maintenance_message'];
    messageBody = json['message_body'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['business_number'] = businessNumber;
    data['business_email'] = businessEmail;
    data['maintenance_message'] = maintenanceMessage;
    data['message_body'] = messageBody;
    return data;
  }
}

class MaintenanceTypeAndDuration {
  String? _maintenanceDuration;
  String? _startDate;
  String? _endDate;

  MaintenanceTypeAndDuration(
      {String? maintenanceDuration, String? startDate, String? endDate}) {
    if (maintenanceDuration != null) {
      _maintenanceDuration = maintenanceDuration;
    }
    if (startDate != null) {
      _startDate = startDate;
    }
    if (endDate != null) {
      _endDate = endDate;
    }
  }

  String? get maintenanceDuration => _maintenanceDuration;
  set maintenanceDuration(String? maintenanceDuration) =>
      _maintenanceDuration = maintenanceDuration;
  String? get startDate => _startDate;
  set startDate(String? startDate) => _startDate = startDate;
  String? get endDate => _endDate;
  set endDate(String? endDate) => _endDate = endDate;

  MaintenanceTypeAndDuration.fromJson(Map<String, dynamic> json) {
    _maintenanceDuration = json['maintenance_duration'];
    _startDate = json['start_date'];
    _endDate = json['end_date'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['maintenance_duration'] = _maintenanceDuration;
    data['start_date'] = _startDate;
    data['end_date'] = _endDate;
    return data;
  }
}

class ForgetPassword {
  int? _firebase;
  int? _phone;
  int? _email;

  ForgetPassword({int? firebase, int? phone, int? email}) {
    if (firebase != null) {
      _firebase = firebase;
    }
    if (phone != null) {
      _phone = phone;
    }
    if (email != null) {
      _email = email;
    }
  }

  int? get firebase => _firebase;
  set firebase(int? firebase) => _firebase = firebase;
  int? get phone => _phone;
  set phone(int? phone) => _phone = phone;
  int? get email => _email;
  set email(int? email) => _email = email;

  ForgetPassword.fromJson(Map<String, dynamic> json) {
    _firebase = json['firebase'];
    _phone = json['phone'];
    _email = json['email'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['firebase'] = _firebase;
    data['phone'] = _phone;
    data['email'] = _email;
    return data;
  }
}