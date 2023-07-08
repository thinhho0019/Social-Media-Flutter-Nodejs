
import 'package:equatable/equatable.dart';
class User extends Equatable{
  const User({
    required this.id,
    required this.name,
    required this.email,
    required this.photoUrl
});
  final String id;
  final String name;
  final String email;
  final String photoUrl;

  @override
  List<Object?> get props => throw UnimplementedError();

}