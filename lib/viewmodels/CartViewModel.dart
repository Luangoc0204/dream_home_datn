import 'dart:convert';

import 'package:dreamhome/models/Cart.dart';
import 'package:dreamhome/repository/CartRepository.dart';
import 'package:flutter/cupertino.dart';

class CartViewModel with ChangeNotifier{
  late CartRepository cartRepository;
  CartViewModel({required this.cartRepository});

  Cart? _cart;
  get cart{
    return this._cart;
  }
  Future<void> addCart(Cart cart) async {
    String? cartApi = await cartRepository.addCart(cart);
    Map<String, dynamic> cartMap = jsonDecode(cartApi!);
    _cart = Cart.fromMap(cartMap);
    notifyListeners();
  }
  Future<void> getCart(String idUser) async{
    String? cartApi = await cartRepository.getCart(idUser);
    if (cartApi != null && cartApi != '' && cartApi != "null"){
      Map<String, dynamic> cartMap = jsonDecode(cartApi);
      _cart = Cart.fromMap(cartMap);
      print(cart.toString());
    }
    notifyListeners();
  }
  Future<void> updateAddressCart(Cart cart) async {
    String? cartApi = await cartRepository.updateAddressCart(cart);
    Map<String, dynamic> cartMap = jsonDecode(cartApi!);
    _cart = Cart.fromMap(cartMap);
    debugPrint("cartViewModel update:" + _cart.toString());
    notifyListeners();
  }
}