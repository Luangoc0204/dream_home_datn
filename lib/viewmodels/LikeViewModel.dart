import 'dart:convert';

import 'package:dreamhome/models/Like.dart';
import 'package:dreamhome/repository/LikeRepository.dart';
import 'package:flutter/cupertino.dart';

class LikeViewModel with ChangeNotifier{
  late LikeRepository likeRepository;

  LikeViewModel({required this.likeRepository});
  Like? _like;
  get like{return _like;}
  Future<void> addLike(Like like) async {
    String? shopApi = await likeRepository.addLike(like);
    Map<String, dynamic> shopMap = jsonDecode(shopApi);
    _like = Like.fromMap(shopMap);
    notifyListeners();
  }
  Future<void> deleteLike(String id) async {
    String postApi = await likeRepository.deleteLike(id);
    notifyListeners();
  }
}