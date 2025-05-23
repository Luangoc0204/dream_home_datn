import 'dart:convert';
import 'dart:io';

import 'package:dreamhome/models/Shop.dart';
import 'package:dreamhome/repository/ShopRepository.dart';
import 'package:flutter/cupertino.dart';

class ShopViewModel with ChangeNotifier{
  late ShopRepository shopRepository;

  ShopViewModel({required this.shopRepository});
  Shop? _currentShop;
  Shop? _shop;
  get shop{return _shop;}
  get currentShop{
    return _currentShop;
  }
  Future<void> getCurrentShop(String idUser) async{
    String? currentShopApi = await shopRepository.getCurrentShop(idUser);
    debugPrint("Current shop Api: $currentShopApi");
    if (currentShopApi != null && currentShopApi != '' && currentShopApi != "null"){
      Map<String, dynamic> currentShopMap = jsonDecode(currentShopApi);
      _currentShop = Shop.fromMap(currentShopMap);
    }
    notifyListeners();
  }
  Future<void> getShop(String idShop) async{
    String? shopApi = await shopRepository.getShop(idShop);
    debugPrint("Shop Api: $shopApi");
    if (shopApi != null && shopApi != '' && shopApi != "null"){
      Map<String, dynamic> shopMap = jsonDecode(shopApi);
      _shop = Shop.fromMap(shopMap);
    }
    notifyListeners();
  }
  Future<void> addShop(Shop shop) async {
    String? shopApi = await shopRepository.addShop(shop);
    Map<String, dynamic> shopMap = jsonDecode(shopApi);
    _currentShop = Shop.fromMap(shopMap);
    notifyListeners();
  }
  Future<void> updateShop(Shop shop, File? image) async{
    try {
      // Step 1: Gửi request để thêm post và nhận về id của post
      String shopApi = await shopRepository.updateShop(shop);
      Map<String, dynamic> shopMap = jsonDecode(shopApi);
      _currentShop = Shop.fromMap(shopMap);

      // Step 2: Nếu post được thêm thành công, thì upload ảnh
      if (image != null) {
        // print('Number of images: ${images.length}');
        String response = await shopRepository.editUploadImages(image, _currentShop!.id);
        Map<String, dynamic> shopMapImage = jsonDecode(response);
        _currentShop = Shop.fromMap(shopMapImage);

      }
      notifyListeners();

    } catch (e) {
      print('Error: $e');
      // Xử lý lỗi nếu có
    }
  }
}