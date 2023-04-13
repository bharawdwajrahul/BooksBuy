import 'package:freezed_annotation/freezed_annotation.dart';

part 'ordersFailure.freezed.dart';

@freezed
class OrdersFailure with _$OrdersFailure {
  const factory OrdersFailure.unexpected() = _Unexpected;
  const factory OrdersFailure.insufficientPermission() =
  _InsufficientPermission;
  const factory OrdersFailure.unableToUpdate() = _UnableToUpdate;
}