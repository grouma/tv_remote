import 'package:flutter/material.dart';
import 'vizio.dart';

var _vizio = Vizio('Zqkbi61ktz');

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TV Remote',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class InputList extends StatefulWidget {
  @override
  _InputList createState() => _InputList();
}

class _InputList extends State<InputList> {
  List<Device> _inputs = [];

  _InputList() {
    _vizio.listInputs().then((data) {
      setState(() {
        data.forEach(_inputs.add);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    var children = <OutlineButton>[];
    for (var input in _inputs) {
      children.add(OutlineButton(
        child: Text(input.friendlyName),
        onPressed: () {
          _vizio.setInput(input.name);
          Navigator.pop(context);
        },
      ));
    }
    return Scaffold(
      appBar: AppBar(
        title: Text("Inputs"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: children,
        ),
      ),
    );
  }
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Padding(
                  padding: EdgeInsets.all(8.0),
                  child: OutlineButton(
                    onPressed: () async => await _vizio.toggle(),
                    child: Icon(Icons.power_settings_new),
                  )),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Padding(
                  padding: EdgeInsets.all(8.0),
                  child: OutlineButton(
                    onPressed: () async => await _vizio.volumDown(),
                    child: Icon(Icons.remove),
                  )),
              Padding(
                  padding: EdgeInsets.all(8.0),
                  child: OutlineButton(
                    onPressed: () async {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => InputList()),
                      );
                    },
                    child: Icon(Icons.input),
                  )),
              Padding(
                  padding: EdgeInsets.all(8.0),
                  child: OutlineButton(
                    onPressed: () async => await _vizio.volumUp(),
                    child: Icon(Icons.add),
                  )),
            ],
          )
        ]),
      ),
    );
  }
}
