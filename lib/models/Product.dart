import 'package:dreamhome/models/Shop.dart';
import 'package:scoped_model/scoped_model.dart';

class Product extends Model{
  late String id;
  String name;
  num price;
  late num discount;
  late int amountSold;
  late List<ProductImage> images;
  String type;
  String content;
  Shop? shop;
  late num totalRating;
  late bool isActive;
  late DateTime created_at;
  late DateTime updated_at;

  Product.noId(this.name, this.price,this.discount, this.type, this.content, this.shop);

  Product(
      this.id,
      this.name,
      this.price,
      this.discount,
      this.amountSold,
      this.images,
      this.type,
      this.content,
      this.shop,
      this.totalRating,
      this.isActive,
      this.created_at,
      this.updated_at);
  factory Product.fromMap(Map<String, dynamic> json) {
    return Product(
      json['_id'],
      json['name'] ?? '',
      json['price'] ?? 0.0,
      json['discount'] ?? 0.0,
      json['amountSold'] ?? 0,
      (json['images'] as List<dynamic>?)?.map((e) => ProductImage.fromJson(e as Map<String, dynamic>)).toList() ?? [],
      json['type'] ?? '',
      json['content'] ?? '',
      json['shop'] != null ? Shop.fromMap(json['shop'] as Map<String, dynamic>) : null,
      json['totalRating'] ?? 0,
      json['isActive'] ?? false,
      DateTime.parse(json['created_at'] as String),
      DateTime.parse(json['updated_at'] as String),
    );
  }
  Map<String, dynamic> toJson(){
    return {
      'name' : name,
      'price' : price,
      'type' : type,
      'content' : content,
      'shop' : shop!.id
    };
  }
}
class ProductImage {
  String? id;
  String url;
  String? colorName;
  String? colorCode;

  ProductImage({
    this.id,
    required this.url,
    this.colorName,
    this.colorCode,
  });

  factory ProductImage.fromJson(Map<String, dynamic> json) {
    return ProductImage(
      id: json['_id'],
      url: json['url'],
      colorName: json['colorName'],
      colorCode: json['colorCode'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'url': url,
      'colorName': colorName,
      'colorCode': colorCode,
    };
  }

  @override
  String toString() {
    return 'ProductImage{id: $id, url: $url, colorName: $colorName, colorCode: $colorCode}';
  }
}