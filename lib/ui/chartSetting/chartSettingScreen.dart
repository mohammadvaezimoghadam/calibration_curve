import 'package:calibration_curve/ui/chartSetting/bloc/chart_setting_bloc.dart';
import 'package:calibration_curve/ui/home/homeScreen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../Trend line equation.dart';
import '../../main.dart';

double slope = findSlope(chartdataPoints);
double slope2 = double.parse((slope).toStringAsFixed(3));
double intercept = findIntercept(chartdataPoints, slope);
double intercept2 = double.parse((intercept).toStringAsFixed(3));

class ChartSettingScreen extends StatelessWidget {
  final TextEditingController controller = TextEditingController();
  ChartSettingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    return BlocProvider<ChartSettingBloc>(
      create: (context) => ChartSettingBloc(),
      child: Scaffold(
        backgroundColor: themeData.colorScheme.onBackground,
        body: Padding(
          padding: const EdgeInsets.fromLTRB(8, 36, 8, 8),
          child: BlocBuilder<ChartSettingBloc, ChartSettingState>(
            builder: (context, state) {
              return Stack(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(12, 8, 12, 60),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('معادله خط روند:'),
                            Text('Y = ${slope2} X+ ${intercept2}'),
                          ],
                        ),
                        const Divider(),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'نمایش خط روند:',
                              style: themeData.textTheme.bodyMedium,
                            ),
                            Container(
                              width: 18,
                              height: 18,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(4.5),
                                border: Border.all(
                                    color: themeData.colorScheme.onPrimary),
                              ),
                              child: Center(
                                child: null,
                              ),
                            )
                          ],
                        ),
                        const Divider(),
                      ],
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: Row(
                      children: [
                        Expanded(
                          child: AddTextFieldItem(
                              themeData: themeData,
                              label: "مجهول را وارد کنید",
                              controller: controller),
                        ),
                        SizedBox(
                          width: 12,
                        ),
                        InkWell(
                          onTap: () {},
                          borderRadius: BorderRadius.circular(10),
                          child: Container(
                            height: 60,
                            width: 60,
                            decoration: BoxDecoration(
                              color: themeData.colorScheme.secondary,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Center(
                              child: Text(
                                'نمایش',
                                style: themeData.textTheme.bodyMedium,
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
