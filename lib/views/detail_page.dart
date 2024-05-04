import 'dart:ffi';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:gaubeVaha/model/order_item.dart';
import '../build/order.build.dart';

import 'package:flutter_libserialport/flutter_libserialport.dart';
import 'package:usb_serial/usb_serial.dart';


import 'home_page.dart';




class OrderDetailPage extends StatefulWidget {
  OrderDetailPage({super.key, required this.orderId});

  final int orderId;

  @override
  State<OrderDetailPage> createState() => _OrderDetailPageState();
}

class _OrderDetailPageState extends State<OrderDetailPage> {
  final List _navMenu = ['Dodací listy', 'Závozy', 'Tanky', 'Historie sudu'];
  int _selectedSectionIndex = 0;
  String get _sectionTitle => _navMenu[_selectedSectionIndex];
  OrderItem? _selectedOrderItem;
  String userWeight = '';
  final TextEditingController _weightController = TextEditingController(); // kontroler pro editaci textoveho pole
//  final ?String restorationId;

  List<OrderItem> orderItems = [];
  OrderBuild orderBuild = OrderBuild();

  static DateTime today = DateTime.now();

  @override
  void initState() {
    super.initState();
    _getOrderItems();
  }

  void _getOrderItems() async {
    orderItems = await orderBuild.getOrderDetail(widget.orderId);
    if (mounted) setState(() {});
  }

  void _setOrderItemWeight() async {
    bool result = await orderBuild.setOrderItemWeight(_selectedOrderItem!);
  }

  void _changeSection(int index) {
    setState(() {
      _selectedSectionIndex = index;
    });
  }

  void updateUserWeight() {
    _weightController.text = userWeight;
  }

  void setOrderItemWeight() {
    if (_selectedOrderItem != null) {
      _selectedOrderItem!.userWeight = userWeight;
      _selectedOrderItem!.name += " - ${_selectedOrderItem!.userWeight}";
      _weightController.text = '';
      userWeight = '';
      _setOrderItemWeight();

      setState(() {
        int index = orderItems.indexOf(_selectedOrderItem!);
        orderItems[index] = _selectedOrderItem!;
      });
    }
  }

  void testSeriaku() {
    print("testuju");
//    SerialPort spTest = SerialPort('/dev/ttyS6');
//      final spTest = SerialPort('/dev/ttyS4');
//      final spTest = SerialPort('/dev/ttyFIQ0'); // 13
//      final spTest = SerialPort('/dev/ttyS9'); // 13
//      final spTest = SerialPort('/dev/ttyS7');
//      final spTest = SerialPort('/dev/ttyS1');
      var spTest = SerialPort( '/dev/ttyUSB0' );

    spTest.openReadWrite();
    SerialPortReader reader = SerialPortReader(spTest);

    SerialPortConfig config = spTest.config;
//
  //  reader.stream.listen((data) {
    //  print(String.fromCharCodes(data));
//    }
  //  );
//    SerialPortConfig config = spTest.config;

//    config.baudRate = 1200;
//    config.bits = 8;
//    config.parity = SerialPortParity.none;
//    config.stopBits = 1;

//    spTest.config = config;

    print("koncim");

  }

  @override
  void restoreState(RestorationBucket? oldBucket, bool initialRestore) {
  }

  List<Widget> get _sectionWidgets => <Widget>[
//        DeliveryBill(date: curDate),
//        const TankListView(),
      ];

  void uesbeSerial() async {
    UsbPort? port;
    // Získání seznamu dostupných USB zařízení
    List<UsbDevice> devices = await UsbSerial.listDevices();
//    print(devices);
    port = await devices[0].create();

    bool? openResult = await port?.open();
    if ( !openResult! ) {
      print("Failed to open");
      return;
    }

    await port?.setDTR(true);
    await port?.setRTS(true);

    port?.setPortParameters(1200, UsbPort.DATABITS_8,
        UsbPort.STOPBITS_1, UsbPort.PARITY_NONE);

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
  }


  @override
  Widget build(BuildContext context) {

    uesbeSerial();





/*
      var i = 0;
      for (final name in SerialPort.availablePorts) {
        final sp = SerialPort(name);
        print('${++i}) $name');
        print('\tDescription: ${sp.description}');
        print('\tManufacturer: ${sp.manufacturer}');
        print('\tSerial Number: ${sp.serialNumber}');
        if ( sp.description == "USB-Serial Controller D" ) {
          print('\tProduct ID: 0x${sp.productId!.toRadixString(16)}');
          print('\tVendor ID: 0x${sp.vendorId!.toRadixString(16)}');
        }
        sp.dispose();
      }
*/
      /*
      SerialPortConfig spConfig = SerialPortConfig();
        spConfig.baudRate = 9600;
        spConfig.bits = 8;
        spConfig.parity = SerialPortParity.none;
        spConfig.stopBits = 1;
*/


    return Scaffold(
      // ...
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 20.0), // Přidává odsazení nahoře
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => HomePage()
                      ),
                    );                  },
                  child: Text('Zpět'),
                ),
                ElevatedButton(
                  onPressed: () {
                    testSeriaku();
                  },
                  child: Text('Infa'),
                ),
                ElevatedButton(
                  onPressed: () {
                    // Zde můžete přidat kód, který se provede po stisknutí tlačítka
                  },
                  child: Text('Tlačítko 3'),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: orderItems.length,
              itemBuilder: (context, index) {
                final item = orderItems[index];
                return ListTile(
                  tileColor: item == _selectedOrderItem ? Colors.blue : null, // Změna barvy pozadí, pokud je položka vybrána
                  title: Text(item.name),
                  subtitle: Text('Quantity: ${item.qty.toString()}'),
                  onTap: () {
                    setState(() {
                      _selectedOrderItem = item; // Aktualizace vybrané položky po kliknutí
                    });
                  },
                );
              },
            ),
          ),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Expanded(
                child: TextField(
                  controller: _weightController,
                  enabled: false,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Zadejte váhu',
                  ),
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  setOrderItemWeight();
                },
                child: Text('OK'),
              ),
            ],
          ),

          GridView.builder(
            shrinkWrap: true,
            itemCount: 10,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 5, // počet sloupců
            ),
            itemBuilder: (context, index) {
              return ElevatedButton(
                child: Text(index.toString()),
                onPressed: () {
                  userWeight += index.toString();
                  updateUserWeight();
                },
              );
            },
          ),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              ElevatedButton(
                onPressed: () {
                  if ( userWeight.indexOf( ",") == -1 ) // pokud ještě není desetinná čárka
                  userWeight += ",";
                  updateUserWeight();
                },
                child: Text('.'),
              ),
              ElevatedButton(
                onPressed: () {
                  if ( userWeight.length > 0 ) {
                    userWeight = userWeight.substring(0, userWeight.length - 1);
                    updateUserWeight();
                  }
                },
                child: Text('C'),
              ),
              ElevatedButton(
                onPressed: () {
                  userWeight = '';
                  updateUserWeight();
                },
                child: Text('X'),
              ),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    // Zde můžete přidat kód, který se provede po stisknutí tlačítka
                  },
                  child: Text('OK'),
                ),
              ),
            ],
          ),

        ],
      ),
      // ...
    );
  }


}
