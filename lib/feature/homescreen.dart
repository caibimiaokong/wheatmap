import 'package:flutter/material.dart';

//pubdev packages
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';

//local library
import 'package:wheatmap/feature/map_feature/views/map_ui.dart';
import 'package:wheatmap/feature/article_feature/view/article_ui.dart';
import 'package:wheatmap/feature/profile_feature/views/profile_ui.dart';

class HomeNavigator extends StatefulWidget {
  const HomeNavigator({super.key});

  @override
  State<HomeNavigator> createState() => _HomeNavigatorState();
}

class _HomeNavigatorState extends State<HomeNavigator> {
  late PageController _pageController;
  int _selectedIndex = 0;

  //页面列表
  final List<Widget> _page = <Widget>[
    const MapScreen(),
    const ArticleUI(),
    const ProfileUI(),
  ];

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: _selectedIndex);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pageController,
        physics: const NeverScrollableScrollPhysics(),
        children: _page,
      ),
      bottomNavigationBar: SalomonBottomBar(
        currentIndex: _selectedIndex,
        onTap: (index) => setState(() {
          _selectedIndex = index;
          _pageController.jumpToPage(index);
        }),
        items: [
          /// Home
          SalomonBottomBarItem(
            icon: const Icon(Icons.map),
            title: const Text("Map"),
            selectedColor: Colors.blue,
          ),

          /// Search
          SalomonBottomBarItem(
            icon: const Icon(Icons.article),
            title: const Text("Article"),
            selectedColor: Colors.orange,
          ),

          /// Profile
          SalomonBottomBarItem(
            icon: const Icon(Icons.person),
            title: const Text("Profile"),
            selectedColor: Colors.teal,
          ),
        ],
      ),
    );
  }
}
