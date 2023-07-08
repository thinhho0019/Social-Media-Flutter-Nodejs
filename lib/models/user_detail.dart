// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class userDetail {
   final String id;
   final String bio;
   final String job;
   final String address_from;
   final String address_live;
   final String birthday;
   final String studying;
   final String background_image;

  userDetail( {
   required this.id,required this.address_from,required this.address_live,
   required this.birthday,required this.studying,required this.background_image,
    required this.bio,required this.job,
  }
    );
   

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'address_from': address_from,
      'address_live': address_live,
      'birthday': birthday,
      'studying': studying,
      'background_image': background_image,
      'bio':bio,
      'job':job
    };
  }

  factory userDetail.fromMap(Map<String, dynamic> map) {
    return userDetail(
      id: map['_id']??"",
      address_from: map['address_from']??"",
      address_live: map['address_live']??"",
      birthday: map['birthday']??"",
      studying: map['studying'] ??"",
      background_image: map['background_image']??"",
      bio:map['bio']??"",
      job:map['job']??""
    );
  }

  

  userDetail copyWith({
    String? id,
    String? bio,
    String? job,
    String? address_from,
    String? address_live,
    String? birthday,
    String? studying,
    String? background_image,
  }) {
    return userDetail(
      id: id ?? this.id,
      bio: bio ?? this.bio,
      job: job ?? this.job,
      address_from: address_from ?? this.address_from,
      address_live: address_live ?? this.address_live,
      birthday: birthday ?? this.birthday,
      studying: studying ?? this.studying,
      background_image: background_image ?? this.background_image,
    );
  }
}
