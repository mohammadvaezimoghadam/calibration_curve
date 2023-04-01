part of 'home_bloc.dart';

abstract class HomeEvent extends Equatable {
  const HomeEvent();

  @override
  List<Object> get props => [];
}
class HomeStarted extends HomeEvent{

}

class HomeDeletAll extends HomeEvent{
  
}

class HomeAddData extends HomeEvent{
  final double xvalue;
  final double yvalue;

  const HomeAddData(this.xvalue, this.yvalue);
  @override
  // TODO: implement props
  List<Object> get props => [xvalue,yvalue];
}

class HomeDeleteItem extends HomeEvent{
  final ChartData data;

  const HomeDeleteItem(this.data);
  @override
  // TODO: implement props
  List<Object> get props => [data];
}
