part of 'orders_watcher_bloc.dart';

@freezed
class OrdersWatcherEvent with _$OrdersWatcherEvent {
  const factory OrdersWatcherEvent.watchAllStarted() = _WatchAllStarted;
  const factory OrdersWatcherEvent.bookingsReceived(
      Either<OrdersFailure, OrderDetailsList> failureOrBookings,
      ) = _BookingsReceived;
}