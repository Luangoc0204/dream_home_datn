import 'dart:convert';
import 'dart:io';

import 'package:dreamhome/models/User.dart';
import 'package:dreamhome/repository/UserRepository.dart';
import 'package:flutter/cupertino.dart';

class UserViewModel with ChangeNotifier{
  late UserRepository userRepository;

  UserViewModel({required this.userRepository});
  User? _currentUser = null;
  get currentUser{
    return _currentUser;
  }

  Future<void> getCurrentUser(String email) async{
    String? currentUserApi = await userRepository.getCurrentUser(email);
    print("Email user:" + email);
    if (currentUserApi != null && currentUserApi != ''){
      Map<String, dynamic> currentUserMap = jsonDecode(currentUserApi!);
      _currentUser = User.fromMap(currentUserMap);
    }
    notifyListeners();
  }
  Future<void> addUser(User user) async {
    String? userApi = await userRepository.addUser(user);
    Map<String, dynamic> userMap = jsonDecode(userApi!);
    _currentUser = User.fromMap(userMap);
    notifyListeners();
  }
  void logout(){
    _currentUser = null;
    notifyListeners();
  }
  Future<void> updateUser(User user, File? image) async{
    try {
      // Step 1: Gửi request để thêm post và nhận về id của post
      String userApi = await userRepository.updateUser(user);
      Map<String, dynamic> userMap = jsonDecode(userApi);
      _currentUser = User.fromMap(userMap);

      // Step 2: Nếu post được thêm thành công, thì upload ảnh
      if (image != null) {
        // print('Number of images: ${images.length}');
        String response = await userRepository.editUploadImages(image, _currentUser!.id);
        Map<String, dynamic> userMapImage = jsonDecode(response);
        _currentUser = User.fromMap(userMapImage);

      }
      notifyListeners();

    } catch (e) {
      print('Error: $e');
      // Xử lý lỗi nếu có
    }
  }
}