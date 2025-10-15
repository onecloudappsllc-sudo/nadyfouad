class DeliveryInfoModel {
  int? _id;
  String? _name;
  int? _status;
  DeliveryChargeSetup? _deliveryChargeSetup;
  List<DeliveryChargeByArea>? _deliveryChargeByArea;
  bool? _deliveryWeightSettingsStatus;
  String? _deliveryWeightChargeType;
  String? _deliveryCountChargeFrom;
  String? _deliveryAdditionalChargePerUnit;
  String? _deliveryCountChargeFromOperation;
  List<DeliveryWeightRange>? _deliveryWeightRange;

  DeliveryInfoModel(
      {int? id,
        String? name,
        int? status,
        DeliveryChargeSetup? deliveryChargeSetup,
        bool? deliveryWeightSettingsStatus,
        String? deliveryWeightChargeType,
        String? deliveryCountChargeFrom,
        String? deliveryAdditionalChargePerUnit,
        String? deliveryCountChargeFromOperation,
        List<DeliveryWeightRange>? deliveryWeightRange,
        List<DeliveryChargeByArea>? deliveryChargeByArea}) {
    if (id != null) {
      _id = id;
    }
    if (name != null) {
      _name = name;
    }
    if (status != null) {
      _status = status;
    }
    if (deliveryChargeSetup != null) {
      _deliveryChargeSetup = deliveryChargeSetup;
    }
    if (deliveryChargeByArea != null) {
      _deliveryChargeByArea = deliveryChargeByArea;
    }
    if (deliveryWeightSettingsStatus != null) {
      _deliveryWeightSettingsStatus = deliveryWeightSettingsStatus;
    }
    if (deliveryWeightChargeType != null) {
      _deliveryWeightChargeType = deliveryWeightChargeType;
    }
    if (deliveryCountChargeFrom != null) {
      _deliveryCountChargeFrom = deliveryCountChargeFrom;
    }
    if (deliveryAdditionalChargePerUnit != null) {
      _deliveryAdditionalChargePerUnit = deliveryAdditionalChargePerUnit;
    }
    if (deliveryCountChargeFromOperation != null) {
      _deliveryCountChargeFromOperation = deliveryCountChargeFromOperation;
    }
    if (deliveryWeightRange != null) {
      _deliveryWeightRange = deliveryWeightRange;
    }
  }

  int? get id => _id;
  set id(int? id) => _id = id;
  String? get name => _name;
  set name(String? name) => _name = name;
  int? get status => _status;
  set status(int? status) => _status = status;
  DeliveryChargeSetup? get deliveryChargeSetup => _deliveryChargeSetup;
  set deliveryChargeSetup(DeliveryChargeSetup? deliveryChargeSetup) =>
      _deliveryChargeSetup = deliveryChargeSetup;
  List<DeliveryChargeByArea>? get deliveryChargeByArea => _deliveryChargeByArea;
  set deliveryChargeByArea(List<DeliveryChargeByArea>? deliveryChargeByArea) =>
      _deliveryChargeByArea = deliveryChargeByArea;
  bool? get deliveryWeightSettingsStatus => _deliveryWeightSettingsStatus;
  set deliveryWeightSettingsStatus(bool? deliveryWeightSettingsStatus) =>
      _deliveryWeightSettingsStatus = deliveryWeightSettingsStatus;
  String? get deliveryWeightChargeType => _deliveryWeightChargeType;
  set deliveryWeightChargeType(String? deliveryWeightChargeType) =>
      _deliveryWeightChargeType = deliveryWeightChargeType;
  String? get deliveryCountChargeFrom => _deliveryCountChargeFrom;
  set deliveryCountChargeFrom(String? deliveryCountChargeFrom) =>
      _deliveryCountChargeFrom = deliveryCountChargeFrom;
  String? get deliveryAdditionalChargePerUnit =>
      _deliveryAdditionalChargePerUnit;
  set deliveryAdditionalChargePerUnit(
      String? deliveryAdditionalChargePerUnit) =>
      _deliveryAdditionalChargePerUnit = deliveryAdditionalChargePerUnit;
  String? get deliveryCountChargeFromOperation =>
      _deliveryCountChargeFromOperation;
  set deliveryCountChargeFromOperation(
      String? deliveryCountChargeFromOperation) =>
      _deliveryCountChargeFromOperation = deliveryCountChargeFromOperation;
  List<DeliveryWeightRange>? get deliveryWeightRange => _deliveryWeightRange;
  set deliveryWeightRange(List<DeliveryWeightRange>? deliveryWeightRange) =>
      _deliveryWeightRange = deliveryWeightRange;

  DeliveryInfoModel.fromJson(Map<String, dynamic> json) {
    _id = json['id'];
    _name = json['name'];
    _status = json['status'];
    _deliveryChargeSetup = json['delivery_charge_setup'] != null
        ? DeliveryChargeSetup.fromJson(json['delivery_charge_setup'])
        : null;
    if (json['delivery_charge_by_area'] != null) {
      _deliveryChargeByArea = <DeliveryChargeByArea>[];
      json['delivery_charge_by_area'].forEach((v) {
        _deliveryChargeByArea!.add(DeliveryChargeByArea.fromJson(v));
      });
    }
    _deliveryWeightSettingsStatus = "${json['delivery_weight_settings_status']}" == '1';
    _deliveryWeightChargeType = json['delivery_weight_charge_type'];
    _deliveryCountChargeFrom = json['delivery_count_charge_from'];
    _deliveryAdditionalChargePerUnit =
    json['delivery_additional_charge_per_unit'];
    _deliveryCountChargeFromOperation =
    json['delivery_count_charge_from_operation'];
    if (json['delivery_weight_range'] != null) {
      _deliveryWeightRange = <DeliveryWeightRange>[];
      json['delivery_weight_range'].forEach((v) {
        _deliveryWeightRange!.add(DeliveryWeightRange.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = _id;
    data['name'] = _name;
    data['status'] = _status;
    if (_deliveryChargeSetup != null) {
      data['delivery_charge_setup'] = _deliveryChargeSetup!.toJson();
    }
    if (_deliveryChargeByArea != null) {
      data['delivery_charge_by_area'] =
          _deliveryChargeByArea!.map((v) => v.toJson()).toList();
    }
    data['delivery_weight_settings_status'] =
        _deliveryWeightSettingsStatus;
    data['delivery_weight_charge_type'] = _deliveryWeightChargeType;
    data['delivery_count_charge_from'] = _deliveryCountChargeFrom;
    data['delivery_additional_charge_per_unit'] =
        _deliveryAdditionalChargePerUnit;
    data['delivery_count_charge_from_operation'] =
        _deliveryCountChargeFromOperation;
    if (_deliveryWeightRange != null) {
      data['delivery_weight_range'] =
          _deliveryWeightRange!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class DeliveryChargeSetup {
  int? _id;
  int? _branchId;
  String? _deliveryChargeType;
  double? _deliveryChargePerKilometer;
  double? _minimumDeliveryCharge;
  double? _minimumDistanceForFreeDelivery;
  double? _fixedDeliveryCharge;
  String? _createdAt;
  String? _updatedAt;

  DeliveryChargeSetup(
      {int? id,
        int? branchId,
        String? deliveryChargeType,
        double? deliveryChargePerKilometer,
        double? minimumDeliveryCharge,
        double? minimumDistanceForFreeDelivery,
        double? fixedDeliveryCharge,
        String? createdAt,
        String? updatedAt}) {
    if (id != null) {
      _id = id;
    }
    if (branchId != null) {
      _branchId = branchId;
    }
    if (deliveryChargeType != null) {
      _deliveryChargeType = deliveryChargeType;
    }
    if (deliveryChargePerKilometer != null) {
      _deliveryChargePerKilometer = deliveryChargePerKilometer;
    }
    if (minimumDeliveryCharge != null) {
      _minimumDeliveryCharge = minimumDeliveryCharge;
    }
    if (minimumDistanceForFreeDelivery != null) {
      _minimumDistanceForFreeDelivery = minimumDistanceForFreeDelivery;
    }
    if (fixedDeliveryCharge != null) {
      _fixedDeliveryCharge = fixedDeliveryCharge;
    }
    if (createdAt != null) {
      _createdAt = createdAt;
    }
    if (updatedAt != null) {
      _updatedAt = updatedAt;
    }
  }

  int? get id => _id;
  set id(int? id) => _id = id;
  int? get branchId => _branchId;
  set branchId(int? branchId) => _branchId = branchId;
  String? get deliveryChargeType => _deliveryChargeType;
  set deliveryChargeType(String? deliveryChargeType) =>
      _deliveryChargeType = deliveryChargeType;
  double? get deliveryChargePerKilometer => _deliveryChargePerKilometer;
  set deliveryChargePerKilometer(double? deliveryChargePerKilometer) =>
      _deliveryChargePerKilometer = deliveryChargePerKilometer;
  double? get minimumDeliveryCharge => _minimumDeliveryCharge;
  set minimumDeliveryCharge(double? minimumDeliveryCharge) =>
      _minimumDeliveryCharge = minimumDeliveryCharge;
  double? get minimumDistanceForFreeDelivery => _minimumDistanceForFreeDelivery;
  set minimumDistanceForFreeDelivery(double? minimumDistanceForFreeDelivery) =>
      _minimumDistanceForFreeDelivery = minimumDistanceForFreeDelivery;
  double? get fixedDeliveryCharge => _fixedDeliveryCharge;
  set fixedDeliveryCharge(double? fixedDeliveryCharge) =>
      _fixedDeliveryCharge = fixedDeliveryCharge;
  String? get createdAt => _createdAt;
  set createdAt(String? createdAt) => _createdAt = createdAt;
  String? get updatedAt => _updatedAt;
  set updatedAt(String? updatedAt) => _updatedAt = updatedAt;

  DeliveryChargeSetup.fromJson(Map<String, dynamic> json) {
    _id = json['id'];
    _branchId = json['branch_id'];
    _deliveryChargeType = json['delivery_charge_type'];
    _deliveryChargePerKilometer = double.tryParse(json['delivery_charge_per_kilometer'].toString());
    _minimumDeliveryCharge = double.tryParse(json['minimum_delivery_charge'].toString());
    _minimumDistanceForFreeDelivery = double.tryParse(json['minimum_distance_for_free_delivery'].toString());
    _fixedDeliveryCharge = double.tryParse(json['fixed_delivery_charge'].toString());
    _createdAt = json['created_at'];
    _updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = _id;
    data['branch_id'] = _branchId;
    data['delivery_charge_type'] = _deliveryChargeType;
    data['delivery_charge_per_kilometer'] = _deliveryChargePerKilometer;
    data['minimum_delivery_charge'] = _minimumDeliveryCharge;
    data['minimum_distance_for_free_delivery'] =
        _minimumDistanceForFreeDelivery;
    data['fixed_delivery_charge'] = _fixedDeliveryCharge;
    data['created_at'] = _createdAt;
    data['updated_at'] = _updatedAt;
    return data;
  }
}

class DeliveryChargeByArea {
  int? _id;
  int? _branchId;
  String? _areaName;
  double? _deliveryCharge;
  String? _createdAt;
  String? _updatedAt;

  DeliveryChargeByArea(
      {int? id,
        int? branchId,
        String? areaName,
        double? deliveryCharge,
        String? createdAt,
        String? updatedAt}) {
    if (id != null) {
      _id = id;
    }
    if (branchId != null) {
      _branchId = branchId;
    }
    if (areaName != null) {
      _areaName = areaName;
    }
    if (deliveryCharge != null) {
      _deliveryCharge = deliveryCharge;
    }
    if (createdAt != null) {
      _createdAt = createdAt;
    }
    if (updatedAt != null) {
      _updatedAt = updatedAt;
    }
  }

  int? get id => _id;
  set id(int? id) => _id = id;
  int? get branchId => _branchId;
  set branchId(int? branchId) => _branchId = branchId;
  String? get areaName => _areaName;
  set areaName(String? areaName) => _areaName = areaName;
  double? get deliveryCharge => _deliveryCharge;
  set deliveryCharge(double? deliveryCharge) => _deliveryCharge = deliveryCharge;
  String? get createdAt => _createdAt;
  set createdAt(String? createdAt) => _createdAt = createdAt;
  String? get updatedAt => _updatedAt;
  set updatedAt(String? updatedAt) => _updatedAt = updatedAt;

  DeliveryChargeByArea.fromJson(Map<String, dynamic> json) {
    _id = json['id'];
    _branchId = json['branch_id'];
    _areaName = json['area_name'];
    _deliveryCharge = double.tryParse(json['delivery_charge'].toString());
    _createdAt = json['created_at'];
    _updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = _id;
    data['branch_id'] = _branchId;
    data['area_name'] = _areaName;
    data['delivery_charge'] = _deliveryCharge;
    data['created_at'] = _createdAt;
    data['updated_at'] = _updatedAt;
    return data;
  }
}

class DeliveryWeightRange {
  String? _minWeight;
  String? _minOperation;
  String? _maxWeight;
  String? _maxOperation;
  String? _deliveryCharge;

  DeliveryWeightRange(
      {String? minWeight,
        String? minOperation,
        String? maxWeight,
        String? maxOperation,
        String? deliveryCharge}) {
    if (minWeight != null) {
      _minWeight = minWeight;
    }
    if (minOperation != null) {
      _minOperation = minOperation;
    }
    if (maxWeight != null) {
      _maxWeight = maxWeight;
    }
    if (maxOperation != null) {
      _maxOperation = maxOperation;
    }
    if (deliveryCharge != null) {
      _deliveryCharge = deliveryCharge;
    }
  }

  String? get minWeight => _minWeight;
  set minWeight(String? minWeight) => _minWeight = minWeight;
  String? get minOperation => _minOperation;
  set minOperation(String? minOperation) => _minOperation = minOperation;
  String? get maxWeight => _maxWeight;
  set maxWeight(String? maxWeight) => _maxWeight = maxWeight;
  String? get maxOperation => _maxOperation;
  set maxOperation(String? maxOperation) => _maxOperation = maxOperation;
  String? get deliveryCharge => _deliveryCharge;
  set deliveryCharge(String? deliveryCharge) =>
      _deliveryCharge = deliveryCharge;

  DeliveryWeightRange.fromJson(Map<String, dynamic> json) {
    _minWeight = json['min_weight'];
    _minOperation = json['min_operation'];
    _maxWeight = json['max_weight'];
    _maxOperation = json['max_operation'];
    _deliveryCharge = json['delivery_charge'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['min_weight'] = _minWeight;
    data['min_operation'] = _minOperation;
    data['max_weight'] = _maxWeight;
    data['max_operation'] = _maxOperation;
    data['delivery_charge'] = _deliveryCharge;
    return data;
  }
}