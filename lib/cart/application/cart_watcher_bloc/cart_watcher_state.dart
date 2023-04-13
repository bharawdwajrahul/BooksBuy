part of 'cart_watcher_bloc.dart';


@freezed
class CartWatcherState with _$CartWatcherState {
  const factory CartWatcherState.initial() = _Initial;
  const factory CartWatcherState.loadInProgress() = _LoadInProgress;
  const factory CartWatcherState.loadSuccess(CartDetailsList cartDetailsList) =_LoadSuccess;
  const factory CartWatcherState.loadFailure(CartFailure cartFailure) =_LoadFailure;
}


