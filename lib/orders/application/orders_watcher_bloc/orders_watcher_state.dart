part of 'orders_watcher_bloc.dart';


@freezed
class OrdersWatcherState with _$OrdersWatcherState {
  const factory OrdersWatcherState.initial() = _Initial;
  const factory OrdersWatcherState.loadInProgress() = _LoadInProgress;
  const factory OrdersWatcherState.loadSuccess(OrderDetailsList orderDetailsList) =_LoadSuccess;
  const factory OrdersWatcherState.loadFailure(OrdersFailure ordersFailure) =_LoadFailure;
}