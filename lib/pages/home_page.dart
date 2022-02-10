import 'dart:async';

import 'package:archery_clock_remote/fragments/run_fragment.dart';
import 'package:archery_clock_remote/fragments/connect_fragment.dart';
import 'package:archery_clock_remote/fragments/settings_fragment.dart';
import 'package:flutter/material.dart';
import 'package:archery_clock_remote/models/connection.dart';
import 'package:provider/provider.dart';
import 'package:wakelock/wakelock.dart';

class DrawerItem {
  String title;
  IconData icon;
  DrawerItem(this.title, this.icon);
}

class HomePage extends StatefulWidget {
  final drawerItems = [
    DrawerItem("Run", Icons.timer),
    DrawerItem("Connect", Icons.wifi),
    DrawerItem("Settings", Icons.settings)
  ];

  @override
  State<StatefulWidget> createState() {
    return HomePageState();
  }
}

class HomePageState extends State<HomePage> {
  int _selectedDrawerIndex = 1;
  bool showHeart = false;

  HomePageState(){
    Wakelock.enable();
  }

  @override
  void initState() {
    super.initState();
  }

  _checkConnection(){
    Provider.of<Connection>(context, listen: false).sendCommand('version');
    setState(() {
      showHeart = !showHeart;
    });
  }

  _getDrawerItemWidget(int pos) {
    switch (pos) {
      case 0:
        return Run();
      case 1:
        return Connect();
      case 2:
        return Settings();

      default:
        return Text("Error");
    }
  }

  onSelectItem(int index) {
    setState(() => _selectedDrawerIndex = index);
    Navigator.of(context).pop(); // close the drawer
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> drawerOptions = [];
    for (var i = 0; i < widget.drawerItems.length; i++) {
      var d = widget.drawerItems[i];
      drawerOptions.add(ListTile(
        leading: Icon(d.icon),
        title: Text(d.title),
        selected: i == _selectedDrawerIndex,
        onTap: () => onSelectItem(i),
      ));
    }

    return Scaffold(
      body: _getDrawerItemWidget(_selectedDrawerIndex),
      appBar: AppBar(
        title: Text('Archery Timer Remote'),
        actions: <Widget>[
          // showHeart ? Icon(Icons.favorite) : Container(),
          // Show connection icon
          Consumer<Connection>(
            builder: (context, connected, child) => Icon(
              connected.icon,
            ),
          ),
        ],
      ),
      drawer: Drawer(
        child: Column(
          children: <Widget>[
            UserAccountsDrawerHeader(
                accountName: Text("Options"), accountEmail: null),
            Column(children: drawerOptions)
          ],
        ),
      ),
    );
  }

}
