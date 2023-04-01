import 'package:bloc/bloc.dart';
import 'package:calibration_curve/data/chartData.dart';
import 'package:calibration_curve/data/repo/chartData_repo.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final IChartDataRepo repo;
  HomeBloc(this.repo) : super(HomeInitial()) {
    on<HomeEvent>((event, emit) async {
      emit(HomeLoading());
      if (event is HomeStarted) {
        emit(HomeLoading());
        

        try {
          final dataList = await repo.getAll();
          if (dataList.isNotEmpty) {
            emit(HomeSuccess(dataList));
          } else {
            emit(HomeEmptyState());
          }
        } catch (e) {
          emit(HomeError('خطا در دریافت داده ها'));
        }
      } else if (event is HomeDeletAll) {
        await repo.deletAll();
        emit(HomeEmptyState());
      } else if (event is HomeAddData) {
        final data =await ChartData(event.xvalue, event.yvalue);

        await repo.creatOrUpdate(data);
      }else if(event is HomeDeleteItem){
        await repo.delete(event.data);
      }
    });
  }
}
