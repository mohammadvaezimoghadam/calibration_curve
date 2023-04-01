import 'package:bloc/bloc.dart';
import 'package:calibration_curve/data/repo/chartData_repo.dart';
import 'package:equatable/equatable.dart';

import '../../../data/chartData.dart';

part 'chart_screen_event.dart';
part 'chart_screen_state.dart';

class ChartScreenBloc extends Bloc<ChartScreenEvent, ChartScreenState> {
  final IChartDataRepo repo;
  ChartScreenBloc(this.repo) : super(ChartScreenInitial()) {
    on<ChartScreenEvent>((event, emit) async {
      if (event is ChartScreenStarded) {
        try {
          final points = await repo.getAll();
          emit(ChartScreenSucces(points));
        } catch (e) {
          emit(ChartScreenError('خطا هنگام دریاف داده ها'));
        }
      }
    });
  }
}
