import 'package:meta/meta.dart';

@immutable
class User {
  final String name, avatarUrl;
  final Map<String, dynamic> extras;

  User({
    @required this.name,
    this.avatarUrl,
    this.extras,
  });

  @override
  String toString() => 'QUser('
      ' name=$name,'
      ' avatarUrl=$avatarUrl,'
      ' extras=$extras'
      ')';

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      name: json['name'] as String,
      avatarUrl: json['avatar_url'] as String ?? "",
      extras: json['extras'] as Map<String, dynamic> ?? {},
    );
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
        'name': name,
        'avatar_url': avatarUrl ?? "",
        'extras': extras ?? {},
      };
}
