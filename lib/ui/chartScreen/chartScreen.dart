import 'package:calibration_curve/data/repo/chartData_repo.dart';
import 'package:calibration_curve/ui/chartScreen/bloc/chart_screen_bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../../data/chartData.dart';

class ChartScreen extends StatelessWidget {
  const ChartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    return BlocProvider<ChartScreenBloc>(
      create: (context) => ChartScreenBloc(context.read<ChatrDataLocalRepo>()),
      child: Scaffold(
        body: Center(
            child: Container(
          color: themeData.colorScheme.primary,
          child: SizedBox(
              width: MediaQuery.of(context).size.width,
              child: Padding(
                padding: const EdgeInsets.only(top: 12, right: 12),
                child: Consumer<ChatrDataLocalRepo>(
                  builder: (context, value, child) {
                    context.read<ChartScreenBloc>().add(ChartScreenStarded());
                    return BlocBuilder<ChartScreenBloc, ChartScreenState>(
                      builder: (context, state) => state is ChartScreenSucces
                          ? _Chart(
                              themeData: themeData,
                              points: state.points,
                            )
                          : state is ChartScreenError
                              ? Center(
                                  child: Text(
                                    state.massege,
                                    style: themeData.textTheme.bodyMedium,
                                  ),
                                )
                              : state is ChartScreenInitial
                                  ? const Center(
                                      child: CupertinoActivityIndicator(),
                                    )
                                  : throw Exception(),
                    );
                  },
                ),
              )),
        )),
      ),
    );
  }
}

class _Chart extends StatelessWidget {
  final List<ChartData> points;
  final ThemeData themeData;
  const _Chart({
    super.key,
    required this.themeData,
    required this.points,
  });

  @override
  Widget build(BuildContext context) {
    return SfCartesianChart(
      palette: <Color>[Color(0xff66BB6A).withOpacity(0.9)],
      backgroundColor: themeData.colorScheme.primary,
      plotAreaBorderColor: Colors.transparent,
      primaryXAxis: NumericAxis(
          labelStyle: themeData.textTheme.bodyText2,
          majorGridLines: MajorGridLines(
              color: themeData.textTheme.caption!.color!.withOpacity(0.5),
              dashArray: [1, 2]),
          labelAlignment: LabelAlignment.start,
          minimum: 0,
          maximum: 20,
          interactiveTooltip: const InteractiveTooltip(enable: true)),
      primaryYAxis: NumericAxis(
          labelStyle: themeData.textTheme.bodyText2,
          majorGridLines: MajorGridLines(
              color: themeData.textTheme.caption!.color!.withOpacity(0.5),
              dashArray: [1, 2]),
          labelAlignment: LabelAlignment.start,
          minimum: 0,
          maximum: 20,
          interactiveTooltip: const InteractiveTooltip(enable: true)),
      series: <ChartSeries>[
        SplineSeries<ChartData, double>(
            markerSettings: MarkerSettings(isVisible: true),
            dataLabelSettings: DataLabelSettings(
                isVisible: false, color: themeData.textTheme.caption!.color),
            dataSource: points,
            xValueMapper: (ChartData data, _) => data.x,
            yValueMapper: (ChartData data, _) => data.y,
            trendlines: <Trendline>[
              Trendline(
                  type: TrendlineType.linear,
                  color: themeData.colorScheme.secondary,
                  width: 1,
                  dashArray: <double>[3, 3],
                  name: 'معادله خطی',
                  enableTooltip: true)
            ])
      ],
    );
  }
}
 