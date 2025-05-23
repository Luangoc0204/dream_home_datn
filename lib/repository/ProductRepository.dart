import 'dart:io';

import 'package:dreamhome/models/Product.dart';
import 'package:dreamhome/views/shop/AddEditProduct.dart';

abstract class ProductRepository{
  Future<List> getAllProductByType(String type);
  Future<List?> searchProduct(String key);
  Future<List> getAllProductByShop(String idShop);
  Future<List> getAllProductByShopForUser(String idShop);
  Future<String> getProduct(String id);
  Future<String> addProduct(Product product);
  Future<String> uploadImages(List<File> images, String postId);
  Future<String> addImageColorProduct(List<ProductImage> images, String idProduct);

}