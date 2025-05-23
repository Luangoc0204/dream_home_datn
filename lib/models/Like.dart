import 'package:dreamhome/models/Post.dart';
import 'package:dreamhome/models/User.dart';
import 'package:scoped_model/scoped_model.dart';

class Like extends Model{
  String id;
  User author;
  Post? post;

  Like(this.id, this.author, this.post);


  Like.noId(this.author, this.post) : id = "";


  factory Like.fromMap(Map<String, dynamic> json) {
    return Like(
      json['_id'],
      User.fromMap(json['author'] as Map<String, dynamic>), // Chuyển đổi giá trị 'author' thành đối tượng User bằng cách sử dụng hàm fromMap của User
      json['post'] != null ? Post.fromMap(json['post'] as Map<String, dynamic>) : null
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'author' : author.id,
      'post' : post!.id
    };
  }
}