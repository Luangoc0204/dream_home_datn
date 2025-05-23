import 'dart:io';

import 'dart:io';

import 'package:dreamhome/models/Post.dart';

abstract class PostRepository{

  Future<List>? getAllPost(String idUser);

  Future<String> getPost(String id, String idUser);

  Future<String> addPost(Post post);
  Future<String> updatePost(Post post);
  Future<String> uploadImages(List<File> images, String postId);
  Future<String> editUploadImages(List<File> images, String postId);

  Future<List>? getAllPostPersonal(String idUser);
  Future<String> deletePost(String id);

}