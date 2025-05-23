import 'dart:convert';
import 'dart:ffi';

import 'package:dreamhome/models/Review.dart';
import 'package:dreamhome/repository/ReviewRepository.dart';
import 'package:flutter/cupertino.dart';

class ReviewViewModel with ChangeNotifier{
  late ReviewRepository reviewRepository;

  ReviewViewModel({required this.reviewRepository});
  List<Review> _listReview = [];
  Review? _review;
  int _totalReview = 0;
  get totalReview {return _totalReview;}
  get listReview {return _listReview;}
  get review {return _review;}

  Future<void> addReview(Review review) async {
    String? reviewApi = await reviewRepository.addReview(review);
    Map<String, dynamic> reviewMap = jsonDecode(reviewApi);
    // _review = Review.fromMap(reviewMap);
    notifyListeners();
  }
  Future<void> getReview(String idOrder) async{
    _review = null;
    String? reviewApi = await reviewRepository.getReview(idOrder);
    if (reviewApi != null && reviewApi != '' && reviewApi != "null"){
      Map<String, dynamic> reviewMap = jsonDecode(reviewApi);
      _review = Review.fromMap(reviewMap);
      print(_review.toString());
    }
    notifyListeners();
  }
  Future<void> getAllReviewForProduct(String idProduct, int? limit) async {
    List? reviews = await reviewRepository.getAllReview(idProduct, limit);
    _listReview = [];
    _listReview.addAll(reviews!.map((item) => Review.fromMap(item)).toList());
    notifyListeners();
  }
  Future<void> getTotalReviewsForProduct(String idProduct) async {
    String? totalReviews = await reviewRepository.getTotalReviewsForProduct(idProduct);
    _totalReview = totalReviews != null ? int.parse(totalReviews) : 0;
    notifyListeners();
  }
}