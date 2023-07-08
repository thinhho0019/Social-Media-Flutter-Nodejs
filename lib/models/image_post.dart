// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class imagePost {
  final String id;
  final String image_url;
  final String size_image;
  

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'image_url': image_url,
      'size_image': size_image,
    };
  }

  imagePost({ required this.id,required this.image_url,required this.size_image});
  factory imagePost.fromMap(Map<String,dynamic> map){
    return imagePost(id: map['_id']??"",
     image_url: map['image_url']??"",
      size_image:  map['size_image'].toString()??"");
  }
  imagePost copyWith(String? id,String? image_url,String? size_image){
    return imagePost(id: id??this.id, image_url: image_url??this.image_url, size_image: size_image??this.size_image);
  }
}
