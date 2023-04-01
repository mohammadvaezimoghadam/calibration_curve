import 'package:calibration_curve/data/repo/chartData_repo.dart';
import 'package:calibration_curve/theme.dart';
import 'package:calibration_curve/ui/chartScreen/chartScreen.dart';
import 'package:calibration_curve/ui/effect/effectSettingScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';


import 'data/chartData.dart';
import 'ui/chartSetting/chartSettingScreen.dart';
import 'ui/home/homeScreen.dart';

void main() async {
  await Hive.initFlutter();
  Hive.registerAdapter(ChartDataAdapter());
  await Hive.openBox<ChartData>(boxName);
  runApp(ChangeNotifierProvider<ChatrDataLocalRepo>(
      create: (context) {
        return chartDataRepo;
      },
      child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    const defaultTextStyle = TextStyle(
        fontFamily: 'Vazir', color: LightThemeColors.primaryTextColor);
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
          textSelectionTheme: TextSelectionThemeData(
              cursorColor: LightThemeColors.onPrimaryColor,
              selectionColor: LightThemeColors.textSelectionColor,
              selectionHandleColor: LightThemeColors.textSelectionColor),
          inputDecorationTheme: const InputDecorationTheme(
            hintStyle: defaultTextStyle,
            border: OutlineInputBorder(
              borderSide: BorderSide.none,
            ),
          ),
          textTheme: const TextTheme(
              bodyText2: defaultTextStyle,
              headline6: defaultTextStyle,
              caption: TextStyle(
                  fontFamily: 'Vazir',
                  color: LightThemeColors.secondaryTextColor)),
          colorScheme:  ColorScheme.light(
              primary: LightThemeColors.primaryColor,
              onPrimary: LightThemeColors.onPrimaryColor,
              secondary: LightThemeColors.secondary,
              onSecondary: Colors.white,
              background: const Color(0xffF1F8E9),
              onBackground: const Color(0xff2a6655).withOpacity(0.5),
              surface: Colors.white)),
      home:
          Directionality(textDirection: TextDirection.rtl, child: MainScreen()),
    );
  }
}

List<ChartData> chartdataPoints = [
  ChartData(1, 1.08),
  ChartData(2, 1.68),
  ChartData(10, 13.30),
  ChartData(15, 14.20)
];

class BottomNavigation extends StatelessWidget {
  final Function(int index) onTap;
  final int selectedIndex;
  const BottomNavigation(
      {super.key, required this.onTap, required this.selectedIndex});

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    return Container(
      height: bttomNavigationHight,
      decoration: BoxDecoration(
        color: themeData.colorScheme.primary,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          BottomNavidationItem(
            title: 'داده ها',
            onTap: () {
              onTap(homeIndex);
            },
            isActive: selectedIndex == homeIndex,
            iconPathName: 'tableicon.svg',
          ),
          BottomNavidationItem(
            title: 'چارت',
            onTap: () {
              onTap(chartSettingIdex);
            },
            isActive: selectedIndex == chartSettingIdex,
            iconPathName: 'chartlineicon.svg',
          ),
          BottomNavidationItem(
            title: 'نمایش',
            onTap: () {
              onTap(effectSettingIndex);
            },
            isActive: selectedIndex == effectSettingIndex,
            iconPathName: 'brushicon.svg',
          ),
        ],
      ),
    );
  }
}

class BottomNavidationItem extends StatelessWidget {
  final String title;
  final Function() onTap;
  final bool isActive;
  final String iconPathName;
  const BottomNavidationItem(
      {super.key,
      required this.title,
      required this.onTap,
      required this.isActive,
      required this.iconPathName});

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    return InkWell(
      borderRadius: BorderRadius.circular(32.5),
      onTap: onTap,
      child: Container(
        height: MediaQuery.of(context).size.height,
        alignment: Alignment.center,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              title,
              style: themeData.textTheme.bodyMedium!.apply(
                  color: isActive
                      ? themeData.textTheme.bodyText2!.color
                      : themeData.textTheme.caption!.color!.withOpacity(0.7)),
            ),
            SizedBox(width: 5),
            SvgPicture.asset(
              'assets/img/icons/${iconPathName}',
              color: isActive
                  ? themeData.colorScheme.secondary
                  : themeData.colorScheme.secondary.withOpacity(0.5),
              width: 24,
              height: 24,
            )
          ],
        ),
      ),
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

const int homeIndex = 0;
const int chartSettingIdex = 1;
const int effectSettingIndex = 2;
const double bttomNavigationHight = 55;

class _MainScreenState extends State<MainScreen> {
  int selectedTabIndex = homeIndex;
  final List<int> _history = [];
  GlobalKey<NavigatorState> _homeKey = GlobalKey();
  GlobalKey<NavigatorState> _chartSettingKey = GlobalKey();
  GlobalKey<NavigatorState> _effectSettingKey = GlobalKey();
  late final map = {
    homeIndex: _homeKey,
    chartSettingIdex: _chartSettingKey,
    effectSettingIndex: _effectSettingKey,
  };
  Future<bool> _onWillPop() async {
    final NavigatorState currentSelectedTabNavigatorState =
        map[selectedTabIndex]!.currentState!;
    if (currentSelectedTabNavigatorState.canPop()) {
      currentSelectedTabNavigatorState.pop();
      return false;
    } else if (_history.isNotEmpty) {
      setState(() {
        selectedTabIndex = _history.last;
        _history.removeLast();
      });
      return false;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: WillPopScope(
        onWillPop: _onWillPop,
        child: Scaffold(
          backgroundColor: Theme.of(context).colorScheme.background,
          body: Column(
            children: [
              Container(
                margin: const EdgeInsets.only(left: 24, right: 24, top: 12),
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.width * 0.6,
                child: ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: ChartScreen()),
              ),
              const SizedBox(
                height: 12,
              ),
              Expanded(           
                
                child: Stack(
                  children: [
                    Positioned.fill(
                      top: bttomNavigationHight - 32.5,
                      child: ClipRRect(
                        borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(32),
                            topRight: Radius.circular(32)),
                        child: IndexedStack(
                          index: selectedTabIndex,
                          children: [
                            _navigator(_homeKey, homeIndex, HomeScreen()),
                            _navigator(_chartSettingKey, chartSettingIdex,
                                ChartSettingScreen()),
                            _navigator(_effectSettingKey, effectSettingIndex,
                                EffectSettingScreen()),
                          ],
                        ),
                      ),
                    ),
                    Positioned(
                      top: 0,
                      right: 55,
                      left: 55,
                      child: BottomNavigation(
                        onTap: (index) {
                          setState(() {
                            _history.remove(selectedTabIndex);
                            _history.add(selectedTabIndex);
                            selectedTabIndex = index;
                          });
                        },
                        selectedIndex: selectedTabIndex,
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _navigator(GlobalKey key, int index, Widget child) {
    return key.currentState == null && selectedTabIndex != index
        ? Container()
        : Navigator(
            key: key,
            onGenerateRoute: (settings) => MaterialPageRoute(
                builder: (context) => Offstage(
                    offstage: selectedTabIndex != index, child: child)),
          );
  }
}
