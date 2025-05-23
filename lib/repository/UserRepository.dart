import 'dart:io';

import 'package:dreamhome/models/User.dart';

abstract class UserRepository{
  Future<String?> getCurrentUser(String email);
  Future<String?> addUser(User user);
  Future<String> updateUser(User user);
  Future<String> editUploadImages(File image, String userId);
}