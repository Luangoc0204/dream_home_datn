import 'package:dreamhome/models/Cart.dart';

abstract class CartRepository{
  Future<String?> addCart(Cart cart);
  Future<String?> getCart(String idUser);
  Future<String?> updateAddressCart(Cart cart);

}