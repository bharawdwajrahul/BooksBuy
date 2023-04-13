import 'dart:async';

import 'package:dartz/dartz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:software/books/domain/bookDetails.dart';
import 'package:software/books/domain/booksFailure.dart';
import 'package:software/books/domain/books_facade.dart';

part 'books_watcher_bloc.freezed.dart';
part 'books_watcher_event.dart';
part 'books_watcher_state.dart';

@injectable
class BooksWatcherBloc
    extends Bloc<BooksWatcherEvent, BooksWatcherState> {
  final IBooksFacade _cardRepository;

  BooksWatcherBloc(this._cardRepository)
      : super(const BooksWatcherState.initial());

  StreamSubscription<Either<BooksFailure, BookDetailsList>>?
      _userStreamSubscription;
  @override
  Stream<BooksWatcherState> mapEventToState(
    BooksWatcherEvent event,
  ) async* {
    yield* event.map(
      watchAllStarted: (e) async* {
        yield const BooksWatcherState.loadInProgress();
        await _userStreamSubscription?.cancel();
        _userStreamSubscription =
            _cardRepository.watchAll().listen((failureOrBookings) {
          add(BooksWatcherEvent.bookingsReceived(failureOrBookings));
          print('inside watcher----------->');
        });
      },
      bookingsReceived: (e) async* {
        yield e.failureOrBookings.fold(
          (f) => BooksWatcherState.loadFailure(f),
          (bookings) => BooksWatcherState.loadSuccess(bookings),

        );
        print('inside watcher-----22222222------>');

      },
    );
  }

}
