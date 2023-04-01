part of 'chart_screen_bloc.dart';

abstract class ChartScreenState extends Equatable {
  const ChartScreenState();
  
  @override
  List<Object> get props => [];
}

class ChartScreenInitial extends ChartScreenState {}

class ChartScreenSucces extends ChartScreenState{
  final List<ChartData> points;

  const ChartScreenSucces(this.points);
  @override
  List<Object> get props => [points];
}

class ChartScreenError extends ChartScreenState{
  final String massege;

  const ChartScreenError(this.massege);
  @override
  // TODO: implement props
  List<Object> get props => [massege];

}
