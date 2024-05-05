import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:gaubeVaha/build/order.build.dart';
import 'package:gaubeVaha/model/order.model.dart';
import 'package:gaubeVaha/views/detail_page.dart';


class HomePage extends StatefulWidget {
  const HomePage({super.key });

  // final String title;
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String get _sectionTitle => "Seznam objednávek";
  List<Order> ordersList = [];
  OrderBuild orderBuild = OrderBuild();

  @override
  void initState() {
    super.initState();
    _getOrdersList();
  }


  _getOrdersList() async {
    print("nasava");
    ordersList = await orderBuild.getOrdersList();
    if (mounted) setState(() {});
  }

  _openOrderDetail(int orderId) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => OrderDetailPage(orderId: orderId),
      ),
    ).then((value) => _getOrdersList());
  }


    Widget _buildOrdersList() => ListView.builder(
    
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        itemCount: ordersList.length,
        itemBuilder: (context, index) {
          final item = ordersList[index];

          return Card(
            child: ListTile(
              title: Text(item.firmName),
              trailing:
                  item.orderId > 0 ? const Icon(Icons.arrow_right) : null,
              subtitle: Text(item.status),
              onTap: item.orderId > 0
                  ? () => _openOrderDetail(item.orderId)
                  : null,
            ),
          );
        },
      );

  @override
  Widget build( BuildContext context ) {
    
    return Scaffold(
      appBar: AppBar(
          title: Text(_sectionTitle),
          actions: []),
      body: Center(
        
        child: Column( children: <Widget>[Expanded(child: _buildOrdersList())] ),
        )
      );
  }
}
