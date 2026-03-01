import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_grocery/common/models/api_response_model.dart';
import 'package:flutter_grocery/common/models/product_model.dart';
import 'package:flutter_grocery/features/search/domain/reposotories/search_repo.dart';
import 'package:flutter_grocery/helper/api_checker_helper.dart';

class SearchProvider with ChangeNotifier {
  final SearchRepo? searchRepo;

  SearchProvider({required this.searchRepo});

  String? _selectedFilter;
  double? _lowerValue;
  double? _upperValue;
  List<String?> _historyList = [];

  String? get selectedFilter => _selectedFilter;
  double? get lowerValue => _lowerValue;
  double? get upperValue => _upperValue;

  bool _isClear = true;
  String _searchText = '';
  bool _isSearch = true;



  bool get isClear => _isClear;
  bool get isSearch => _isSearch;

  String get searchText => _searchText;
  List<String?> get historyList => _historyList;

  final List<Product> _categoryProductList = [];
  List<Product> get categoryProductList => _categoryProductList;


  List<String?> _allSortBy = [];

  List<String?> get allSortBy => _allSortBy;
  TextEditingController _searchController = TextEditingController();
  TextEditingController  get searchController=> _searchController;
  int _searchLength = 0;
  int get searchLength => _searchLength;

  void onChangeSearchStatus(){
    _isSearch = !_isSearch;
    notifyListeners();
  }

  void setSearchValue(String searchText){
    _searchController = TextEditingController(text: searchText);
    _searchLength = searchText.length;
    notifyListeners();
  }

  void setFilterValue(String? value, {bool isUpdate = true}) {
    _selectedFilter = value;

    if(isUpdate) {
      notifyListeners();
    }
  }

  void initializeAllSortBy({bool notify = true}) {
    if (_allSortBy.isEmpty) {
      _allSortBy = [];
      _allSortBy = searchRepo!.getAllSortByList();
    }
    _selectedFilter = null;
    if(notify) {
      notifyListeners();
    }
  }

  void setLowerAndUpperValue(double? lower, double? upper, {bool isUpdate = true}) {
    _lowerValue = lower;
    _upperValue = upper;

    if(isUpdate) {
      notifyListeners();
    }
  }

  void setSearchText(String text) {
    _searchText = text;
    notifyListeners();
  }

  void cleanSearchProduct() {
    _isClear = true;
    _searchText = '';
    notifyListeners();
  }


  ProductModel? _searchProductModel;
  ProductModel? get searchProductModel => _searchProductModel;


  Future<void> getSearchProduct({
    required int offset,
    required String query,
    double? priceLow,
    double? priceHigh,
    String? filterType,
    bool isUpdate = false,
  }) async {

    if(offset == 1) {
      _searchProductModel?.products = null;

      if(isUpdate) {
        notifyListeners();
      }

    }

    ApiResponseModel apiResponse = await searchRepo!.getSearchProductList(
      offset: offset, query: query,
      priceHigh: priceHigh, priceLow: priceLow,
      filterBy: filterType,
    );

    if (apiResponse.response != null && apiResponse.response!.statusCode == 200) {

      if(offset == 1){
        _searchProductModel = ProductModel.fromJson(apiResponse.response?.data);
      } else {
        _searchProductModel?.totalSize = ProductModel.fromJson(apiResponse.response?.data).totalSize;
        _searchProductModel?.offset = ProductModel.fromJson(apiResponse.response?.data).offset;
        _searchProductModel?.products?.addAll(ProductModel.fromJson(apiResponse.response?.data).products ?? []);
      }


    } else {
      _searchProductModel = ProductModel(products: []);
      ApiCheckerHelper.checkApi(apiResponse);
    }

    notifyListeners();
  }



  void initHistoryList() {
    _historyList = [];
    _historyList.addAll(searchRepo!.getSearchAddress());
  }

  void saveSearchAddress(String? searchAddress,{bool isUpdate = true}) async {
    if (!_historyList.contains(searchAddress)) {
      _historyList.add(searchAddress);
      searchRepo!.saveSearchAddress(searchAddress);
     if(isUpdate){
       notifyListeners();
     }
    }
  }

  void clearSearchAddress() async {
    searchRepo!.clearSearchAddress();
    _historyList = [];
    notifyListeners();
  }
}
