part of 'home_bloc.dart';

abstract class HomeState extends Equatable {
  const HomeState();

  @override
  List<Object> get props => [];
}

class HomeInitial extends HomeState {}

class HomeLoading extends HomeState {}

class HomeSuccess extends HomeState {
  final List<ChartData> dataList;

  const HomeSuccess(this.dataList);
  @override
  List<Object> get props => [dataList];
}

class HomeEmptyState extends HomeState {}

class HomeError extends HomeState{
  final String errorMassaeg;

  const HomeError(this.errorMassaeg);
  @override
  List<Object> get props => [errorMassaeg];
}
