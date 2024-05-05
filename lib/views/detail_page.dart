
import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:gaubeVaha/model/order_item.dart';
import '../build/order.build.dart';
import '../inc/serialUsb.inc.dart';

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

  // SerialUsb serialUsb = SerialUsb();
  UsbPort? port;

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

  /*
  void testSeriaku() {
    SerialPort spTest = SerialPort('/dev/ttyS6');
//      final spTest = SerialPort('/dev/ttyS4');
//      final spTest = SerialPort('/dev/ttyFIQ0'); // 13
//      final spTest = SerialPort('/dev/ttyS9'); // 13
//      final spTest = SerialPort('/dev/ttyS7');
//      final spTest = SerialPort('/dev/ttyS1');
      var spTest = SerialPort( '/dev/ttyUSB0' );

    spTest.openReadWrite();
    SerialPortReader reader = SerialPortReader(spTest);

    SerialPortConfig config = spTest.config;

    reader.stream.listen((data) {
      print(String.fromCharCodes(data));
    });

    SerialPortConfig config = spTest.config;

    config.baudRate = 1200;
    config.bits = 8;
    config.parity = SerialPortParity.none;
    config.stopBits = 1;
    spTest.config = config;

    print("koncim");
  }
  */

  @override
  void restoreState(RestorationBucket? oldBucket, bool initialRestore) {
  }



  void uesbeSerial() async {
    if ( port != null ) {
      print("vypinam");
      port?.close();
//      port = null;
      return;
    }

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

  void _setWeightInput( String weight ) {
    if ( weight == "," && userWeight.contains(",") ) {
      return;
    }

    if ( weight == "," && userWeight.length == 0 ) {
      return;
    }

    if ( weight == "0" && userWeight.length == 0 ) {
      return;
    }

    userWeight += weight;
    updateUserWeight();
  }

  /*
  void toggleSerial() async {
    print("toggleSerial");
    print(serialUsb.activePort);

    if (serialUsb.activePort == null) {
      print("a");
      await serialUsb.connect();

      if (serialUsb.activePort != null) {
        print("tady uz aktivni je");
        String _resultText = "";

        serialUsb.activePort!.inputStream!.listen((Uint8List event) {
          print("event: $event");
          String receivedText = String.fromCharCodes(event);
          int ascii = receivedText.codeUnitAt(0);

          if (ascii == 10) {
            _weightController.text = _resultText;
            _resultText = "";
          } else if (ascii >= 46 && ascii <= 57) {
            _resultText += receivedText;
          }
        });
      } else {
        print("Nejak se to nepripojilo");
        serialUsb.disconnect();
      }
    }
  }
*/
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: Column(
        children: [
          // Horní řádek
          Padding(
            padding: const EdgeInsets.only(top: 20.0), // Přidává odsazení nahoře

            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.zero, // Hranaté rohy
                    ),
                    padding: EdgeInsets.zero, // Bez paddingu, aby tlačítko zaplnilo celý sloupec
                  ),
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
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.zero, // Hranaté rohy
                    ),
                    padding: EdgeInsets.zero, // Bez paddingu, aby tlačítko zaplnilo celý sloupec
                  ),

                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text('Info'),
                          content: Text('Ahoj Stepane'),
                          actions: <Widget>[
                            TextButton(
                              child: Text('Zavřít'),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                            ),
                          ],
                        );
                      },
                    );
                  },
                  child: Text('Info'),
                ),
                ElevatedButton(
                  onPressed: () {
                    uesbeSerial();
                  },
                  child: Text('Tlačítko 3'),
                ),
              ],
            ),
          ),
          // Řádek se dvěma sloupci
          Expanded(
            child: Row(
              children: [
                // Levý sloupec
                Expanded(
                  flex: 7,
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
                // Pravý sloupec
                Expanded(
                  flex: 3,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start, // Zarovnání prvků na začátek sloupce
                    children: <Widget>[
                      Container(
                        height: 100,
                        width: double.infinity,
                        child: TextField(
                          controller: _weightController,
                          enabled: false,
                          textAlign: TextAlign.center,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Zadejte váhu',
                            labelStyle: TextStyle(
                              color: Colors.black,
                              fontSize: 40,
                            ),
                          ),
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 40,
                          ),
                        ),
                      ),
                      Container(
                        height: 100,
                        width: double.infinity, // Šířka tlačítka je nastavena na maximální možnou šířku
                        child: ElevatedButton(
                          onPressed: () {
                            setOrderItemWeight();
                          },
                          child: Text('Uložit váhu'),
                        ),
                      ),


                      Container(
                        child: GridView.builder(
                          shrinkWrap: true,
                          itemCount: 9,
                          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3,
                          ),
                          itemBuilder: (context, index) {
                            return ElevatedButton(
                              child: Text((index+1).toString()),
                              onPressed: () {
                                userWeight += ( index + 1 ).toString();
                                updateUserWeight();
                              },
                            );
                          },
                        ),
                      ),

                      Container(
                        width: double.infinity, // Šířka tlačítka je nastavena na maximální možnou šířku
                        height: 50,
                        child: Row(
                          children: <Widget>[
                            Expanded(
                              child: ElevatedButton(
                                onPressed: () {
                                  _setWeightInput( "0" );
                                },
                                child: Text('0'),
                              ),
                            ),
                            Expanded(
                              child: ElevatedButton(
                                onPressed: () {
                                  _setWeightInput( "," );
                                },
                                child: Text('.'),
                              ),
                            ),
                            Expanded(
                              child: ElevatedButton(
                                onPressed: () {
                                  if ( userWeight.length > 0 ) {
                                    userWeight = userWeight.substring(0, userWeight.length - 1);
                                    updateUserWeight();
                                  }
                                },
                                child: Text('C'),
                              ),
                            ),
                            Expanded(
                              child: ElevatedButton(
                                onPressed: () {
                                  userWeight = '';
                                  updateUserWeight();
                                },
                                child: Text('X'),
                              ),
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
                        ),





                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }


}
