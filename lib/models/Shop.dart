import 'package:dreamhome/models/User.dart';
import 'package:scoped_model/scoped_model.dart';

class Shop extends Model{
  late String id;
  String name;
  String address;
  late String? avatar;
  late String? background;
  late User? author;
  late int? totalProduct;
  late int? totalFollow;

  Shop(this.id, this.name, this.address, this.avatar, this.background, this.author,
      this.totalProduct, this.totalFollow);

  Shop.noId(this.name, this.address, this.author);
  factory Shop.fromMap(Map<String, dynamic> json){
    return Shop(
      json['_id'],
      json['name'],
      json['address'],
      json['avatar'],
      json['background'],
      json['author'] != null ? User.fromMap(json['author'] as Map<String, dynamic>) : null,
      json['totalProduct'],
      json['totalFollow']
    );
  }
  Map<String, dynamic> toJsonEdit(){
    return {
      '_id' : id,
      'name' : name,
      'address' : address
    };
  }
  Map<String, dynamic> toJson(){
    return {
      'name' : this.name,
      'address' : this.address,
      'author' : this.author!.id
    };
  }

  @override
  String toString() {
    return 'Shop{id: $id, name: $name, address: $address, avatar: $avatar, background: $background, author: $author, totalProduct: $totalProduct, totalFollow: $totalFollow}';
  }
}