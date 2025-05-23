import 'package:dreamhome/models/Post.dart';
import 'package:dreamhome/models/User.dart';
import 'package:scoped_model/scoped_model.dart';

class Comment extends Model{
  String id;
  String content;
  User author;
  Post? post;
  DateTime created_at;
  DateTime updated_at;

  Comment(this.id, this.content, this.author, this.post, this.created_at,
      this.updated_at);


  Comment.noId(this.content, this.author, this.post)
      : id = '', // Gán id là chuỗi rỗng
        created_at = DateTime.now(), // Gán created_at là thời điểm hiện tại
        updated_at = DateTime.now(); // Gán updated_at là thời điểm hiện tại


  factory Comment.fromMap(Map<String, dynamic> json) {
    return Comment(
        json['_id'],
        json['content'],
        User.fromMap(json['author'] as Map<String, dynamic>), // Chuyển đổi giá trị 'author' thành đối tượng User bằng cách sử dụng hàm fromMap của User
        json['post'] != null ? Post.fromMap(json['post'] as Map<String, dynamic>) : null,
        DateTime.parse(json['created_at'] as String), // Chuyển đổi chuỗi thành DateTime
        DateTime.parse(json['updated_at'] as String),
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'content':content,
      'author' : author.id,
      'post' : post!.id
    };
  }
}