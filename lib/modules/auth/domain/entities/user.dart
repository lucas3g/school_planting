import 'package:school_planting/core/domain/vos/text_vo.dart';

class User {
  TextVO _id;
  TextVO _email;
  TextVO _name;
  TextVO? _imageUrl;

  TextVO get id => _id;
  void setId(String id) => _id = TextVO(id);

  TextVO get email => _email;
  void setEmail(String email) => _email = TextVO(email);

  TextVO get name => _name;
  void setName(String name) => _name = TextVO(name);

  TextVO get imageUrl => _imageUrl ?? TextVO('');
  void setImageUrl(String imageUrl) => _imageUrl = TextVO(imageUrl);

  User({
    required String id,
    required String email,
    required String name,
    String? imageUrl,
  }) : _id = TextVO(id),
       _email = TextVO(email),
       _name = TextVO(name),
       _imageUrl = imageUrl != null ? TextVO(imageUrl) : null;
}
