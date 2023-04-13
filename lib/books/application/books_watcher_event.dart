part of 'books_watcher_bloc.dart';

@freezed
 class BooksWatcherEvent with _$BooksWatcherEvent {
  const factory BooksWatcherEvent.watchAllStarted() = _WatchAllStarted;
  const factory BooksWatcherEvent.bookingsReceived(
      Either<BooksFailure, BookDetailsList> failureOrBookings,
      ) = _BookingsReceived;
}
