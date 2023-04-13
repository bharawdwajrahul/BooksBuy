import 'dart:async';

import 'package:dartz/dartz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

import '../../domain/cartDetails.dart';
import '../../domain/cartFailure.dart';
import '../../domain/cart_facade.dart';

part 'cart_watcher_bloc.freezed.dart';
part 'cart_watcher_event.dart';
part 'cart_watcher_state.dart';

@injectable
class CartWatcherBloc
    extends Bloc<CartWatcherEvent, CartWatcherState> {
  final ICartFacade _cardRepository;

  CartWatcherBloc(this._cardRepository)
      : super(const CartWatcherState.initial());

  StreamSubscription<Either<CartFailure, CartDetailsList>>?
  _userStreamSubscription;
  @override
  Stream<CartWatcherState> mapEventToState(
      CartWatcherEvent event,
      ) async* {
    yield* event.map(
      watchAllStarted: (e) async* {
        yield const CartWatcherState.loadInProgress();
        await _userStreamSubscription?.cancel();
        _userStreamSubscription =
            _cardRepository.watchAll(e.userID).listen((failureOrBookings) {
              add(CartWatcherEvent.bookingsReceived(failureOrBookings));
              print('inside watcher----------->');
            });
      },
      bookingsReceived: (e) async* {
        yield e.failureOrBookings.fold(
              (f) => CartWatcherState.loadFailure(f),
              (bookings) => CartWatcherState.loadSuccess(bookings),

        );

      },
    );
  }

}
