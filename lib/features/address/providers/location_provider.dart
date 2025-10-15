// ignore_for_file: depend_on_referenced_packages

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_grocery/features/address/domain/models/address_model.dart';
import 'package:flutter_grocery/common/models/api_response_model.dart';
import 'package:flutter_grocery/common/models/response_model.dart';
import 'package:flutter_grocery/features/address/domain/models/prediction_model.dart';
import 'package:flutter_grocery/features/address/domain/reposotories/location_repo.dart';
import 'package:flutter_grocery/helper/api_checker_helper.dart';
import 'package:flutter_grocery/utill/app_constants.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:http/http.dart' as http;
class LocationProvider with ChangeNotifier {
  final SharedPreferences? sharedPreferences;
  final LocationRepo locationRepo;

  LocationProvider({required this.sharedPreferences, required this.locationRepo});

  Position _position = Position(
    longitude: 0, latitude: 0, timestamp: DateTime.now(), accuracy: 1,
    altitude: 1, heading: 1, speed: 1, speedAccuracy: 1,
    altitudeAccuracy: 0, headingAccuracy: 0,
  );
  Position _pickPosition = Position(
    longitude: 0, latitude: 0, timestamp: DateTime.now(),
    accuracy: 1, altitude: 1, heading: 1, speed: 1, speedAccuracy: 1,
    altitudeAccuracy: 0, headingAccuracy: 0,
  );

  bool _loading = false;
  String? _address = '';
  String? _pickAddress = '';
  final String _currentAddressText = '';
  final List<Marker> _markers = <Marker>[];
  bool _buttonDisabled = true;
  bool _changeAddress = true;
  List<PredictionModel> _predictionList = [];
  bool _updateAddAddressData = true;
  List<AddressModel>? _addressList;
  List<String> _getAllAddressType = [];
  int _selectAddressIndex = 0;

  String? _pickedAddressLatitude;
  String? _pickedAddressLongitude;



  bool get loading => _loading;
  Position get position => _position;
  Position get pickPosition => _pickPosition;
  String get currentAddressText => _currentAddressText;
  String? get address => _address;
  String? get pickAddress => _pickAddress;
  List<Marker> get markers => _markers;
  bool get buttonDisabled => _buttonDisabled;
  List<AddressModel>? get addressList => _addressList;
  List<String> get getAllAddressType => _getAllAddressType;
  int get selectAddressIndex => _selectAddressIndex;
  String? get pickedAddressLatitude => _pickedAddressLatitude;
  String? get pickedAddressLongitude => _pickedAddressLongitude;

  set setAddress(String? addressValue)=> _address = addressValue;


  setPickedAddressLatLon(String? lat, String? lon, {bool isUpdate = true}){
    _pickedAddressLatitude = lat;
    _pickedAddressLongitude = lon;
    if(isUpdate){
      notifyListeners();
    }
  }

  GoogleMapController? mapController;
  CameraPosition? cameraPosition;
  bool isUpdateAddress = true;

  // for get current location
  void getCurrentLocation(BuildContext context, bool fromAddress, {GoogleMapController? mapController}) async {
    _loading = true;
    notifyListeners();

    Position myPosition;
    try {
      Position newLocalData = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
      myPosition = newLocalData;

    }catch(e) {
      myPosition = Position(
        latitude: double.parse('0'),
        longitude: double.parse('0'),
        timestamp: DateTime.now(), accuracy: 1, altitude: 1, heading: 1, speed: 1, speedAccuracy: 1,
        altitudeAccuracy: 0, headingAccuracy: 0,
      );
    }
    if(fromAddress) {
      _position = myPosition;

    }else {
      _pickPosition = myPosition;

    }

    if (mapController != null) {
      mapController.animateCamera(CameraUpdate.newCameraPosition(
        CameraPosition(target: LatLng(myPosition.latitude, myPosition.longitude), zoom: 17),
      ));
    }
    // String _myPlaceMark;
    String getAddress = await getAddressFromGeocode(LatLng(myPosition.latitude, myPosition.longitude));

    if(fromAddress) {
      _address = placeMarkToAddress(getAddress);
    }
    _loading = false;
    notifyListeners();
  }

