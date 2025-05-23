import 'package:dreamhome/models/Comment.dart';

abstract class CommentRepository{

  Future<List<Comment>>? getCommentAPost();
  Future<String> addComment(Comment comment);
  Future<List>? getAllCommentNotification(String idUser);
}