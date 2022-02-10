import 'package:flutter/material.dart';
import 'package:archery_clock_remote/models/connection.dart';
import 'package:provider/provider.dart';

class Run extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return RunState();
  }
}

class RunState extends State<Run> {
  final endNumber = TextEditingController();

  void _saveEndNumber() {
    Provider.of<Connection>(context, listen: false).endNumber = endNumber.text;
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(6),
      children: <Widget>[
        Text(
          'Run',
          style: DefaultTextStyle.of(context).style.apply(fontSizeFactor: 1.5),
        ),
        Text(
            'Set the initial end number, then it advances when you press Next End. Check the box for a practice, uncheck for a scoring round.'),
        Row(
          children: <Widget>[
            TextButton.icon(
                style: TextButton.styleFrom(primary: Colors.white , backgroundColor:Colors.blueGrey ),
                label: Text('Next End'),
                icon: Icon(Icons.add),
                onPressed: (() {
                  _saveEndNumber();
                  Provider.of<Connection>(context, listen: false)
                      .sendNextEndCommand();
                })),
            SizedBox.fromSize(
              size: Size(10.0, 2.0),
            ),
            Flexible(
              child: Consumer<Connection>(builder: (context, connected, child) {
                endNumber.value =
                    endNumber.value.copyWith(text: connected.endNumber);
                return TextField(
                  controller: endNumber,
                  autofocus: false,
                );
              }),
            ),
            Consumer<Connection>(
              builder: (context, connected, child) => Checkbox(
                value: (connected.isPracticeEnd.toLowerCase() == 'true'),
                onChanged: (value) {
                  setState(() {
                    connected.isPracticeEnd = value.toString();
                  });
                },
              ),
            ),
            Text('Practice'),
          ],
        ),
        SizedBox.fromSize(
          size: Size(10.0, 10.0),
        ),
        Text('Change from Lines AB/CD to a Makeup End'),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            TextButton.icon(
                style: TextButton.styleFrom(primary: Colors.black , backgroundColor:Colors.black12 ),
                label: Text('Makeup End'),
                icon: Icon(Icons.build),
                onPressed: (() {
                  _saveEndNumber();
                  Provider.of<Connection>(context, listen: false)
                      .sendCommand('makeup-end');
                })),
          ],
        ),
        Divider(
          height: 30.0,
          color: Colors.grey,
        ),
        SizedBox.fromSize(
          size: Size(10.0, 10.0),
        ),
        Text(
            "Press Start to get things going. If everyone's done you can Skip forward to the next phase."),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            TextButton.icon(
                label: Text('Start/Resume Timer'),
                icon: Icon(Icons.play_arrow),
                style: TextButton.styleFrom(primary: Colors.white , backgroundColor:Colors.blueGrey ),
                onPressed: (() {
                  _saveEndNumber();
                  Provider.of<Connection>(context, listen: false)
                      .sendCommand('start-timer');
                })),
            TextButton.icon(
                style: TextButton.styleFrom(primary: Colors.white , backgroundColor:Colors.blueGrey ),
                label: Text('Skip'),
                icon: Icon(Icons.fast_forward),
                onPressed: (() {
                  _saveEndNumber();
                  Provider.of<Connection>(context, listen: false)
                      .sendCommand('fast-forward');
                })),
          ],
        ),
        SizedBox.fromSize(
          size: Size(10.0, 10.0),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            TextButton.icon(
                style: TextButton.styleFrom(primary: Colors.black , backgroundColor:Colors.black12 ),
                label: Text('Pause'),
                icon: Icon(Icons.pause),
                onPressed: (() {
                  _saveEndNumber();
                  Provider.of<Connection>(context, listen: false)
                      .sendCommand('pause-timer');
                })),
          ],
        ),
        Divider(
          height: 30.0,
          color: Colors.grey,
        ),
        Text(
            "Sounds the Emergency Stop signal and changes the display to STOP. Resume with the Start/Resume button."),
        SizedBox.fromSize(
          size: Size(10.0, 10.0),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextButton.icon(
                label: Text('\nEMERGENCY\n      STOP\n'),
                icon: Icon(Icons.local_hospital),
                style: TextButton.styleFrom(primary: Colors.white , backgroundColor:Colors.red ),
                onPressed: (() {
                  _saveEndNumber();
                  Provider.of<Connection>(context, listen: false)
                      .sendCommand('emergency-stop');
                })),
          ],
        ),
      ],
    );
  }
}
