
import 'package:flutter/material.dart';
import 'package:flutter_grocery/common/models/api_response_model.dart';
import 'package:flutter_grocery/features/chat/domain/models/chat_model.dart';
import 'package:flutter_grocery/features/chat/domain/reposotories/chat_repo.dart';
import 'package:flutter_grocery/features/order/domain/models/order_model.dart';
import 'package:flutter_grocery/helper/api_checker_helper.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

import '../../notification/domain/reposotories/notification_repo.dart';

class ChatProvider extends ChangeNotifier {
  final ChatRepo? chatRepo;
  final NotificationRepo? notificationRepo;
  ChatProvider({required this.chatRepo, required this.notificationRepo});

  List<XFile>? _imageFiles;
  bool _isSendButtonActive = false;
  bool _isLoading= false;
  List<Messages>?  _messageList = [];
  List <XFile>?_chatImage = [];

  bool get isLoading => _isLoading;
  List<XFile>? get imageFiles => _imageFiles;
  bool get isSendButtonActive => _isSendButtonActive;
  List<Messages>? get messageList => _messageList;
  List<XFile>? get chatImage => _chatImage;

  Future<void> getDeliveryManMessages (int orderId) async {
    ApiResponseModel apiResponse = await chatRepo!.getDeliveryManMessage(orderId,1);
    if (apiResponse.response?.data['messages'] != {} && apiResponse.response?.statusCode == 200) {
      _messageList = [];
      _messageList?.addAll(ChatModel.fromJson(apiResponse.response!.data).messages!);
    } else {
      ApiCheckerHelper.checkApi(apiResponse);
    }
    notifyListeners();
  }

  Future<void> getMessages (int offset, OrderModel? orderModel, bool isFirst) async {
    ApiResponseModel apiResponse;

    if(isFirst) {
      _messageList = null;
    }

    if(orderModel == null) {
      apiResponse = await chatRepo!.getAdminMessage(1);

    }else {
     apiResponse = await chatRepo!.getDeliveryManMessage(orderModel.id, 1);

    }

    if (apiResponse.response?.data['messages'] != {} && apiResponse.response?.statusCode == 200) {
      _messageList = [];
      _messageList?.addAll(ChatModel.fromJson(apiResponse.response?.data).messages!);

    } else {
      ApiCheckerHelper.checkApi(apiResponse);

    }
    notifyListeners();
  }


  void onPickImage(bool isRemove) async {
    if(isRemove) {
      _imageFiles = [];
      _chatImage = [];
    }else {
      _imageFiles = await ImagePicker().pickMultiImage(imageQuality: 40);
      if (_imageFiles != null) {
        _chatImage = imageFiles;
        _isSendButtonActive = true;
      }
    }
    notifyListeners();
  }
  void removeImage(int index){
    chatImage!.removeAt(index);
    notifyListeners();
  }

  Future<http.StreamedResponse> sendMessageToDeliveryMan(String message, List<XFile> file, int orderId, BuildContext context, String token) async {
    _isLoading = true;
    http.StreamedResponse response = await chatRepo!.sendMessageToDeliveryMan(message, file, orderId, token);

    if (response.statusCode == 200) {
      file =[];
      getDeliveryManMessages(orderId);
      _isLoading = false;

    }

    _imageFiles = [];
    _chatImage = [];
    _isSendButtonActive = false;
    _isLoading = false;

    notifyListeners();

    return response;
  }

  Future<http.StreamedResponse> sendMessage(String message, BuildContext context, String token, OrderModel? order) async {
    http.StreamedResponse response;
    _isLoading = true;
    if(order == null) {
      response = await chatRepo!.sendMessageToAdmin(message, _chatImage!, token);

    }else {
      response = await chatRepo!.sendMessageToDeliveryMan(message, _chatImage!, order.id, token);
    }
    if (response.statusCode == 200) {
      getMessages(1, order, false);
      _isLoading = false;

    }

    _imageFiles = [];
    _chatImage = [];
    _isSendButtonActive = false;
    _isLoading = false;

    notifyListeners();

    return response;
  }

  void onChangeSendButtonActivity() {
    _isSendButtonActive = !_isSendButtonActive;
    notifyListeners();
  }

  void setImageList(List<XFile> images) {
    _imageFiles = [];
    _imageFiles = images;
    _isSendButtonActive = true;

    notifyListeners();
  }


}