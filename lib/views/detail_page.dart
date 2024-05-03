import 'package:flutter/material.dart';
import 'package:gaubeVaha/model/order_item.dart';

import '../build/order.build.dart';
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
  

  @override
  void restoreState(RestorationBucket? oldBucket, bool initialRestore) {
  }

  List<Widget> get _sectionWidgets => <Widget>[
//        DeliveryBill(date: curDate),
//        const TankListView(),
      ];

  @override
  Widget build(BuildContext context) {
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
                    // Zde můžete přidat kód, který se provede po stisknutí tlačítka
                  },
                  child: Text('Info'),
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
