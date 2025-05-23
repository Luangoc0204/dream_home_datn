import 'dart:convert';
import 'dart:io';

import 'package:dreamhome/api/api.dart';
import 'package:dreamhome/models/Shop.dart';
import 'package:dreamhome/repository/ShopRepository.dart';
import 'package:http/http.dart' as http;

class ShopService implements ShopRepository{
  @override
  Future<String?> getCurrentShop(String idUser) async {
    String? shop;
    try{
      http.Response response = await http.get(Uri.parse(URL + "shop/currentShop/" + idUser));
      if (response.statusCode == SUCCESS){
        shop = response.body;
      } else {
        print("Current shop error:" + response.body.toString());
      }
    } catch (e){
      print(e.toString());
    }
    return shop;
  }

  @override
  Future<String> getShop(String id) async {
    String? shop;
    try{
      http.Response response = await http.get(Uri.parse(URL + "shop/" + id));
      if (response.statusCode == SUCCESS){
        shop = response.body;
      } else {
        print("Current shop error:" + response.body.toString());
      }
    } catch (e){
      print(e.toString());
    }
    return shop!;
  }

  @override
  Future<String> addShop(Shop shop) async {
    try {
      final http.Response response = await http.post(
        Uri.parse(URL + "shop"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(shop.toJson()),
      );
      if (response.statusCode == 200) {
        return response.body;
      } else {
        throw Exception('Failed to add shop');
      }
    } catch (e) {
      print("Add cart: " + e.toString());
      throw Exception('Failed to add shop');
    }
  }

  @override
  Future<String> editUploadImages(File image, String shopId) async {
    var request = http.MultipartRequest(
      'POST',
      Uri.parse(URL + 'shop/uploadEdit/'+shopId),
    );

    var stream = http.ByteStream(image.openRead());
    var length = await image.length();

    var multipartFile = http.MultipartFile(
      'images',
      stream,
      length,
      filename: '$shopId.jpg', // Đặt tên cho ảnh với id của post
    );

    request.files.add(multipartFile);

    try {
      var response = await request.send();
      if (response.statusCode == 200) {
        // Lấy dữ liệu văn bản từ API response
        String responseBody = await response.stream.bytesToString();
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
  Future<String> updateShop(Shop shop) async {
    try {
      final http.Response response = await http.post(
        Uri.parse(URL + "shop/update/" + shop.id),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(shop.toJsonEdit()),
      );
      if (response.statusCode == 200) {
        // final Map<String, dynamic> responseData = jsonDecode(response.body);
        // final Post savedPost = Post.fromMap(responseData);
        return response.body;
      } else {
        throw Exception('Failed to update user');
      }
    } catch (e) {
      print(e.toString());
      throw Exception('Failed to update user');
    }
  }

}