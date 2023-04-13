// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:get_it/get_it.dart' as _i1;
import 'package:injectable/injectable.dart' as _i2;

import 'books/application/books_watcher_bloc.dart' as _i10;
import 'books/domain/books_facade.dart' as _i3;
import 'books/infrastructure/books_repositery.dart' as _i4;
import 'cart/application/cart_watcher_bloc/cart_watcher_bloc.dart' as _i11;
import 'cart/domain/cart_facade.dart' as _i5;
import 'cart/infrastructure/cart_repository.dart' as _i6;
import 'orders/application/orders_watcher_bloc/orders_watcher_bloc.dart' as _i9;
import 'orders/domain/ordersFacade.dart' as _i7;
import 'orders/infrastructure/orders_repository.dart'
    as _i8; // ignore_for_file: unnecessary_lambdas

// ignore_for_file: lines_longer_than_80_chars
/// initializes the registration of provided dependencies inside of [GetIt]
_i1.GetIt $initGetIt(
  _i1.GetIt get, {
  String? environment,
  _i2.EnvironmentFilter? environmentFilter,
}) {
  final gh = _i2.GetItHelper(
    get,
    environment,
    environmentFilter,
  );
  gh.lazySingleton<_i3.IBooksFacade>(() => _i4.FirebaseAuthFacade());
  gh.lazySingleton<_i5.ICartFacade>(() => _i6.FirebaseAuthFacade());
  gh.lazySingleton<_i7.IOrdersFacade>(() => _i8.FirebaseAuthFacade());
  gh.factory<_i9.OrdersWatcherBloc>(
      () => _i9.OrdersWatcherBloc(get<_i7.IOrdersFacade>()));
  gh.factory<_i10.BooksWatcherBloc>(
      () => _i10.BooksWatcherBloc(get<_i3.IBooksFacade>()));
  gh.factory<_i11.CartWatcherBloc>(
      () => _i11.CartWatcherBloc(get<_i5.ICartFacade>()));
  return get;
}
