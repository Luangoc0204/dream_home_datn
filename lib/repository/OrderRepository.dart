import 'package:dreamhome/models/Order.dart';

abstract class OrderRepository{
  Future<String> addOrder(Order order);
  Future<String> updateAmountOrder(Order order);
  Future<List> getAllOderByCart(String cart);
  Future<String> updateOrdered(List<String> ordersId);
  Future<List> getAllOderNotDeliverForShop(String idShop);
  Future<List> getAllOderDeliveredForShop(String idShop);
  Future<String?> getOrderDetail(String idOrder);
  Future<String> updateShippingOrder(String idOrder);
  Future<String> deleteOrder(String idOrder);
  Future<List> getAllOderNotDeliverForUser(String idCart);
  Future<List> getAllPaidForUser(String idCart);
  Future<String> updatePaidOrder(String idOrder);

}