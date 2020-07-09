import 'package:flutter_chat_demo/services/firestore_service.dart';
import 'package:flutter_chat_demo/user/entity/user.dart';
import 'package:flutter_chat_demo/user/usecases/IUserRepository.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class UserRepositoryImpl implements IUserRepository {
  final FirebaseDbService _firebaseDbService;

  UserRepositoryImpl(this._firebaseDbService);

  @override
  Stream<void> authenticate(User user) {
    return _firebaseDbService.authenticate(user.toJson());
  }
}
