import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stacked_services/stacked_services.dart';

@module
abstract class ThirdPartyServicesModule {
  @lazySingleton
  NavigationService get navigationService;

  @lazySingleton
  DialogService get dialogService;

  @lazySingleton
  SnackbarService get snackbarService;

  @preResolve
  Future<SharedPreferences> get prefs => SharedPreferences.getInstance();
/*
  @preResolve
  Future<SharedPreferences> get prefs => SharedPreferences.getInstance();

  @preResolve
  SocketManager get socketManager => SocketManager();

  @lazySingleton
  FileService get fileService;*/
}
