import 'dart:convert';

import 'package:dreamhome/api/api.dart';
import 'package:dreamhome/models/Comment.dart';
import 'package:dreamhome/repository/CommentRepository.dart';
import 'package:http/http.dart' as http;


class CommentService implements CommentRepository{

  @override
  Future<List<Comment>>? getCommentAPost() async {
    List<Comment>? body;
    try{
      http.Response response = await http.get(Uri.parse(URL + "comment"));
      if (response.statusCode == SUCCESS){
        body = jsonDecode(response.body);
      }
    } catch (e){
      print(e.toString());
    }
    return body!;
  }

  @override
  Future<String> addComment(Comment comment) async {
    String? commentResponse;
    try{
      http.Response response = await http.post(Uri.parse(URL + "comment"), headers: {"Content-Type" : "application/json"}, body: jsonEncode(comment.toJson()));
      print(response.body);
      commentResponse = response.body;
    } catch (e) {
      print(e.toString());
    }
    return commentResponse!;
  }

  @override
  Future<List>? getAllCommentNotification(String idUser) async {
    List? body = [];
    try {
      http.Response response = await http.get(Uri.parse(URL + "comment/commentNotification/" + idUser));
      if (response.statusCode == SUCCESS) {
        body = jsonDecode(response.body);
      }
    } catch (e) {
      print(e.toString());
    }
    return body!;
  }

}