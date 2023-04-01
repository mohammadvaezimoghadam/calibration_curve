import 'package:calibration_curve/data/chartData.dart';
import 'package:calibration_curve/data/repo/chartData_repo.dart';
import 'package:calibration_curve/ui/home/bloc/home_bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatelessWidget {
  final TextEditingController _xtextEditingController = TextEditingController();
  final TextEditingController _ytextEditingController = TextEditingController();

  HomeScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    return BlocProvider(
      create: (context) => HomeBloc(context.read<ChatrDataLocalRepo>()),
      child: Scaffold(
        backgroundColor: themeData.colorScheme.onBackground,
        body: Padding(
          padding: const EdgeInsets.only(top: 36),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'داده های استاندارد',
                    style: themeData.textTheme.headline6,
                  ),
                ],
              ),
              const SizedBox(
                height: 12,
              ),
              Expanded(
                  flex: 5,
                  child: Consumer<ChatrDataLocalRepo>(
                    builder: (context, value, child) {
                      context.read<HomeBloc>().add(HomeStarted());
                      _xtextEditingController.clear();
                      _ytextEditingController.clear();
                      return Stack(
                        children: [
                          BlocBuilder<HomeBloc, HomeState>(
                            builder: (context, state) => state is HomeSuccess
                                ? _ChartDataList(
                                    themeData: themeData,
                                    items: state.dataList,
                                    deleteBtnClicked: (ChartData data) {
                                      context
                                          .read<HomeBloc>()
                                          .add(HomeDeleteItem(data));
                                    },
                                    editBtnClicked: () {},
                                  )
                                : state is HomeLoading || state is HomeInitial
                                    ? const Center(
                                        child: CupertinoActivityIndicator(),
                                      )
                                    : state is HomeError
                                        ? Center(
                                            child: Text(state.errorMassaeg),
                                          )
                                        : state is HomeEmptyState
                                            ? Center(
                                                child: Center(
                                                  child: Text(
                                                    "داده هارا وارد کنید",
                                                    style: themeData
                                                        .textTheme.bodyText2,
                                                  ),
                                                ),
                                              )
                                            : throw Exception(),
                          ),
                          Positioned(
                            bottom: 0,
                            right: 0,
                            left: 0,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  Expanded(
                                    child: AddTextFieldItem(
                                      themeData: themeData,
                                      label: "X",
                                      controller: _xtextEditingController,
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 12,
                                  ),
                                  Expanded(
                                    child: AddTextFieldItem(
                                      themeData: themeData,
                                      label: "Y",
                                      controller: _ytextEditingController,
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 12,
                                  ),
                                  InkWell(
                                    onTap: () {
                                      context.read<HomeBloc>().add(HomeAddData(
                                          double.parse(
                                              _xtextEditingController.text),
                                          double.parse(
                                              _ytextEditingController.text)));
                                    },
                                    borderRadius: BorderRadius.circular(10),
                                    child: Container(
                                      height: 60,
                                      width: 60,
                                      decoration: BoxDecoration(
                                        color: themeData.colorScheme.secondary,
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: Center(
                                        child: Icon(
                                          CupertinoIcons.plus,
                                          size: 28,
                                          color:
                                              themeData.colorScheme.onSecondary,
                                        ),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  ))
            ],
          ),
        ),
      ),
    );
  }
}

class AddTextFieldItem extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  const AddTextFieldItem({
    super.key,
    required this.themeData,
    required this.label,
    required this.controller,
  });

  final ThemeData themeData;

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      padding: EdgeInsets.fromLTRB(4, 12, 4, 12),
      decoration: BoxDecoration(
          color: themeData.colorScheme.primary,
          borderRadius: BorderRadius.circular(10)),
      height: 60,
      width: 70,
      child: TextField(
        maxLength: 12,
        keyboardType: TextInputType.number,
        controller: controller,
        style: themeData.textTheme.bodyText2,
        cursorColor: Colors.white,
        decoration: InputDecoration(
            counterStyle: themeData.textTheme.caption!.copyWith(fontSize: 8),
            contentPadding: EdgeInsets.all(8),
            label: Text(
              'مقدار ${label}:',
              style: themeData.textTheme.caption!.copyWith(fontSize: 14),
            )),
      ),
    );
  }
}

