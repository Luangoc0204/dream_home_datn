import 'dart:convert';
import 'dart:io';

import 'package:dreamhome/api/api.dart';
import 'package:dreamhome/models/Post.dart';
import 'package:dreamhome/repository/PostRepository.dart';
import 'package:http/http.dart' as http;
import 'package:iconify_flutter_plus/icons/carbon.dart';
class PostService implements PostRepository{
  @override
  Future<String> addPost(Post post) async {
    try {
      final http.Response response = await http.post(
        Uri.parse(URL + "post"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(post.toJson()),
      );
      if (response.statusCode == 200) {
        // final Map<String, dynamic> responseData = jsonDecode(response.body);
        // final Post savedPost = Post.fromMap(responseData);
        return response.body;
      } else {
        throw Exception('Failed to add post');
      }
    } catch (e) {
      print(e.toString());
      throw Exception('Failed to add post');
    }
  }
  Future<String> uploadImages(List<File> images, String postId) async {
    var request = http.MultipartRequest(
      'POST',
      Uri.parse(URL + 'post/upload/'+postId),
    );

    for (var i = 0; i < images.length; i++) {
      var stream = http.ByteStream(images[i].openRead());
      var length = await images[i].length();

      var multipartFile = http.MultipartFile(
        'images',
        stream,
        length,
        filename: '$postId$i.jpg', // Đặt tên cho ảnh với id của post
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
  Future<List>? getAllPost(String idUser) async {
    // TODO: implement getAllPost
    List? body;
    try{
      http.Response response = await http.get(Uri.parse(URL + "post/all/" + idUser));
      if (response.statusCode == SUCCESS){
        body = jsonDecode(response.body);
      }
    } catch (e){
      print(e.toString());
    }
    return body!;
  }


  @override
  Future<String> getPost(String id, String idUser) async {
    String? post;
    try{
      http.Response response = await http.get(Uri.parse(URL + "post/" + id + "?idUser=" + idUser));

      if (response.statusCode == SUCCESS){
        post = response.body;
      }
    } catch (e){
      print(e.toString());
    }
    return post!;
  }

  @override
  Future<List>? getAllPostPersonal(String idUser) async {
    List? body;
    try{
      http.Response response = await http.get(Uri.parse(URL + "post/listByUser/" + idUser));
      if (response.statusCode == SUCCESS){
        body = jsonDecode(response.body);
      }
    } catch (e){
      print(e.toString());
    }
    return body!;
  }

  @override
  Future<String> editUploadImages(List<File> images, String postId) async {
    var request = http.MultipartRequest(
      'POST',
      Uri.parse(URL + 'post/uploadEdit/'+postId),
    );

    for (var i = 0; i < images.length; i++) {
      var stream = http.ByteStream(images[i].openRead());
      var length = await images[i].length();

      var multipartFile = http.MultipartFile(
        'images',
        stream,
        length,
        filename: '$postId$i.jpg', // Đặt tên cho ảnh với id của post
      );

      request.files.add(multipartFile);
    }

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
  Future<String> updatePost(Post post) async {
    try {
      final http.Response response = await http.post(
        Uri.parse(URL + "post/edit"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(post.toJsonEdit()),
      );
      if (response.statusCode == 200) {
        // final Map<String, dynamic> responseData = jsonDecode(response.body);
        // final Post savedPost = Post.fromMap(responseData);
        return response.body;
      } else {
        throw Exception('Failed to edit post');
      }
    } catch (e) {
      print(e.toString());
      throw Exception('Failed to edit post');
    }
  }

  @override
  Future<String> deletePost(String id) async {
    String? post;
    try{
      http.Response response = await http.get(Uri.parse(URL + "post/delete/" + id));
      if (response.statusCode == SUCCESS){
        post = response.body;
      }
    } catch (e){
      print(e.toString());
    }
    return post!;
  }

}