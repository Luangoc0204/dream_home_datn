import 'dart:io';

import 'package:dreamhome/models/Shop.dart';

abstract class ShopRepository{
  Future<String> getShop(String id);
  Future<String?> getCurrentShop(String idUser);
  Future<String> addShop(Shop shop);
  Future<String> updateShop(Shop shop);
  Future<String> editUploadImages(File image, String shopId);
}