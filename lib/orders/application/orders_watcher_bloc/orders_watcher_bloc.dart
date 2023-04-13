import 'dart:async';

import 'package:dartz/dartz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

import '../../domain/orderDetails.dart';
import '../../domain/ordersFacade.dart';
import '../../domain/ordersFailure.dart';


part 'orders_watcher_bloc.freezed.dart';
part 'orders_watcher_event.dart';
part 'orders_watcher_state.dart';

@injectable
class OrdersWatcherBloc
    extends Bloc<OrdersWatcherEvent, OrdersWatcherState> {
  final IOrdersFacade _cardRepository;

  OrdersWatcherBloc(this._cardRepository)
      : super(const OrdersWatcherState.initial());

  StreamSubscription<Either<OrdersFailure, OrderDetailsList>>?
  _userStreamSubscription;
  @override
  Stream<OrdersWatcherState> mapEventToState(
      OrdersWatcherEvent event,
      ) async* {
    yield* event.map(
      watchAllStarted: (e) async* {
        yield const OrdersWatcherState.loadInProgress();
        await _userStreamSubscription?.cancel();
        _userStreamSubscription =
            _cardRepository.watchAll().listen((failureOrBookings) {
              add(OrdersWatcherEvent.bookingsReceived(failureOrBookings));
            });
      },
      bookingsReceived: (e) async* {
        yield e.failureOrBookings.fold(
              (f) => OrdersWatcherState.loadFailure(f),
              (bookings) => OrdersWatcherState.loadSuccess(bookings),

        );

      },
    );
  }

}
