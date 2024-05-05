import 'package:usb_serial/usb_serial.dart';

class SerialUsb {
  SerialUsb();

  UsbPort? activePort = null;

  // pokud ma metoda/atribut _ na zacatku, je privatni
  Future<UsbPort?> connect() async {
    var test = uesbeSerial();



    print('SerialUsb connected');
  }

  void disconnect() {
    activePort?.close();
    activePort = null;
    print('SerialUsb disconnected');
  }

  Future<bool?> uesbeSerial() async {
    print("Pripojuju se k serailu");
    // Získání seznamu dostupných USB zařízení
    List<UsbDevice> devices = await UsbSerial.listDevices();

    UsbPort? port;

    if (devices.isEmpty) {
      print("No devices found");
      return null;
    }

    try {
      activePort = await devices[0].create();
    } catch (e) {
      print("neprobehlo create");
      return null;
    }

    bool? openResult = await activePort?.open();

    if (!openResult!) {
      activePort?.close();
      print("neprobehlo open result");
      return null;
    }

    await activePort?.setDTR(true);
    await activePort?.setRTS(true);

    activePort?.setPortParameters(
        1200,
        UsbPort.DATABITS_8,
        UsbPort.STOPBITS_1,
        UsbPort.PARITY_NONE
    );


  }
/*
String text = "";

    port?.inputStream?.listen((Uint8List event) {
      String receivedText = String.fromCharCodes(event);
      int ascii = receivedText.codeUnitAt(0);


      if ( ascii == 10 ) {
        _weightController.text = text;
        text = "";
      } else if ( ascii >= 46 && ascii <= 57 ) {
        text += receivedText;
      }

    });
*/
  }