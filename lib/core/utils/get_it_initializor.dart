import 'package:get_it/get_it.dart';
import 'package:phone_book/data/repository/user_repository_impl.dart';
import 'package:phone_book/data/service/phonebook_service_impl.dart';
import 'package:phone_book/domain/repository/user_repository.dart';
import 'package:phone_book/domain/service/phonebook_service.dart';

GetIt locator = GetIt.instance;

void initLocator() {
  locator.registerLazySingleton<PhonebookService>(() => PhonebookServiceImpl());
  locator.registerLazySingleton<UserRepository>(() => UserRepositoryImpl());
}
