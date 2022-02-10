import 'package:flutter/material.dart';
import 'package:archery_clock_remote/models/connection.dart';
import 'package:provider/provider.dart';

class Settings extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return SettingsState();
  }
}

class SettingsState extends State<Settings> {
  TextEditingController callupTime = TextEditingController();
  TextEditingController endTime = TextEditingController();
  TextEditingController warnTime = TextEditingController();
  TextEditingController line1 = TextEditingController();
  TextEditingController line2 = TextEditingController();

  @override
  void dispose() {
    callupTime.dispose();
    endTime.dispose();
    warnTime.dispose();
    line1.dispose();
    line2.dispose();
    super.dispose();
  }

  void _load() {
    Provider.of<Connection>(context, listen: false)
        .sendCommand('query-settings');
  }

  void _save() {
    Provider.of<Connection>(context, listen: false).callupTime =
        callupTime.text;
    Provider.of<Connection>(context, listen: false).endTime = endTime.text;
    Provider.of<Connection>(context, listen: false).warnTime = warnTime.text;
    Provider.of<Connection>(context, listen: false).lineOne = line1.text;
    Provider.of<Connection>(context, listen: false).lineTwo = line2.text;
  }

  void _saveAndSend() {
    _save();
    Provider.of<Connection>(context, listen: false).sendSetCommand();
  }

  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(6),
      children: <Widget>[
        Text(
          'Settings',
          style: DefaultTextStyle.of(context).style.apply(fontSizeFactor: 1.5),
        ),
        Text(
            'Load the current settings from the timer. Edit them here, then Save them back to the timer.'),
        Consumer<Connection>(builder: (context, connected, child) {
          callupTime.value = callupTime.value.copyWith(text: connected.callupTime);
          return TextField(
            controller: callupTime,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              labelText: 'Call up time:',
            ),
            onChanged: (value){
              connected.callupTime = value;
            },
          );
        }),
        Consumer<Connection>(builder: (context, connected, child) {
          endTime.value = endTime.value.copyWith(text: connected.endTime);
          return TextField(
            controller: endTime,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              labelText: 'End Time:',
            ),
            onChanged: (value){
              connected.endTime = value;
            },
          );
        }),
        Consumer<Connection>(builder: (context, connected, child) {
          warnTime.value = warnTime.value.copyWith(text: connected.warnTime);
          return TextField(
            controller: warnTime,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              labelText: 'Warning Time:',
            ),
            onChanged: (value){
            connected.warnTime = value;
          },
          );
        }),
        Consumer<Connection>(builder: (context, connected, child) {
          line1.value = line1.value.copyWith(text: connected.lineOne);
          return TextField(
            controller: line1,
            decoration: InputDecoration(
              labelText: 'Line 1:',
            ),
            onChanged: (value){
              connected.lineOne = value;
            },
          );
        }),
        Consumer<Connection>(
          builder: (context, connected, child) => CheckboxListTile(
            value: (connected.lineTwoEnabled.toLowerCase() == 'true'),
            onChanged: (value) {
              _save();
              setState(() {
                connected.lineTwoEnabled = value.toString();
              });
            },
            title: const Text('Enable Line 2?'),
          ),
        ),
        Consumer<Connection>(builder: (context, connected, child) {
          line2.value = line2.value.copyWith(text: connected.lineTwo);
          return TextField(
            controller: line2,
            decoration: InputDecoration(
              labelText: 'Line 2:',
            ),
            onChanged: (value){
              connected.lineTwo = value;
            },
          );
        }),
        Consumer<Connection>(
          builder: (context, connected, child) => CheckboxListTile(
            value: (connected.toggleLines.toLowerCase() == 'true'),
            onChanged: (value) {
              _save();
              setState(() {
                connected.toggleLines = value.toString();
              });
            },
            title: const Text('Alternate Lines?'),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            ElevatedButton(child: Text('Load'), onPressed: _load),
            ElevatedButton(child: Text('Save'), onPressed: _saveAndSend),
          ],
        ),
      ],
    );
  }
}
