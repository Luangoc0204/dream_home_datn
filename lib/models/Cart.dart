import 'package:dreamhome/models/Order.dart';
import 'package:dreamhome/models/Product.dart';
import 'package:dreamhome/models/User.dart';
import 'package:scoped_model/scoped_model.dart';

class Cart extends Model {
  late String id;
  User author;
  int? totalOrder;
  String? phone;
  String? address;

  Cart(this.id, this.author, this.totalOrder, this.phone, this.address);

  Cart.noId(this.author);

  factory Cart.fromMap(Map<String, dynamic> json) {
    return Cart(json['_id'], User.fromMap(json['author'] as Map<String, dynamic>), json['totalOrder'], json['phone'],
        json['address']);
  }
  Map<String, dynamic> toJsonAdd(){
    return {
      'author': author.id
    };
  }
  Map<String, dynamic> toJson() {
    return {"_id": id, "author": author.id, "phone": phone, "address": address};
  }

  @override
  String toString() {
    return 'Cart{id: $id, author: $author, totalOrder: $totalOrder, phone: $phone, address: $address}';
  }
}
