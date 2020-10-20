import 'package:flutter_chat_demo/services/firebase_db_service.dart';
import 'package:flutter_chat_demo/services/firestore_service.dart';
import 'package:flutter_chat_demo/user/entity/user.dart';
import 'package:flutter_chat_demo/user/usecases/IUserRepository.dart';

class UserRepositoryImpl implements IUserRepository {
  final FirebaseDbService _firebaseDbService;
  final FirestoreService _firestoreService;

  UserRepositoryImpl(this._firebaseDbService, this._firestoreService);

  @override
  Stream<void> authenticate(User user) {
    return _firestoreService.authenticate(user.toJson());
//    return _firebaseDbService.authenticate(user.toJson());
  }
}
