// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

import 'package:flutter_chat_demo/services/authentication_service.dart';
import 'package:flutter_chat_demo/services/third_party_services_module.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:flutter_chat_demo/services/firestore_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_chat_demo/services/shared_preferences_service.dart';
import 'package:flutter_chat_demo/user/usecases/UserRepositoryImpl.dart';
import 'package:get_it/get_it.dart';

Future<void> $initGetIt(GetIt g, {String environment}) async {
  final thirdPartyServicesModule = _$ThirdPartyServicesModule();
  g.registerLazySingleton<AuthenticationService>(() => AuthenticationService());
  g.registerLazySingleton<DialogService>(
      () => thirdPartyServicesModule.dialogService);
  g.registerLazySingleton<FirebaseDbService>(() => FirebaseDbService());
  g.registerLazySingleton<NavigationService>(
      () => thirdPartyServicesModule.navigationService);
  final sharedPreferences = await thirdPartyServicesModule.prefs;
  g.registerFactory<SharedPreferences>(() => sharedPreferences);
  g.registerLazySingleton<SharedPreferencesService>(
      () => SharedPreferencesService(g<SharedPreferences>()));
  g.registerLazySingleton<SnackbarService>(
      () => thirdPartyServicesModule.snackbarService);
  g.registerLazySingleton<UserRepositoryImpl>(
      () => UserRepositoryImpl(g<FirebaseDbService>()));
}

class _$ThirdPartyServicesModule extends ThirdPartyServicesModule {
  @override
  DialogService get dialogService => DialogService();
  @override
  NavigationService get navigationService => NavigationService();
  @override
  SnackbarService get snackbarService => SnackbarService();
}
