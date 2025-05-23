import 'dart:convert';
import 'dart:io';

import 'package:dreamhome/api/api.dart';
import 'package:dreamhome/models/Product.dart';
import 'package:dreamhome/repository/ProductRepository.dart';
import 'package:dreamhome/views/shop/AddEditProduct.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

class ProductService implements ProductRepository{
  @override
  Future<List> getAllProductByType(String type) async {
    List? body;
    try{
      http.Response response = await http.get(Uri.parse(URL + "product/type/" + type));
      if (response.statusCode == SUCCESS){
        body = jsonDecode(response.body);
      }
    } catch (e){
      print(e.toString());
    }
    return body!;
  }
  Future<String> getProduct(String id) async {
    String? product;
    try{
      http.Response response = await http.get(Uri.parse(URL + "product/" + id));
      if (response.statusCode == SUCCESS){
        product = response.body;
      }
    } catch (e){
      print(e.toString());
    }
    return product!;
  }

  @override
  Future<List> getAllProductByShop(String idShop) async {
    List? body;
    try{
      http.Response response = await http.get(Uri.parse(URL + "product/shop/" + idShop));
      if (response.statusCode == SUCCESS){
        body = jsonDecode(response.body);
      }
    } catch (e){
      print(e.toString());
    }
    return body!;
  }

  @override
  Future<List> getAllProductByShopForUser(String idShop) async {
    List? body;
    try{
      http.Response response = await http.get(Uri.parse(URL + "product/shopForUser/" + idShop));
      if (response.statusCode == SUCCESS){
        body = jsonDecode(response.body);
      }
    } catch (e){
      print(e.toString());
    }
    return body!;
  }

  @override
  Future<String> addProduct(Product product) async {
    try {
      final http.Response response = await http.post(
        Uri.parse(URL + "product"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(product.toJson()),
      );
      if (response.statusCode == 200) {
        // final Map<String, dynamic> responseData = jsonDecode(response.body);
        // final Post savedPost = Post.fromMap(responseData);
        return response.body;
      } else {
        throw Exception('Failed to add product');
      }
    } catch (e) {
      print(e.toString());
      throw Exception('Failed to add product');
    }
  }

  @override
  Future<String> uploadImages(List<File> images, String productId) async {
    var request = http.MultipartRequest(
      'POST',
      Uri.parse(URL + 'product/upload/'+productId),
    );

    for (var i = 0; i < images.length; i++) {
      var stream = http.ByteStream(images[i].openRead());
      var length = await images[i].length();

      var multipartFile = http.MultipartFile(
        'images',
        stream,
        length,
        filename: '$productId$i.jpg', // Đặt tên cho ảnh với id của post
      );

      request.files.add(multipartFile);
    }

    try {
      var response = await request.send();
      if (response.statusCode == 200) {
        // Lấy dữ liệu văn bản từ API response
        String responseBody = await response.stream.bytesToString();
        print('Response: $responseBody');
        return responseBody;
      } else {
        print('Failed to upload images');
        return 'Failed to upload images';
      }
    } catch (e) {
      print('Error uploading images: $e');
      return 'Error uploading images';
    }
  }

  @override
  Future<String> addImageColorProduct(List<ProductImage> images, String idProduct) async {
    try {
      final http.Response response = await http.post(
        Uri.parse("${URL}product/addImageColor/$idProduct"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(images.map((e) => e.toJson()).toList()),
      );
      print("Body POST: " + jsonEncode(images.map((e) => e.toJson()).toList()));
      if (response.statusCode == 200) {
        // final Map<String, dynamic> responseData = jsonDecode(response.body);
        // final Post savedPost = Post.fromMap(responseData);
        return response.body;
      } else {
        throw Exception('Failed to add product');
      }
    } catch (e) {
      print(e.toString());
      throw Exception('Failed to add product');
    }
  }

  @override
  Future<List?> searchProduct(String key) async {
    List? body;
    try{
      http.Response response = await http.get(Uri.parse(URL + "product/search/" + key));
      if (response.statusCode == SUCCESS){
        body = jsonDecode(response.body);
      }
    } catch (e){
      print(e.toString());
    }
    return body!;
  }
}