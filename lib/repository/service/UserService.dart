import 'dart:convert';
import 'dart:io';

import 'package:dreamhome/api/api.dart';
import 'package:dreamhome/models/User.dart';
import 'package:dreamhome/repository/UserRepository.dart';
import 'package:http/http.dart' as http;

class UserService implements UserRepository{
  @override
  Future<String?> getCurrentUser(String email) async {
    String? user;
    try{
      http.Response response = await http.get(Uri.parse(URL + "user/currentUser/" + email));
      if (response.statusCode == SUCCESS){
        user = response.body;
      } else {
        print("Current user error:" + response.body.toString());
      }
    } catch (e){
      print(e.toString());
    }
    return user;
  }

  @override
  Future<String?> addUser(User user) async {
    try {
      final http.Response response = await http.post(
        Uri.parse(URL + "user"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(user.toJson()),
      );
      if (response.statusCode == 200) {
        // final Map<String, dynamic> responseData = jsonDecode(response.body);
        // final Post savedPost = Post.fromMap(responseData);
        return response.body;
      } else {
        throw Exception('Failed to add user');
      }
    } catch (e) {
      print(e.toString());
      throw Exception('Failed to add user');
    }
  }

  @override
  Future<String> editUploadImages(File image, String userId) async {
    var request = http.MultipartRequest(
      'POST',
      Uri.parse(URL + 'user/uploadEdit/'+userId),
    );

    var stream = http.ByteStream(image.openRead());
    var length = await image.length();

    var multipartFile = http.MultipartFile(
      'images',
      stream,
      length,
      filename: '$userId.jpg', // Đặt tên cho ảnh với id của post
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
  Future<String> updateUser(User user) async {
    try {
      final http.Response response = await http.post(
        Uri.parse(URL + "user/update/" + user.id),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(user.toJsonEdit()),
      );
      if (response.statusCode == 200) {
        // final Map<String, dynamic> responseData = jsonDecode(response.body);
        // final Post savedPost = Post.fromMap(responseData);
        return response.body;
      } else {
        throw Exception('Failed to add user');
      }
    } catch (e) {
      print(e.toString());
      throw Exception('Failed to add user');
    }
  }

}