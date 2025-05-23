import 'dart:convert';
import 'dart:io';

import 'package:dreamhome/models/Post.dart';
import 'package:dreamhome/repository/PostRepository.dart';
import 'package:flutter/cupertino.dart';

class PostViewModel with ChangeNotifier{
  PostViewModel({required this.postRepository});
  late PostRepository postRepository;
  List<Post> _listPost = [];
  List<Post> _listPostPersonal = [];
  Post? _post;
  get listPost{
    return _listPost;
  }
  get post{
    return _post;
  }
  get listPostPersonal{return _listPostPersonal;}
  Future<void> getAllPost(String idUser) async {
    _listPost = [];
    List? posts = await postRepository.getAllPost(idUser);
    _listPost!.addAll(posts!.map((item) => Post.fromMap(item)).toList());
    notifyListeners();
  }
  Future<void> getPost(String id, String idUser) async {
    String postApi = await postRepository.getPost(id, idUser);
    // Chuyển đổi chuỗi JSON thành Map<String, dynamic>
    Map<String, dynamic> postMap = jsonDecode(postApi);

    // Sử dụng hàm fromMap để tạo đối tượng Post từ Map
    _post = Post.fromMap(postMap);
    notifyListeners();
  }
  Future<void> addPostWithImages(Post post, List<File> images) async {
    try {
      // Step 1: Gửi request để thêm post và nhận về id của post
      String postApi = await postRepository.addPost(post);
      Map<String, dynamic> postMap = jsonDecode(postApi);
      Post? postAdd = Post.fromMap(postMap);
      _post = Post.fromMap(postMap);
      print("Post add:$postAdd");
      // notifyListeners();

      // Step 2: Nếu post được thêm thành công, thì upload ảnh
      if (images.isNotEmpty) {
        // print('Number of images: ${images.length}');
        String response = await postRepository.uploadImages(images, postAdd.id);
        Map<String, dynamic> postMapImage = jsonDecode(response);
        _post = Post.fromMap(postMapImage);
        await Future.delayed(const Duration(seconds: 1));
        await postRepository.getPost(postAdd.id, post.author.id);
        // print("_post: " + _post.toString());

      }
      _listPost.add(_post!);
      notifyListeners();

    } catch (e) {
      print('Error: $e');
      // Xử lý lỗi nếu có
    }
  }
  Future<void> getAllPostPersonal(String idUser) async {
    _listPostPersonal = [];
    List? posts = await postRepository.getAllPostPersonal(idUser);
    _listPostPersonal.addAll(posts!.map((item) => Post.fromMap(item)).toList());
    notifyListeners();
  }
  Future<void> updatePostWithImages(Post post, List<File> images) async {
    try {
      // Step 1: Gửi request để thêm post và nhận về id của post
      String postApi = await postRepository.updatePost(post);
      Map<String, dynamic> postMap = jsonDecode(postApi);
      Post? postAdd = Post.fromMap(postMap);
      _post = Post.fromMap(postMap);
      print("Post edit:$postAdd");
      // notifyListeners();

      // Step 2: Nếu post được thêm thành công, thì upload ảnh
      if (images.isNotEmpty) {
        // print('Number of images: ${images.length}');
        String response = await postRepository.editUploadImages(images, postAdd.id);
        Map<String, dynamic> postMapImage = jsonDecode(response);
        _post = Post.fromMap(postMapImage);

      }
      notifyListeners();

    } catch (e) {
      print('Error: $e');
      // Xử lý lỗi nếu có
    }
  }
  Future<void> deletePost(String id) async {
    String postApi = await postRepository.deletePost(id);
    int index = _listPostPersonal.indexWhere((element) => element.id == id);
    if (index != -1) {
      _listPostPersonal.removeAt(index);
    }
    notifyListeners();
  }

}