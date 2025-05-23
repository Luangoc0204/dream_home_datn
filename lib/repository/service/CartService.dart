import 'dart:convert';

import 'package:dreamhome/api/api.dart';
import 'package:dreamhome/models/Cart.dart';
import 'package:dreamhome/repository/CartRepository.dart';
import 'package:http/http.dart' as http;

class CartService implements CartRepository{
  @override
  Future<String?> addCart(Cart cart) async {
    try {
      final http.Response response = await http.post(
        Uri.parse(URL + "cart"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(cart.toJsonAdd()),
      );
      if (response.statusCode == 200) {
        // final Map<String, dynamic> responseData = jsonDecode(response.body);
        // final Post savedPost = Post.fromMap(responseData);
        return response.body;
      } else {
        throw Exception('Failed to add cart');
      }
    } catch (e) {
      print("Add cart: " + e.toString());
      throw Exception('Failed to add cart');
    }
  }

  @override
  Future<String?> getCart(String idUser) async {
    String? cart;
    try{
      http.Response response = await http.get(Uri.parse(URL + "cart/" + idUser));
      if (response.statusCode == SUCCESS){
        cart = response.body;
      }
    } catch (e){
      print(e.toString());
    }
    return cart!;
  }

  @override
  Future<String?> updateAddressCart(Cart cart) async {
    try {
      final http.Response response = await http.post(
        Uri.parse(URL + "cart/address"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(cart.toJson()),
      );
      if (response.statusCode == 200) {
        // final Map<String, dynamic> responseData = jsonDecode(response.body);
        // final Post savedPost = Post.fromMap(responseData);
        return response.body;
      } else {
        throw Exception('Failed to update address cart');
      }
    } catch (e) {
      print(e.toString());
      throw Exception('Failed to update address cart');
    }
  }

}