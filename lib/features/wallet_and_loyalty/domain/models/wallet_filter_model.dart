class WalletFilterModel {
  String? title;
  String? value;

  WalletFilterModel({this.title, this.value});

  WalletFilterModel.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    value = json['value'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['title'] = title;
    data['value'] = value;
    return data;
  }
}