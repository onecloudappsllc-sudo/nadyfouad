import 'package:flutter_grocery/common/models/config_model.dart';
import 'package:flutter_grocery/helper/responsive_helper.dart';

class MaintenanceHelper{

  static bool isMaintenanceModeEnable (ConfigModel? configModel) => configModel?.maintenanceMode?.maintenanceStatus ?? false;

  static bool isCustomerMaintenanceEnable (ConfigModel? configModel) => configModel?.maintenanceMode?.selectedMaintenanceSystem?.customerApp ?? false;

  static bool isWebMaintenanceEnable (ConfigModel? configModel) => configModel?.maintenanceMode?.selectedMaintenanceSystem?.webApp ?? false;

  static bool checkWebMaintenanceMode (ConfigModel? configModel) => (ResponsiveHelper.isWeb()) && isWebMaintenanceEnable(configModel);

  static bool checkCustomerMaintenanceMode (ConfigModel? configModel) => (!ResponsiveHelper.isWeb()) && isCustomerMaintenanceEnable(configModel);

  static bool isCustomizeMaintenance (ConfigModel? configModel) => configModel?.maintenanceMode?.maintenanceTypeAndDuration?.maintenanceDuration == 'customize';

  static bool isMaintenanceMessageEmpty (ConfigModel? configModel) => configModel?.maintenanceMode?.maintenanceMessages?.maintenanceMessage?.isEmpty ?? true;

  static bool isMaintenanceBodyEmpty (ConfigModel? configModel) => configModel?.maintenanceMode?.maintenanceMessages?.messageBody?.isEmpty ?? true;

  static bool isShowBusinessNumber (ConfigModel? configModel) => configModel?.maintenanceMode?.maintenanceMessages?.businessNumber ?? false;

  static bool isShowBusinessEmail (ConfigModel? configModel) => configModel?.maintenanceMode?.maintenanceMessages?.businessEmail ?? false;

}