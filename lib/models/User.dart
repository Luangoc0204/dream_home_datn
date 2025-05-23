import 'package:scoped_model/scoped_model.dart';

class User extends Model{
  late String id;
  String name;
  String? email;
  late String? avatar;

  User(this.id, this.name, this.email, this.avatar);
  User.noId(this.name, this.email);

  factory User.fromMap(Map<String, dynamic> json) {
    return User(
      json['_id'],
      json['name'],
      json['email'],
      json['avatar']
    );
  }
  Map<String, dynamic> toJson(){
    return {
      'name' : name,
      'email' : email
    };
  }
  Map<String, dynamic> toJsonEdit(){
    return {
      '_id' : id,
      'name' : name
    };
  }
  @override
  String toString() {
    return 'User{id: $id, name: $name, email: $email, avatar: $avatar}';
  }
}