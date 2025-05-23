import 'package:dreamhome/models/Review.dart';

abstract class ReviewRepository{
  Future<String> addReview(Review review);
  Future<String?> getReview(String idOrder);
  Future<List?> getAllReview(String idProduct, int? limit);
  Future<String?> getTotalReviewsForProduct(String idProduct);
}