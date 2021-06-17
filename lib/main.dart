// @dart=2.9
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'data/data.dart';
import 'dart:async' show Future;
import 'package:flutter/services.dart' show rootBundle;
import 'global.dart';
import 'data/meal.dart';
import 'pages/meals_page.dart';
import 'data/user.dart';
import 'pages/user_page.dart';

Future<String> loadAsset(String path) async {
  return await rootBundle.loadString(path);
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Global.setUser(new NamUser());
  String dataPath = 'assets/res/matvaretabellen.csv';
  Global.setData(new Data(await loadAsset(dataPath)));
  String recommendedPath = 'assets/res/table_1_8.csv';
  Global.setRecommended(new Recommended(await loadAsset(recommendedPath)));
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (context) => MealList()),
          ChangeNotifierProvider(create: (context) => Global.getUser())
        ],
        child: MaterialApp(
          title: 'Nam',
          theme: ThemeData(
            primarySwatch: Colors.blue,
          ),
          home: MainPage(title: 'Nam'),
        ));
  }
}

class MainPage extends StatefulWidget {
  final String title;
  MainPage({Key key, this.title = ""}) : super(key: key);

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  PageController _pageController = PageController();
  List<Widget> _pages = [MealsPage(), UserPage()];
  int _pageIndex = 0;

  void _onPageChanged(int index) {
    setState(() {
      _pageIndex = index;
    });
  }

  void _onTap(int index) {
    _pageController.jumpToPage(index);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pageController,
        children: _pages,
        onPageChanged: _onPageChanged,
        physics: NeverScrollableScrollPhysics(),
      ),
      bottomNavigationBar: BottomNavigationBar(
          currentIndex: _pageIndex,
          onTap: _onTap,
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
            BottomNavigationBarItem(icon: Icon(Icons.person), label: 'User'),
          ]),
    );
  }
}
