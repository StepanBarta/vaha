import 'package:gaubeVaha/model/order_item.dart';
import 'package:gaubeVaha/networking/networking.dart';
import 'package:gaubeVaha/model/order.model.dart';
import 'package:gaubeVaha/store/store_global.dart';
import 'package:gaubeVaha/store/store_orderslist.dart';

class OrderBuild {
  OrderBuild({this.id, this.firmName});

  final int? id;
  final String? firmName;


  getOrdersList() async {
    NetworkHelper networkHelper = NetworkHelper(
      module: 'uhk',
      action: 'list',
    );

    final responseData = await networkHelper.postData();
    List<Order> result = [];

    if (responseData != null && responseData['data'].isNotEmpty) {
      final requestOrders = responseData['data']['orders'] ?? [];

      for (var item in requestOrders) {
        result.add(
          Order(
            item['orderId'] ?? 0,
            item['firmName'] ?? '',
            item['round'] ?? 0,
            item['status'] ?? ''
          ),
        );
      }

      result.add(Order(23, 'jmeno', 4, 'sk'));
    }

    StoreOrdersList.list = result;
    return result;
  }

  getOrderDetail( int orderId ) async {
    NetworkHelper networkHelper = NetworkHelper(
      module: 'uhk',
      action: 'detail',
      data: {'order_id': orderId },
    );

    final responseData = await networkHelper.postData();
    print(responseData);
    List<OrderItem> result = [];

    if (responseData != null && responseData['data'].isNotEmpty) {

      final requestOrders = responseData['data']['orderitems'] ?? [];


      for (var item in requestOrders) {
        item['orderedqty'] = item['orderedqty'] ?? 0;

        result.add(
          OrderItem(
              int.parse( item['id'] ),
              int.parse( item['parent_id'] ),
              item['storecard_name'] ?? '',
              int.parse( item['storecard_id'] ),
              double.parse( item['qty'] ),
              item['ordered'] ?? '',
              item['orderedqty'] ?? ''
          ),
        );
      }
    }

    return result;
  }

  setOrderItemWeight(OrderItem orderItem) async {
    NetworkHelper networkHelper = NetworkHelper(
      module: 'uhk',
      action: 'save-item',
      data: {
        'order_id': orderItem.parentId,
        'item_id': orderItem.dbId,
        'weight': orderItem.userWeight,
      },
    );

    final responseData = await networkHelper.postData();
    print(responseData);

    return responseData['status'] == 'ok';
  }
}
