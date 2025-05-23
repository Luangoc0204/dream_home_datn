import 'package:dreamhome/models/Comment.dart';
import 'package:dreamhome/repository/CommentRepository.dart';
import 'package:flutter/cupertino.dart';
import 'dart:convert';

class CommentViewModel with ChangeNotifier{
  late CommentRepository commentRepository;
  CommentViewModel({required this.commentRepository});
  List<Comment>? _listCommentNotification;
  Comment? _comment;
  get listCommentNotification{return _listCommentNotification;}
  get comment{
    return _comment;
  }
  Future<void> addComment(Comment comment) async {
    String commentApi = await commentRepository.addComment(comment);
    Map<String, dynamic> commentMap = jsonDecode(commentApi);
    _comment = Comment.fromMap(commentMap);
    notifyListeners();
  }
  Future<void> getAllCommentNotificaion(String idUser) async{
    _listCommentNotification = [];
    List? comments = await commentRepository.getAllCommentNotification(idUser);
    if (comments != null){
      _listCommentNotification!.addAll(comments!.map((e) => Comment.fromMap(e)).toList());
      _listCommentNotification!.sort((a, b) => b.created_at!.compareTo(a.created_at!));

    }
    notifyListeners();
  }
}
