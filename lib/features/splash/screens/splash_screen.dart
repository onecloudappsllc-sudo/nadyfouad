import 'dart:async';
import 'dart:io';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_grocery/common/models/config_model.dart';
import 'package:flutter_grocery/helper/custom_snackbar_helper.dart';
import 'package:flutter_grocery/helper/maintenance_helper.dart';
import 'package:flutter_grocery/helper/responsive_helper.dart';
import 'package:flutter_grocery/features/auth/providers/auth_provider.dart';
import 'package:flutter_grocery/common/providers/cart_provider.dart';
import 'package:flutter_grocery/features/splash/providers/splash_provider.dart';
import 'package:flutter_grocery/helper/route_helper.dart';
import 'package:flutter_grocery/localization/language_constraints.dart';
import 'package:flutter_grocery/utill/app_constants.dart';
import 'package:flutter_grocery/utill/dimensions.dart';
import 'package:flutter_grocery/utill/images.dart';
import 'package:flutter_grocery/utill/styles.dart';
import 'package:flutter_grocery/features/onboarding/screens/on_boarding_screen.dart';
import 'package:provider/provider.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  StreamSubscription<List<ConnectivityResult>>? subscription;

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    _checkConnectivity();

    Provider.of<SplashProvider>(context, listen: false).initSharedData();
    Provider.of<CartProvider>(context, listen: false).getCartData();
    _route();
  }

  void _route() {
    final SplashProvider splashProvider = Provider.of<SplashProvider>(context, listen: false);
    // Provider.of<SplashProvider>(context, listen: false).removeSharedData();
    splashProvider.initConfig().then((bool isSuccess) async{
      final ConfigModel? configModel = splashProvider.configModel;
      if (isSuccess) {

        await splashProvider.getDeliveryInfo();
        splashProvider.initializeScreenList(context);

        Timer(const Duration(seconds: 1), () async {
          double minimumVersion = 0.0;
          if(Platform.isAndroid) {
            if(splashProvider.configModel?.playStoreConfig?.minVersion != null){
              minimumVersion = splashProvider.configModel?.playStoreConfig?.minVersion ?? AppConstants.appVersion;

            }

          }else if(Platform.isIOS) {
            if(splashProvider.configModel?.appStoreConfig?.minVersion != null){
              minimumVersion = splashProvider.configModel?.appStoreConfig?.minVersion ?? AppConstants.appVersion;
            }
          }
          if(AppConstants.appVersion < minimumVersion && !ResponsiveHelper.isWeb()) {
            Navigator.pushNamedAndRemoveUntil(context, RouteHelper.getUpdateRoute(), (route) => false);
          }
          else{
            if(MaintenanceHelper.isMaintenanceModeEnable(configModel) && MaintenanceHelper.isCustomerMaintenanceEnable(configModel)){
              if (mounted) {
                Navigator.pushNamedAndRemoveUntil(context, RouteHelper.getMainRoute(), (route) => false);
              } else {
                print('Widget is not mounted; cannot navigate.');
              }
              //Navigator.pushNamedAndRemoveUntil(context, RouteHelper.getMainRoute(), (route) => false);
            }
            else if (Provider.of<AuthProvider>(context, listen: false).isLoggedIn()) {
              Provider.of<AuthProvider>(context, listen: false).updateToken();
              Navigator.of(context).pushNamedAndRemoveUntil(RouteHelper.menu, (route) => false);

            } else {
              if(Provider.of<SplashProvider>(context, listen: false).showIntro()) {
                Navigator.pushNamedAndRemoveUntil(context, RouteHelper.onBoarding, (route) => false, arguments: OnBoardingScreen());

              }else {
                Navigator.of(context).pushNamedAndRemoveUntil(RouteHelper.menu, (route) => false);
              }
            }
          }
        });
      }
    });
  }

  void _checkConnectivity() {
    bool isFirst = true;
    subscription = Connectivity().onConnectivityChanged.listen((List<ConnectivityResult> result) {
      bool isConnected = result.contains(ConnectivityResult.wifi)  || result.contains(ConnectivityResult.mobile);

      if((isFirst && !isConnected) || !isFirst && context.mounted) {
        showCustomSnackBarHelper(getTranslated(isConnected ?  'connected' : 'no_internet_connection', context), isError: !isConnected);

        if(isConnected && ModalRoute.of(context)?.settings.name == RouteHelper.splash) {
          _route();
        }
      }
      isFirst = false;
    });

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Image.asset(Images.appLogo, height: 130, width: 500),
          const SizedBox(height: Dimensions.paddingSizeSmall),

          Text(AppConstants.appName,
              textAlign: TextAlign.center,
              style: poppinsMedium.copyWith(
                color: Theme.of(context).primaryColor,
                fontSize: 30,
              )),
        ],
      ),
    );
  }
}
