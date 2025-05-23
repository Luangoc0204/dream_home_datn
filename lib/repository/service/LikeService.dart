import 'dart:convert';

import 'package:dreamhome/api/api.dart';
import 'package:dreamhome/models/Like.dart';
import 'package:dreamhome/repository/LikeRepository.dart';
import 'package:http/http.dart' as http;

class LikeService implements LikeRepository{
  @override
  Future<String> addLike(Like like) async {
    try {
      final http.Response response = await http.post(
        Uri.parse(URL + "like"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(like.toJson()),
      );
      if (response.statusCode == 200) {
        return response.body;
      } else {
        throw Exception('Failed to add like');
      }
    } catch (e) {
      print("Add like: " + e.toString());
      throw Exception('Failed to add like');
    }
  }

  @override
  Future<String> deleteLike(String idLike) async {
    String? result;
    try{
      http.Response response = await http.get(Uri.parse(URL + "like/" + idLike));
      if (response.statusCode == SUCCESS){
        result = response.body;
      }
    } catch (e){
      print(e.toString());
    }
    return result!;
  }

}