  void updatePosition(CameraPosition? position, bool fromAddress, String? address, {bool forceNotify = true}) async {
    if(_updateAddAddressData) {
      _loading = true;
      if(forceNotify){
        notifyListeners();
      }


      try {
        if (fromAddress) {
          print('---------------(FROM ADDRESS POSITION)---------${position?.target.latitude} and ${position?.target.longitude}');
          _position = Position(
            latitude: position!.target.latitude, longitude: position.target.longitude, timestamp: DateTime.now(),
            heading: 1, accuracy: 1, altitude: 1, speedAccuracy: 1, speed: 1, altitudeAccuracy: 0, headingAccuracy: 0,
          );
        } else {
          print('---------------(FROM ADDRESS Pick Positon)---------${position?.target.latitude} and ${position?.target.longitude}');
          _pickPosition = Position(
            latitude: position!.target.latitude, longitude: position.target.longitude, timestamp: DateTime.now(),
            heading: 1, accuracy: 1, altitude: 1, speedAccuracy: 1, speed: 1,
            altitudeAccuracy: 0, headingAccuracy: 0,
          );
        }
        if (_changeAddress) {
          String addressFromGeocode = await getAddressFromGeocode(LatLng(position.target.latitude, position.target.longitude));
          fromAddress ? _address = addressFromGeocode : _pickAddress = addressFromGeocode;

          print("------(CHANGE ADDRESS)----------Address: $address and PickedAddress: $_pickAddress and Force Notify : $forceNotify");
          notifyListeners();

        } else {
          _changeAddress = true;
        }
      } catch (e) {
        debugPrint('error ==> $e');
      }
      _loading = false;

      if(forceNotify){
        notifyListeners();
      }

    }else {
      _updateAddAddressData = true;
    }
  }
  Future<Map<String, dynamic>?> getAddressDetailsFromCoordinates(double lat, double lng) async {
    const apiKey = 'AIzaSyDfB1sYNbS-EzXvMaTjUIEwRmbcij-ghB4';
    final url = 'https://maps.googleapis.com/maps/api/geocode/json?latlng=$lat,$lng&key=$apiKey';
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        return json.decode(response.body);
      }
      return null;
    } catch (e) {
      debugPrint('Geocoding error: $e');
      return null;
    }
  }
  Future<String?> getCityFromCoordinates(double lat, double lng) async {
    const apiKey = 'AIzaSyDfB1sYNbS-EzXvMaTjUIEwRmbcij-ghB4'; // Replace with your Google Maps API key
    final url = 'https://maps.googleapis.com/maps/api/geocode/json?latlng=$lat,$lng&key=$apiKey';

    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        // Extract city from the first result's address components
        for (var component in data['results'][0]['address_components']) {
          if (component['types'].contains('locality')) {
            return component['long_name']; // Returns the city name (e.g., "Cairo")
          }
        }
      }
      return null;
    } catch (e) {
      debugPrint('Geocoding error: $e');
      return null;
    }
  }
  // delete user address
  void deleteUserAddressByID(int? id, int index, Function callback) async {
    ApiResponseModel apiResponse = await locationRepo.removeAddressByID(id);
    if (apiResponse.response != null && apiResponse.response!.statusCode == 200) {
      _addressList?.removeAt(index);
      callback(true, 'Deleted address successfully');
      notifyListeners();
    } else {
      callback(false, ApiCheckerHelper.getError(apiResponse).errors![0].message ?? '');
    }
  }


  // user address


  Future<ResponseModel?> initAddressList() async {
    ResponseModel? responseModel;
    _addressList = null;
    ApiResponseModel apiResponse = await locationRepo.getAllAddress();
    if (apiResponse.response != null && apiResponse.response!.statusCode == 200) {
      _addressList = [];
      apiResponse.response!.data.forEach((address) => _addressList!.add(AddressModel.fromJson(address)));
      responseModel = ResponseModel(true, 'successful');
    } else {
      _addressList = [];
      ApiCheckerHelper.checkApi(apiResponse);
    }
    notifyListeners();
    return responseModel;
  }

  bool _isLoading = false;

  bool get isLoading => _isLoading;
  String? _errorMessage = '';
  String? get errorMessage => _errorMessage;
  String? _addressStatusMessage = '';
  String? get addressStatusMessage => _addressStatusMessage;
  updateAddressStatusMessage({String? message}){
    _addressStatusMessage = message;
  }

  void onChangeErrorMessage({String? message}){
    _errorMessage = message;
  }

  Future<ResponseModel> addAddress(AddressModel addressModel, BuildContext context) async {
    _isLoading = true;
    notifyListeners();
    _errorMessage = '';
    _addressStatusMessage = null;

    ApiResponseModel apiResponse = await locationRepo.addAddress(addressModel);
    _isLoading = false;
    ResponseModel responseModel;

    if (apiResponse.response != null && apiResponse.response!.statusCode == 200) {
      Map map = apiResponse.response!.data;
      initAddressList();
      String? message = map["message"];
      responseModel = ResponseModel(true, message);
      _addressStatusMessage = message;
    } else {

      responseModel = ResponseModel(false, ApiCheckerHelper.getError(apiResponse).errors?.first.message);
    }
    _isLoading = false;
    notifyListeners();
    return responseModel;
  }

  // for address update screen
  Future<ResponseModel> updateAddress(BuildContext context, {required AddressModel addressModel, int? addressId}) async {
    _isLoading = true;
    notifyListeners();
    _errorMessage = '';
    _addressStatusMessage = null;
    ApiResponseModel apiResponse = await locationRepo.updateAddress(addressModel, addressId);
    _isLoading = false;
    ResponseModel responseModel;
    if (apiResponse.response != null && apiResponse.response!.statusCode == 200) {
      Map map = apiResponse.response!.data;
      initAddressList();
      String? message = map["message"];
      responseModel = ResponseModel(true, message);
      _addressStatusMessage = message;
    } else {
      _errorMessage = ApiCheckerHelper.getError(apiResponse).errors![0].message;
      responseModel = ResponseModel(false, errorMessage);

    }
    notifyListeners();
    return responseModel;
  }

  // for save user address Section
  Future<void> saveUserAddress({Placemark? address}) async {
    String userAddress = jsonEncode(address);
    try {
      await sharedPreferences!.setString(AppConstants.userAddress, userAddress);
    } catch (e) {
      rethrow;
    }
  }

  String getUserAddress() {
    return sharedPreferences!.getString(AppConstants.userAddress) ?? "";
  }

  // for Label Us


  updateAddressIndex(int index, bool notify) {
    _selectAddressIndex = index;
    if(notify) {
      notifyListeners();
    }
  }

  initializeAllAddressType({BuildContext? context}) {
    if (_getAllAddressType.isEmpty) {
      _getAllAddressType = [];
      _getAllAddressType = locationRepo.getAllAddressType(context: context);
    }
  }

  Future<Position> setLocation(String? placeID, String? address, GoogleMapController? mapController) async {
    _loading = true;
    notifyListeners();
    PlacesDetailsResponse detail;
    ApiResponseModel response = await locationRepo.getPlaceDetails(placeID);
    detail = PlacesDetailsResponse.fromJson(response.response?.data);

    _pickPosition = Position(
      longitude: detail.result.geometry!.location.lat, latitude: detail.result.geometry!.location.lng,
      timestamp: DateTime.now(), accuracy: 1, altitude: 1, heading: 1, speed: 1, speedAccuracy: 1,
      altitudeAccuracy: 0, headingAccuracy: 0,
    );

    _pickAddress = address;
    _address = address;
    _changeAddress = false;

    if(mapController != null) {
      mapController.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(target: LatLng(
        detail.result.geometry!.location.lat, detail.result.geometry!.location.lng,
      ), zoom: 16)));
    }
    _loading = false;
    notifyListeners();

    return _pickPosition;
  }

  void disableButton() {
    _buttonDisabled = true;
    notifyListeners();
  }

  void setAddAddressData(bool isUpdate) {
    _position = _pickPosition;
    _address = _pickAddress;
    _updateAddAddressData = false;
    if(isUpdate){
      notifyListeners();
    }
  }


  void setPickData() {
    _pickPosition = _position;
    _pickAddress = _address;
  }



  Future<String> getAddressFromGeocode(LatLng latLng) async {
    ApiResponseModel response = await locationRepo.getAddressFromGeocode(latLng);
    String address = 'Unknown Location Found';
    if(response.response!.statusCode == 200 && response.response!.data['status'] == 'OK') {
      address = response.response!.data['results'][0]['formatted_address'].toString();
    }else {
      ApiCheckerHelper.checkApi(response);
    }
    return address;
  }

  Future<List<PredictionModel>> searchLocation(BuildContext context, String text) async {
    if(text.isNotEmpty) {

      ApiResponseModel response = await locationRepo.searchLocation(text);
      if (response.response?.statusCode == 200 && response.response!.data['status'] == 'OK') {
        _predictionList = [];
        response.response!.data['predictions'].forEach((prediction) =>
            _predictionList.add(PredictionModel.fromJson(prediction)));
      }else{
        _predictionList = [];
      }
    }
    return _predictionList;
  }

  String placeMarkToAddress(String placeMark) {
    return placeMark;
  }


  Future<AddressModel?> getLastOrderedAddress() async {
    AddressModel? addressModel;
    ApiResponseModel apiResponse = await locationRepo.getLastOrderedAddress();
    if (apiResponse.response != null && apiResponse.response!.statusCode == 200 && apiResponse.response?.data.isNotEmpty) {
      addressModel = AddressModel.fromJson(apiResponse.response?.data);
    }
    return addressModel;
  }

  int? getAddressIndex(AddressModel address){
    int? index;
    if(_addressList != null) {
      for(int i = 0; i < _addressList!.length; i ++) {
        if(_addressList![i].id == address.id) {
          index = i;
          break;
        }
      }
    }
    return index;
  }




}
