import 'dart:convert';

import 'package:dreamhome/repository/OrderRepository.dart';
import 'package:flutter/material.dart';

import '../models/Order.dart';

class OrderViewModel with ChangeNotifier{
  late OrderRepository orderRepository;
  OrderViewModel({required this.orderRepository});

  List<Order> _listOrder = [];
  get listOrder{ return _listOrder;}

  Order? _order;
  get order{ return _order;}

  Future<void> addOrder(Order order) async {
    String? orderApi = await orderRepository.addOrder(order);
    Map<String, dynamic> orderMap = jsonDecode(orderApi!);
    notifyListeners();
  }
  Future<void> updateAmountOrder(Order order) async {
    String? orderApi = await orderRepository.updateAmountOrder(order);
    Map<String, dynamic> orderMap = jsonDecode(orderApi);
    notifyListeners();
  }
  Future<void> getAllByCart(String cart) async {
    List? ordersApi = await orderRepository.getAllOderByCart(cart);
    _listOrder = [];
    _listOrder.addAll(ordersApi.map((item) => Order.fromMap(item)).toList());
    print(_listOrder);
    notifyListeners();
  }
  Future<void> updateOrdered(List<String> ordersId) async {
    String? result = await orderRepository.updateOrdered(ordersId);
  }
  Future<void> getAllNotDeliverForShop(String idShop) async {
    _listOrder = [];
    List? ordersApi = await orderRepository.getAllOderNotDeliverForShop(idShop);
    _listOrder.addAll(ordersApi.map((item) => Order.fromMap(item)).toList());
    print(_listOrder);
    notifyListeners();
  }
  Future<void> getAllDeliveredForShop(String idShop) async {
    _listOrder = [];
    List? ordersApi = await orderRepository.getAllOderDeliveredForShop(idShop);
    _listOrder.addAll(ordersApi.map((item) => Order.fromMap(item)).toList());
    // print(_listOrder);
    notifyListeners();
  }
  Future<void> getOrderDetail(String idOrder) async {
    String? orderApi = await orderRepository.getOrderDetail(idOrder);
    if (orderApi != null) {
      Map<String, dynamic> orderMap = jsonDecode(orderApi);
      _order = Order.fromMap(orderMap);
      notifyListeners();
    } else {
      // Xử lý trường hợp không có dữ liệu trả về hoặc lỗi xảy ra
      print("Không thể lấy chi tiết đơn hàng");
    }
  }
  Future<void> updateShippingOrder(String idOrder) async {
    String? orderApi = await orderRepository.updateShippingOrder(idOrder);
  }
  Future<void> deleteOrder(String idOrder) async {
    String result = await orderRepository.deleteOrder(idOrder);
  }
  Future<void> getAllNotDeliverForUser(String idCart) async {
    List? ordersApi = await orderRepository.getAllOderNotDeliverForUser(idCart);
    _listOrder = [];
    _listOrder.addAll(ordersApi.map((item) => Order.fromMap(item)).toList());
    print(_listOrder);
    notifyListeners();
  }
  Future<void> getAllPaidForUser(String idCart) async {
    List? ordersApi = await orderRepository.getAllPaidForUser(idCart);
    _listOrder = [];
    _listOrder.addAll(ordersApi.map((item) => Order.fromMap(item)).toList());
    print(_listOrder);
    notifyListeners();
  }
  Future<void> updatePaidOrder(String idOrder) async {
    String? orderApi = await orderRepository.updatePaidOrder(idOrder);
  }
}