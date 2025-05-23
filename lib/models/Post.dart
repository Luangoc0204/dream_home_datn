
import 'dart:ffi';

import 'package:dreamhome/models/Comment.dart';
import 'package:dreamhome/models/Like.dart';
import 'package:dreamhome/models/User.dart';
import 'package:scoped_model/scoped_model.dart';

class Post extends Model{
  late String id;
  String content;
  late List<String>? image;
  late int totalLike;
  late int totalComment;
  User author;
  late List<Comment> comments;
  Like? like;
  late DateTime created_at;
  late DateTime updated_at;

  Post(this.id, this.content, this.image, this.totalLike, this.totalComment, this.author, this.comments, this.like, this.created_at, this.updated_at);
  factory Post.fromMap(Map<String, dynamic> json){
    return Post(
        json['_id'],
        json['content'],
        (json['image'] as List<dynamic>?)?.map((e) => e.toString()).toList() ?? [], // Chuyển đổi giá trị 'image' thành List<String> hoặc sử dụng danh sách rỗng nếu nó là null
        json['totalLike'],
        json['totalComment'],
        User.fromMap(json['author'] as Map<String, dynamic>), // Chuyển đổi giá trị 'author' thành đối tượng User bằng cách sử dụng hàm fromMap của User
        (json['comments'] as List<dynamic>?)?.map((e) => Comment.fromMap(e as Map<String, dynamic>)).toList() ?? [],
        json['like'] != null && json['like'] != '' ? Like.fromMap(json['like'] as Map<String, dynamic>) : null,
        DateTime.parse(json['created_at'] as String), // Chuyển đổi chuỗi thành DateTime
        DateTime.parse(json['updated_at'] as String),
    );
  }
  Post.onlyContentAndAuthor(this.content, this.author);
  Map<String, dynamic> toJsonEdit(){
    return {
      '_id': id,
      'content' : content,
      'image' : image?.join(","),
    };
  }
  Map<String, dynamic> toJson(){
    return {
      'content':content,
      'author' : author.id
    };
  }
  @override
  String toString() {
    return 'Post{id: $id, content: $content, image: $image, totalLike: $totalLike, totalComment: $totalComment, author: $author, comments: $comments, created_at: $created_at, updated_at: $updated_at}';
  }
}