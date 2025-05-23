import 'dart:convert';

import 'package:dreamhome/api/api.dart';
import 'package:dreamhome/models/Order.dart';
import 'package:dreamhome/repository/OrderRepository.dart';
import 'package:http/http.dart' as http;

class OrderService implements OrderRepository{
  @override
  Future<String> addOrder(Order order) async {
    try {
      final http.Response response = await http.post(
        Uri.parse(URL + "order"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(order.toJson()),
      );
      if (response.statusCode == 200) {
        // final Map<String, dynamic> responseData = jsonDecode(response.body);
        // final Post savedPost = Post.fromMap(responseData);
        return response.body;
      } else {
        throw Exception('Failed to add order');
      }
    } catch (e) {
      print(e.toString());
      throw Exception('Failed to add order');
    }
  }

  @override
  Future<List> getAllOderByCart(String cart) async {
    List? body;
    try{
      http.Response response = await http.get(Uri.parse(URL + "order/list/" + cart));
      if (response.statusCode == SUCCESS){
        body = jsonDecode(response.body);
      }
    } catch (e){
      print(e.toString());
    }
    return body!;
  }

  @override
  Future<String> updateOrdered(List<String> ordersId) async {
    try {
      final http.Response response = await http.post(
        Uri.parse("${URL}order/list/"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(ordersId),
      );
      if (response.statusCode == 200) {
        // final Map<String, dynamic> responseData = jsonDecode(response.body);
        // final Post savedPost = Post.fromMap(responseData);
        return response.body;
      } else {
        throw Exception('Failed to update ordered');
      }
    } catch (e) {
      print(e.toString());
      throw Exception('Failed to update ordered');
    }
  }

  @override
  Future<List> getAllOderNotDeliverForShop(String idShop) async {
    List? body;
    try{
      http.Response response = await http.get(Uri.parse(URL + "order/listNotDeliverForShop/" + idShop));
      if (response.statusCode == SUCCESS){
        body = jsonDecode(response.body);
      }
    } catch (e){
      print(e.toString());
    }
    return body!;
  }

  @override
  Future<List> getAllOderDeliveredForShop(String idShop) async {
    List? body;
    try{
      http.Response response = await http.get(Uri.parse(URL + "order/listDeliveredForShop/" + idShop));
      if (response.statusCode == SUCCESS){
        body = jsonDecode(response.body);
      }
    } catch (e){
      print(e.toString());
    }
    return body!;
  }

  @override
  Future<String?> getOrderDetail(String idOrder) async {
    String? body;
    try {
      http.Response response = await http.get(Uri.parse(URL + "order/" + idOrder));
      if (response.statusCode == SUCCESS) {
        body = response.body;
      }
    } catch (e) {
      print(e.toString());
    }
    return body;
  }

  @override
  Future<String> updateShippingOrder(String idOrder) async {
    String body = "";
    try {
      http.Response response = await http.get(Uri.parse(URL + "order/updateShipping/" + idOrder));
      if (response.statusCode == SUCCESS) {
        body = response.body;
      }
    } catch (e) {
      print(e.toString());
    }
    return body;
  }

  @override
  Future<String> deleteOrder(String idOrder) async {
    String body = "";
    try {
      http.Response response = await http.get(Uri.parse(URL + "order/delete/" + idOrder));
      if (response.statusCode == SUCCESS) {
        body = response.body;
      }
    } catch (e) {
      print(e.toString());
    }
    return body;
  }

  @override
  Future<List> getAllOderNotDeliverForUser(String idCart) async {
    List? body;
    try{
      http.Response response = await http.get(Uri.parse(URL + "order/listNotDeliverForUser/" + idCart));
      if (response.statusCode == SUCCESS){
        body = jsonDecode(response.body);
      }
    } catch (e){
      print(e.toString());
    }
    return body!;
  }

  @override
  Future<String> updatePaidOrder(String idOrder) async {
    String body = "";
    try {
      http.Response response = await http.get(Uri.parse(URL + "order/updatePaid/" + idOrder));
      if (response.statusCode == SUCCESS) {
        body = response.body;
      }
    } catch (e) {
      print(e.toString());
    }
    return body;
  }

  @override
  Future<List> getAllPaidForUser(String idCart) async {
    List? body;
    try{
      http.Response response = await http.get(Uri.parse(URL + "order/listPaidForUser/" + idCart));
      if (response.statusCode == SUCCESS){
        body = jsonDecode(response.body);
      }
    } catch (e){
      print(e.toString());
    }
    return body!;
  }

  @override
  Future<String> updateAmountOrder(Order order) async {
    try {
      final http.Response response = await http.post(
        Uri.parse(URL + "order/updateAmount"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(order.toJsonUpdateAmount()),
      );
      if (response.statusCode == 200) {
        // final Map<String, dynamic> responseData = jsonDecode(response.body);
        // final Post savedPost = Post.fromMap(responseData);
        return response.body;
      } else {
        throw Exception('Failed to update order');
      }
    } catch (e) {
      print(e.toString());
      throw Exception('Failed to update order');
    }
  }

}