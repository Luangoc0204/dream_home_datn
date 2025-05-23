import 'dart:convert';

import 'package:dreamhome/api/api.dart';
import 'package:dreamhome/models/Review.dart';
import 'package:dreamhome/repository/ReviewRepository.dart';
import 'package:http/http.dart' as http;

class ReviewService implements ReviewRepository{
  @override
  Future<String> addReview(Review review) async {
    try {
      final http.Response response = await http.post(
        Uri.parse(URL + "review"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(review.toJson()),
      );
      if (response.statusCode == 200) {
        return response.body;
      } else {
        throw Exception('Failed to add review');
      }
    } catch (e) {
      print(e.toString());
      throw Exception('Failed to add review');
    }
  }

  @override
  Future<String?> getReview(String idOrder) async {
    String? review;
    try{
      http.Response response = await http.get(Uri.parse(URL + "review/" + idOrder));
      if (response.statusCode == SUCCESS){
        review = response.body;
      }
    } catch (e){
      print(e.toString());
    }
    return review!;
  }

  @override
  Future<List?> getAllReview(String idProduct, int? limit) async {
    List? body;
    try{
      http.Response response;
      if (limit == null){
        response = await http.get(Uri.parse(URL + "review/list/" + idProduct ));
      } else {
        response = await http.get(Uri.parse(URL + "review/list/" + idProduct + "?limit=" + limit.toString()));
      }
      if (response.statusCode == SUCCESS){
        body = jsonDecode(response.body);
      }
    } catch (e){
      print(e.toString());
    }
    return body!;
  }

  @override
  Future<String?> getTotalReviewsForProduct(String idProduct) async {
    String? body;
    try{
      http.Response response = await http.get(Uri.parse(URL + "review/total/" + idProduct));
      if (response.statusCode == SUCCESS){
        body = response.body;
      }
    } catch (e){
      print(e.toString());
    }
    return body!;
  }

}