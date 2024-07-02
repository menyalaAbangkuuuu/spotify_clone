import 'package:flutter/material.dart';
import 'package:spotify_clone/screens/home/widget/top_playlist_widget.dart';
import 'package:spotify_clone/screens/search/widget/search_appbar.dart';

class MyHomePage extends StatefulWidget {
  static const String routeName = "/home";

  const MyHomePage({super.key});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return const Scaffold(
      appBar: PreferredSize(
          preferredSize: Size.fromHeight(50),
          child: SearchAppbar(
            title: "",
          )),
      body: SafeArea(
        child: Column(
          children: <Widget>[
            Expanded(
              child: TopTracksWidget(),
            ),
          ],
        ),
      ),
    );
  }
}
