import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'chart_setting_event.dart';
part 'chart_setting_state.dart';

class ChartSettingBloc extends Bloc<ChartSettingEvent, ChartSettingState> {
  ChartSettingBloc() : super(ChartSettingInitial()) {
    on<ChartSettingEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
