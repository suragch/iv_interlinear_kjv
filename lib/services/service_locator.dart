import 'package:get_it/get_it.dart';
import 'package:iv_interlinear_kjv/services/database_helper.dart';

final getIt = GetIt.instance;

void setupServiceLocator() {
  getIt.registerLazySingleton<OtDatabaseHelper>(() => OtDatabaseHelper());
  getIt.registerLazySingleton<NtDatabaseHelper>(() => NtDatabaseHelper());
}
