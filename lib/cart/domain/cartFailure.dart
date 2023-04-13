import 'package:freezed_annotation/freezed_annotation.dart';

part 'cartFailure.freezed.dart';

@freezed
class CartFailure with _$CartFailure {
  const factory CartFailure.unexpected() = _Unexpected;
  const factory CartFailure.insufficientPermission() =
  _InsufficientPermission;
  const factory CartFailure.unableToUpdate() = _UnableToUpdate;
}