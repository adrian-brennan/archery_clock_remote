import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:archery_clock_remote/models/connection.dart';

class Connect extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return ConnectState();
  }
}

class ConnectState extends State<Connect> {
  final _ipAddressController = TextEditingController(text: "192.168.4.1");
  TextEditingController _portNumberController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  int portNumber = 0;


  void _connect() {
    if (_formKey.currentState!.validate()) {
      Provider.of<Connection>(context, listen: false)
          .setIp(_ipAddressController.text.trim());
      Provider.of<Connection>(context, listen: false)
          .setPort(_portNumberController.text.trim());

      portNumber = int.parse(_portNumberController.text.trim());

      Provider.of<Connection>(context, listen: false).connect();

      setState(() {
        _portNumberController = TextEditingController(text: portNumber.toString());
      });
    }
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    _ipAddressController.dispose();
    _portNumberController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Provider.of<Connection>(context, listen: false).discover();

    return ListView(
      padding: const EdgeInsets.all(6),
      children: <Widget>[
        Text(
          'Autoconnect',
          style: DefaultTextStyle.of(context).style.apply(fontSizeFactor: 1.5),
        ),
        Text(
            'The timer should be found automatically. Use this button to connect to it.'),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Consumer<Connection>(
              builder: (context, connected, child) => ElevatedButton(
                child: Text(connected.autoConnect),
                onPressed: () =>
                    Provider.of<Connection>(context, listen: false).connect(),
              ),
            ),
          ],
        ),
        Divider(
          height: 30.0,
          color: Colors.grey,
        ),
        Text(
          'Manual Connection',
          style: DefaultTextStyle.of(context).style.apply(fontSizeFactor: 1.5),
        ),
        Text(
            'If the service is not discovered use the fields and button below to manually connect.'),
        Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              TextFormField(
                controller: _ipAddressController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'IP Address:',
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter the IP address for the timer.';
                  }
                  return null;
                },
              ),
              Consumer<Connection>(builder: (context, connected, child) {
                _portNumberController.value = _portNumberController.value.copyWith(text: connected.port);
                return TextFormField(
                  keyboardType: TextInputType.number,
                  controller: _portNumberController,
                  decoration: InputDecoration(
                    labelText: 'Port Number:',
                  ),
                  onChanged: (value){
                    connected.port = value;
                  },
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter the port number for the timer.';
                    }
                    return null;
                  },
                );
              }),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  ElevatedButton(child: Text('Connect'), onPressed: _connect),
                ],
              ),
            ],
          ),
        ),
        Divider(
          height: 30.0,
          color: Colors.grey,
        ),
        Text(
          'Disconnect',
          style: DefaultTextStyle.of(context).style.apply(fontSizeFactor: 1.5),
        ),
        Text(
            'The timer can only be controlled by one remote at a time. If you want to let someone else have a turn, use the button below to disconnect.'),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              child: Text('Disconnect'),
              onPressed: () =>
                  Provider.of<Connection>(context, listen: false).disconnect(),
            ),
          ],
        ),
      ],
    );
  }
}
