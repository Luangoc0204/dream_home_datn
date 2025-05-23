import 'package:dreamhome/models/Order.dart';
import 'package:dreamhome/models/Product.dart';
import 'package:dreamhome/models/User.dart';
import 'package:scoped_model/scoped_model.dart';

class Review extends Model{
  late String id;
  String content;
  int rating;
  Product product;
  Order? order;
  User author;
  late DateTime created_at;
  late DateTime updated_at;

  Review(this.id, this.content,this.rating, this.product, this.order, this.author,
      this.created_at, this.updated_at);
  Review.noId(this.content, this.rating, this.product, this.order, this.author);
  factory Review.fromMap(Map<String, dynamic> json){
    return Review(
      json['_id'],
      json['content'],
      json['rating'],
      Product.fromMap(json['product'] as Map<String, dynamic>),
      json['order'] == null ? null : Order.fromMap(json['order'] as Map<String, dynamic>),
      User.fromMap(json['author'] as Map<String, dynamic>),
      DateTime.parse(json['created_at'] as String), // Chuyển đổi chuỗi thành DateTime
      DateTime.parse(json['updated_at'] as String),
    );
  }
  Map<String, dynamic> toJson(){
    return {
      'content' : content,
      'rating' : rating,
      'product' : product.id,
      'order' : order!.id,
      'author' : author.id
    };
  }

  @override
  String toString() {
    return 'Review{id: $id, content: $content, rating: $rating, product: $product, order: $order, author: $author, created_at: $created_at, updated_at: $updated_at}';
  }
}