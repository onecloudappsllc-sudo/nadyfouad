import 'package:flutter/material.dart';
import 'package:flutter_grocery/common/enums/footer_type_enum.dart';
import 'package:flutter_grocery/features/notification/widgets/notification_item_widget.dart';
import 'package:flutter_grocery/helper/date_converter_helper.dart';
import 'package:flutter_grocery/helper/responsive_helper.dart';
import 'package:flutter_grocery/localization/language_constraints.dart';
import 'package:flutter_grocery/features/notification/providers/notification_provider.dart';
import 'package:flutter_grocery/common/widgets/custom_app_bar_widget.dart';
import 'package:flutter_grocery/common/widgets/custom_loader_widget.dart';
import 'package:flutter_grocery/common/widgets/footer_web_widget.dart';
import 'package:flutter_grocery/common/widgets/no_data_widget.dart';
import 'package:flutter_grocery/common/widgets/web_app_bar_widget.dart';
import 'package:provider/provider.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({Key? key}) : super(key: key);

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {

  @override
  void initState() {
    Provider.of<NotificationProvider>(context, listen: false).getNotificationList(isUpdate: false);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {


    return Scaffold(
      appBar: (ResponsiveHelper.isDesktop(context)? const PreferredSize(preferredSize: Size.fromHeight(120), child: WebAppBarWidget()): CustomAppBarWidget(title: getTranslated('notification', context))) as PreferredSizeWidget?,
      body: RefreshIndicator(
        onRefresh: () async {
          await Provider.of<NotificationProvider>(context, listen: false).getNotificationList();
        },
        backgroundColor: Theme.of(context).primaryColor,
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(child: Consumer<NotificationProvider>(builder: (context, notificationProvider, child) {
              List<DateTime> dateTimeList = [];

              return notificationProvider.notificationList != null ? notificationProvider.notificationList!.isNotEmpty ? ListView.builder(
                itemCount: notificationProvider.notificationList!.length,
                padding: ResponsiveHelper.isDesktop(context) ? const EdgeInsets.symmetric(horizontal: 350, vertical: 20) :  EdgeInsets.zero,
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  DateTime originalDateTime = DateConverterHelper.isoStringToLocalDate(notificationProvider.notificationList![index].createdAt!);
                  DateTime convertedDate = DateTime(originalDateTime.year, originalDateTime.month, originalDateTime.day);
                  bool addTitle = false;
                  if(!dateTimeList.contains(convertedDate)) {
                    addTitle = true;
                    dateTimeList.add(convertedDate);
                  }
                  return NotificationItemWidget(isTitle: addTitle, notification: notificationProvider.notificationList![index],);
                },
              ) : NoDataWidget(
                title: getTranslated('no_notification_found', context),
              ) : SizedBox(height: MediaQuery.of(context).size.height * 0.6, child: Center(child: CustomLoaderWidget(color: Theme.of(context).primaryColor)));


            })),

            const FooterWebWidget(footerType: FooterType.sliver),

          ],

        ),
      ),
    );
  }
}


