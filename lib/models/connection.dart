import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
// import 'package:flutter_mdns_plugin/flutter_mdns_plugin.dart';
import 'dart:io' show Platform;
import 'dart:io';
import 'package:multicast_dns/multicast_dns.dart';

class Connection with ChangeNotifier {
  final String SERVICE_TYPE = "_icarus_archery_timer._tcp";

  IconData icon = Icons.signal_wifi_off;
  bool isConnected = false;

  String endNumber = "1";
  String isPracticeEnd = "true";

  String callupTime = "";
  String endTime = "";
  String warnTime = "";
  String lineOne = "";
  String lineTwo = "";
  String lineTwoEnabled = "";
  String toggleLines = "";

  String ip = "192.168.4.1";
  String port = "";

  String autoConnect =
      (Platform.isAndroid ? "Use Manual Connection" : "searching...");

  // FlutterMdnsPlugin flutterMdnsPlugin;

  Future<void> discover() async {
    if (!isConnected) {
      if (Platform.isAndroid) {
        print('service discovery not supported on android');
      } else if (Platform.isIOS) {
        print('service discovery not supported on iOS');
        // print('starting iOS service discovery');
        // flutterMdnsPlugin = FlutterMdnsPlugin(
        //     discoveryCallbacks: DiscoveryCallbacks(
        //         onDiscoveryStarted: () => {},
        //         onDiscoveryStopped: () {
        //           print('discovery stopped');
        //         },
        //         onDiscovered: (ServiceInfo serviceInfo) => {},
        //         onResolved: (ServiceInfo serviceInfo) {
        //           print('found device ${serviceInfo.toString()}');
        //
        //           port = serviceInfo.port.toString();
        //           ip = serviceInfo.address;
        //           autoConnect = "AutoConnect";
        //           notifyListeners();
        //           stopDiscovery();
        //         }));
        //
        // flutterMdnsPlugin.startDiscovery(SERVICE_TYPE);
      }
    }
  }

  // void stopDiscovery() {
  //   flutterMdnsPlugin.stopDiscovery();
  // }

  late Socket timer_socket;

  Future sleep() {
    return new Future.delayed(const Duration(seconds: 15), () => "15");
  }

  bool connect() {
    Socket.connect(ip, int.parse(port)).then((Socket sock) {
      timer_socket = sock;
      timer_socket.listen(dataHandler,
          onError: errorHandler, onDone: disconnect, cancelOnError: false);
    });

    setConnected(true);
    notifyListeners();
    return isConnected;
  }

  void sendNextEndCommand() {
    print('building next end command');

    String practice = 'no-practice';

    if (isPracticeEnd == 'true') {
      practice = 'practice';
    }

    String command = 'next-end $endNumber $practice';
    print(command);

    sendCommand(command);

    // increment the end number ready for next time
    endNumber = (int.parse(endNumber) + 1).toString();

    notifyListeners();
  }

  void sendCommand(String command) {
    if (isConnected) {
      timer_socket.writeln(command);
    } else {
      print('not connected - not sending command $command');
      currentValues();
    }
  }

  void currentValues(){
    print('currentValues: callup-time=$callupTime end-time=$endTime warn-time=$warnTime line-one=$lineOne line-two=$lineTwo line-two-enabled=$lineTwoEnabled toggle-lines=$toggleLines');
  }

  void sendSetCommand() {
    // build the command string
    print('building set command');
    String settings =
        'set callup-time=$callupTime end-time=$endTime warn-time=$warnTime line-one=$lineOne line-two=$lineTwo line-two-enabled=$lineTwoEnabled toggle-lines=$toggleLines';

    print(settings);

    //send it
    sendCommand(settings);
  }

  void dataHandler(data) {
    String response = new String.fromCharCodes(data).trim();

    if (!response.startsWith('OK:0:ArcheryTimer')) {
      print(response);

      // Settings string:
      // OK:0:callup-time=10 end-time=120 warn-time=30 line-one=A-B line-two=C-D line-two-enabled=false toggle-lines=true

      List<String> result = response.split(':');

      if (result[0] == 'OK' && result.length == 3) {
        List<String> args = result[2].split(' ');

        // TODO: fragile
        callupTime = args[0].split('=')[1];
        endTime = args[1].split('=')[1];
        warnTime = args[2].split('=')[1];
        lineOne = args[3].split('=')[1];
        lineTwo = args[4].split('=')[1];
        lineTwoEnabled = args[5].split('=')[1];
        toggleLines = args[6].split('=')[1];

        notifyListeners();
      }
    }


  }

  void errorHandler(error, StackTrace trace) {
    print(error);
  }

  void disconnect() {
    timer_socket.destroy();
    setConnected(false);
    notifyListeners();
  }

  void setIp(String newIp) {
    ip = newIp;
    print('ip set: $ip');
    notifyListeners();
  }

  void setPort(String newPort) {
    port = newPort;
    print('port set: $port');
    notifyListeners();
  }

  void setConnected(bool newValue) {
    isConnected = newValue;

    if (isConnected) {
      icon = Icons.signal_wifi_4_bar;
    } else {
      icon = Icons.signal_wifi_off;
    }
  }
}
