import 'package:freezed_annotation/freezed_annotation.dart';

part 'booksFailure.freezed.dart';

@freezed
class BooksFailure with _$BooksFailure {
  const factory BooksFailure.unexpected() = _Unexpected;
  const factory BooksFailure.insufficientPermission() =
  _InsufficientPermission;
  const factory BooksFailure.unableToUpdate() = _UnableToUpdate;
}