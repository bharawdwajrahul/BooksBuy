part of 'cart_watcher_bloc.dart';

@freezed
class CartWatcherEvent with _$CartWatcherEvent {
  const factory CartWatcherEvent.watchAllStarted(String userID) = _WatchAllStarted;
  const factory CartWatcherEvent.bookingsReceived(
      Either<CartFailure, CartDetailsList> failureOrBookings,
      ) = _BookingsReceived;
}
