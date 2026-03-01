import 'package:dio/dio.dart';
import 'package:flutter_grocery/features/auth/domain/reposotories/auth_repo.dart';
import 'package:flutter_grocery/features/auth/providers/verification_provider.dart';
import 'package:flutter_grocery/features/home/domain/reposotories/banner_repo.dart';
import 'package:flutter_grocery/common/reposotories/cart_repo.dart';
import 'package:flutter_grocery/features/category/domain/reposotories/category_repo.dart';
import 'package:flutter_grocery/features/chat/domain/reposotories/chat_repo.dart';
import 'package:flutter_grocery/features/coupon/domain/reposotories/coupon_repo.dart';
import 'package:flutter_grocery/common/reposotories/language_repo.dart';
import 'package:flutter_grocery/features/address/domain/reposotories/location_repo.dart';
import 'package:flutter_grocery/features/notification/domain/reposotories/notification_repo.dart';
import 'package:flutter_grocery/features/onboarding/domain/reposotories/onboarding_repo.dart';
import 'package:flutter_grocery/features/order/domain/reposotories/order_repo.dart';
import 'package:flutter_grocery/common/reposotories/product_repo.dart';
import 'package:flutter_grocery/features/order/providers/image_note_provider.dart';
import 'package:flutter_grocery/features/profile/domain/reposotories/profile_repo.dart';
import 'package:flutter_grocery/features/review/providers/review_provider.dart';
import 'package:flutter_grocery/features/search/domain/reposotories/search_repo.dart';
import 'package:flutter_grocery/features/splash/domain/reposotories/splash_repo.dart';
import 'package:flutter_grocery/features/wallet_and_loyalty/domain/reposotories/wallet_repo.dart';
import 'package:flutter_grocery/features/wishlist/domain/reposotories/wishlist_repo.dart';
import 'package:flutter_grocery/features/auth/providers/auth_provider.dart';
import 'package:flutter_grocery/features/home/providers/banner_provider.dart';
import 'package:flutter_grocery/common/providers/cart_provider.dart';
import 'package:flutter_grocery/features/category/providers/category_provider.dart';
import 'package:flutter_grocery/features/chat/providers/chat_provider.dart';
import 'package:flutter_grocery/features/coupon/providers/coupon_provider.dart';
import 'package:flutter_grocery/features/home/providers/flash_deal_provider.dart';
import 'package:flutter_grocery/common/providers/language_provider.dart';
import 'package:flutter_grocery/common/providers/localization_provider.dart';
import 'package:flutter_grocery/features/address/providers/location_provider.dart';
import 'package:flutter_grocery/common/providers/news_letter_provider.dart';
import 'package:flutter_grocery/features/notification/providers/notification_provider.dart';
import 'package:flutter_grocery/features/onboarding/providers/onboarding_provider.dart';
import 'package:flutter_grocery/features/order/providers/order_provider.dart';
import 'package:flutter_grocery/common/providers/product_provider.dart';
import 'package:flutter_grocery/features/profile/providers/profile_provider.dart';
import 'package:flutter_grocery/features/search/providers/search_provider.dart';
import 'package:flutter_grocery/features/splash/providers/splash_provider.dart';
import 'package:flutter_grocery/common/providers/theme_provider.dart';
import 'package:flutter_grocery/features/wallet_and_loyalty/providers/wallet_provider.dart';
import 'package:flutter_grocery/features/wishlist/providers/wishlist_provider.dart';
import 'package:flutter_grocery/utill/app_constants.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'data/datasource/remote/dio/dio_client.dart';
import 'data/datasource/remote/dio/logging_interceptor.dart';
import 'common/reposotories/news_letter_repo.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // Core
  sl.registerLazySingleton(() => DioClient(AppConstants.baseUrl, sl(), loggingInterceptor: sl(), sharedPreferences: sl()));

  // Repository
  sl.registerLazySingleton(() => SplashRepo(sharedPreferences: sl(), dioClient: sl()));
  sl.registerLazySingleton(() => OnBoardingRepo(dioClient: sl()));
  sl.registerLazySingleton(() => CategoryRepo(dioClient: sl()));
  sl.registerLazySingleton(() => ProductRepo(dioClient: sl()));
  sl.registerLazySingleton(() => SearchRepo(dioClient: sl(), sharedPreferences: sl()));
  sl.registerLazySingleton(() => ChatRepo(dioClient: sl(),sharedPreferences: sl()));
  sl.registerLazySingleton(() => AuthRepo(dioClient: sl(), sharedPreferences: sl()));
  sl.registerLazySingleton(() => CartRepo(sharedPreferences: sl()));
  sl.registerLazySingleton(() => CouponRepo(dioClient: sl()));
  sl.registerLazySingleton(() => OrderRepo(dioClient: sl()));
  sl.registerLazySingleton(() => LocationRepo(dioClient: sl(), sharedPreferences: sl()));
  sl.registerLazySingleton(() => ProfileRepo(dioClient: sl(), sharedPreferences: sl()));
  sl.registerLazySingleton(() => BannerRepo(dioClient: sl()));
  sl.registerLazySingleton(() => NotificationRepo(dioClient: sl()));
  sl.registerLazySingleton(() => LanguageRepo(dioClient: sl()));
  sl.registerLazySingleton(() => NewsLetterRepo(dioClient: sl()));
  sl.registerLazySingleton(() => WishListRepo(dioClient: sl()));
  sl.registerLazySingleton(() => WalletRepo(dioClient: sl(), sharedPreferences: sl()));

  // Provider
  sl.registerFactory(() => ThemeProvider(sharedPreferences: sl()));
  sl.registerFactory(() => LocalizationProvider(dioClient: sl(), sharedPreferences: sl(), languageRepo: sl()));
  sl.registerFactory(() => SplashProvider(splashRepo: sl()));
  sl.registerFactory(() => OnBoardingProvider(onboardingRepo: sl()));
  sl.registerFactory(() => CategoryProvider(categoryRepo: sl(), productRepo: sl(), searchRepo: sl()));
  sl.registerFactory(() => ProductProvider(productRepo: sl(), searchRepo: sl()));
  sl.registerFactory(() => SearchProvider(searchRepo: sl()));
  sl.registerFactory(() => ChatProvider(chatRepo: sl(),notificationRepo: sl()));
  sl.registerFactory(() => AuthProvider(authRepo: sl()));
  sl.registerFactory(() => CartProvider(cartRepo: sl()));
  sl.registerFactory(() => CouponProvider(couponRepo: sl()));
  sl.registerFactory(() => LocationProvider(locationRepo: sl(),sharedPreferences: sl()));
  sl.registerFactory(() => ProfileProvider(profileRepo: sl()));
  sl.registerFactory(() => OrderProvider(orderRepo: sl(), sharedPreferences: sl()));
  sl.registerFactory(() => BannerProvider(bannerRepo: sl()));
  sl.registerFactory(() => NotificationProvider(notificationRepo: sl()));
  sl.registerFactory(() => LanguageProvider(languageRepo: sl()));
  sl.registerFactory(() => NewsLetterProvider(newsLetterRepo: sl()));
  sl.registerFactory(() => WishListProvider(wishListRepo: sl()));
  sl.registerFactory(() => WalletAndLoyaltyProvider(walletRepo: sl()));
  sl.registerFactory(() => FlashDealProvider(productRepo: sl()));
  sl.registerFactory(() => ReviewProvider(orderRepo: sl()));
  sl.registerFactory(() => VerificationProvider(authRepo: sl()));
  sl.registerFactory(() => OrderImageNoteProvider());


  // External
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);
  sl.registerLazySingleton(() => Dio());
  sl.registerLazySingleton(() => LoggingInterceptor());
}
