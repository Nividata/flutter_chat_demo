import 'package:get_it/get_it.dart';

import 'locator.iconfig.dart';

final locator = GetIt.instance;

@injectableInit
Future<void> setupLocator() => $initGetIt(locator);