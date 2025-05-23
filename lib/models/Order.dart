import 'package:dreamhome/models/Cart.dart';
import 'package:dreamhome/models/Product.dart';
import 'package:scoped_model/scoped_model.dart';

class Order extends Model{
  late String id;
  Product? product;
  num? price;
  int? amount;
  ProductImage color;
  Cart? cart;
  String? address;
  bool isOrdered = false;
  bool isShipped = false;
  bool isPaid = false;

  Order(this.id, this.product, this.price, this.amount, this.color, this.cart, this.address, this.isOrdered, this.isShipped,
      this.isPaid);

  Order.noId(this.product, this.amount, this.color, this.cart);

  factory Order.fromMap(Map<String, dynamic> json){
    return Order(
        json["_id"],
        json['product'] != null ? Product.fromMap(json["product"]) : null,
        json["price"],
        json["amount"],
        ProductImage.fromJson(json['color'] as Map<String, dynamic>),
        json["cart"] != null ? Cart.fromMap(json["cart"]) : null,
        json["address"],
        json["isOrdered"],
        json['isShipped'],
        json["isPaid"]
    );
  }
  Map<String, dynamic> toJson(){
    Map<String, dynamic> json = {
      "product" : product!.id,
      "price": price,
      "color": color.toJson(),
      "cart": cart!.id,
      "address": address
    };
    if (amount != null) {
      json['amount'] = amount;
    }
    return json;
  }
  Map<String, dynamic> toJsonUpdateAmount(){
    Map<String, dynamic> json = {
      "_id": id,
      "amount": amount
    };
    return json;
  }
  @override
  String toString() {
    return 'Order{id: $id, product: $product, price: $price, amount: $amount, color: $color, cart: $cart, isOrdered: $isOrdered, isShipped: $isShipped, isPaid: $isPaid}';
  }
}
