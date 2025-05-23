import 'package:dreamhome/models/Like.dart';

abstract class LikeRepository{
  Future<String> addLike(Like like);
  Future<String> deleteLike(String idLike);
}