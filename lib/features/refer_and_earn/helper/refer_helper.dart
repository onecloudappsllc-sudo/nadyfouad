import 'package:flutter_grocery/features/splash/providers/splash_provider.dart';
import 'package:flutter_grocery/main.dart';
import 'package:provider/provider.dart';


class ReferHelper {
  static String getSignUpLink(String referCode) {
    final SplashProvider splashProvider = Provider.of<SplashProvider>(Get.context!, listen: false);
    return 'Greetings,\nGroFresh is the best grocery platform in the country. If you are new to this website don\'t forget to use "$referCode" as the referral code while sign up into GroFresh. '
        '\n\n${splashProvider.configModel?.playStoreConfig?.link}';
  }

}