import 'package:flutter/material.dart';

class TestTab extends StatefulWidget {
  TestTab({super.key});

  @override
  State<TestTab> createState() => _TestTabState();
}

class _TestTabState extends State<TestTab> with SingleTickerProviderStateMixin {
  int _tabIndex = 0;

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Disable Tab Tap'),
          flexibleSpace: IgnorePointer(
          ignoringSemantics:true,  ignoring: true,
            child: TabBar(
              // Disable tab tap
              controller: TabController(
                  vsync: this,
                  length: 3), // Set vsync to null to disable tab tap

              onTap: null, // Set onTap to null to disable tapping on tabs
              tabs: [
                GestureDetector(
                  child: Tab(icon: Icon(Icons.directions_car)),
                  onTap: () {
                    setState(() {
                      _tabIndex = 0;
                    });
                  },
                ),
                GestureDetector(
                  child: Tab(icon: Icon(Icons.directions_car)),
                  onTap: () {},
                ),
                GestureDetector(
                  child: Tab(icon: Icon(Icons.directions_car)),
                  onTap: () {
                    setState(() {
                      _tabIndex = 0;
                    });
                  },
                )
              ],
            ),
          ),
        ),
        body: TabBarView(
          children: [
            Icon(Icons.directions_car),
            Icon(Icons.directions_transit),
            Icon(Icons.directions_bike),
          ],
        ),
      ),
    );
  }
}
