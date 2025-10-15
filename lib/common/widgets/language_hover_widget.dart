import 'package:flutter/material.dart';
import 'package:flutter_grocery/common/models/language_model.dart';
import 'package:flutter_grocery/localization/app_localization.dart';
import 'package:flutter_grocery/common/providers/language_provider.dart';
import 'package:flutter_grocery/common/widgets/text_hover_widget.dart';
import 'package:flutter_grocery/features/home/screens/home_screens.dart';
import 'package:provider/provider.dart';

import '../providers/localization_provider.dart';
import '../../../utill/color_resources.dart';
import '../../../utill/dimensions.dart';
import '../../helper/custom_snackbar_helper.dart';

class LanguageHoverWidget extends StatefulWidget {
  final List<LanguageModel> languageList;
  const LanguageHoverWidget({Key? key, required this.languageList}) : super(key: key);

  @override
  State<LanguageHoverWidget> createState() => _LanguageHoverWidgetState();
}

class _LanguageHoverWidgetState extends State<LanguageHoverWidget> {
  @override
  void initState() {

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<LanguageProvider>(
      builder: (context, languageProvider, child) {
        return Container(
          color: Theme.of(context).cardColor,
          padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeExtraSmall),
          child: Column(
              children: widget.languageList.map((language) => InkWell(
                onTap: () async {
                  if(languageProvider.languages.isNotEmpty && languageProvider.selectIndex != -1) {
                    Provider.of<LocalizationProvider>(context, listen: false).setLanguage(Locale(
                        language.languageCode!, language.countryCode
                    ));
                    HomeScreen.loadData(true, context);
                  }else {
                    showCustomSnackBarHelper('select_a_language'.tr);
                  }

                },
                child: TextHoverWidget(
                    builder: (isHover) {
                      return Container(
                        padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeExtraSmall, horizontal: Dimensions.paddingSizeDefault),
                        decoration: BoxDecoration(color: isHover ? ColorResources.getGreyColor(context) : Theme.of(context).cardColor, borderRadius: BorderRadius.circular(8)),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Image.asset(language.imageUrl!, width: 25, height: 25),
                            const SizedBox(width: Dimensions.paddingSizeExtraSmall),

                            Text(language.languageName!, overflow: TextOverflow.ellipsis, maxLines: 1, style: const TextStyle(fontSize: Dimensions.fontSizeSmall),),
                          ],
                        ),
                      );
                    }
                ),
              )).toList()
            // [
            //   Text(_categoryList[5].name),
            // ],
          ),
        );
      }
    );
  }
}
