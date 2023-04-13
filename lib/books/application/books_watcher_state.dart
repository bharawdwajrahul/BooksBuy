part of 'books_watcher_bloc.dart';


@freezed
 class BooksWatcherState with _$BooksWatcherState {
  const factory BooksWatcherState.initial() = _Initial;
  const factory BooksWatcherState.loadInProgress() = _LoadInProgress;
  const factory BooksWatcherState.loadSuccess(BookDetailsList bookDetailsList) =_LoadSuccess;
  const factory BooksWatcherState.loadFailure(BooksFailure booksFailure) =_LoadFailure;
}