class _ChartDataList extends StatelessWidget {
  final Function(ChartData data) deleteBtnClicked;
  final Function() editBtnClicked;
  final List<ChartData> items;
  final ThemeData themeData;
  const _ChartDataList({
    super.key,
    required this.themeData,
    required this.items,
    required this.deleteBtnClicked,
    required this.editBtnClicked,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: ListView.builder(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.only(bottom: 75),
          itemCount: items.length,
          itemBuilder: (context, index) {
            return _CHartDataListItem(
              xTitle: "X",
              yTitle: "Y",
              item: items[index],
              themeData: themeData,
              index: index,
              deleteBtnClicked: (ChartData data) {
                deleteBtnClicked(data);
              },
              editBtnClicked: () {
                editBtnClicked();
              },
            );
          }),
    );
  }
}

class _CHartDataListItem extends StatelessWidget {
  final Function(ChartData data) deleteBtnClicked;
  final Function() editBtnClicked;
  final String xTitle;
  final String yTitle;
  final int index;
  final ChartData item;
  final ThemeData themeData;
  const _CHartDataListItem({
    super.key,
    required this.themeData,
    required this.index,
    required this.xTitle,
    required this.yTitle,
    required this.item,
    required this.deleteBtnClicked,
    required this.editBtnClicked,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 12, left: 12, bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text("شماره: ${index + 1}"),
          const SizedBox(
            width: 12,
          ),
          Expanded(
            child: _ChartDataInfoItem(
                themeData: themeData, xTitle: xTitle, item: item.x),
          ),
          const SizedBox(
            width: 8,
          ),
          Expanded(
            child: _ChartDataInfoItem(
                themeData: themeData, xTitle: yTitle, item: item.y),
          ),
          const SizedBox(
            width: 8,
          ),
          _EditAndDeleteIcon(
            themeData: themeData,
            onTap: () {
              deleteBtnClicked(item);
            },
            icon: CupertinoIcons.trash,
          ),
          const SizedBox(
            width: 4,
          ),
          _EditAndDeleteIcon(
            themeData: themeData,
            onTap: () {
              editBtnClicked();
            },
            icon: CupertinoIcons.info_circle,
          ),
        ],
      ),
    );
  }
}

class _EditAndDeleteIcon extends StatelessWidget {
  final Function() onTap;
  final IconData icon;
  final ThemeData themeData;
  const _EditAndDeleteIcon({
    super.key,
    required this.themeData,
    required this.onTap,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: 34,
        height: 34,
        decoration: BoxDecoration(
            color: themeData.colorScheme.secondary.withOpacity(0.9),
            borderRadius: BorderRadius.circular(8)),
        child: Center(
          child: Icon(
            icon,
            size: 18,
            color: themeData.colorScheme.onSecondary,
          ),
        ),
      ),
    );
  }
}

class _ChartDataInfoItem extends StatelessWidget {
  final ThemeData themeData;
  final String xTitle;
  final double item;
  const _ChartDataInfoItem({
    super.key,
    required this.themeData,
    required this.xTitle,
    required this.item,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(width: 0.5, color: themeData.colorScheme.primary),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            ' $xTitle:',
            overflow: TextOverflow.ellipsis,
            style: themeData.textTheme.bodyText2,
          ),
          const SizedBox(
            width: 8,
          ),
          Expanded(
            child: Text(
              overflow: TextOverflow.ellipsis,
              item.toString(),
              style: themeData.textTheme.bodyText2,
            ),
          )
        ],
      ),
    );
  }
}
