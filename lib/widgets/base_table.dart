import 'package:flutter/material.dart';

class BaseTable extends StatefulWidget {
  const BaseTable({
    Key? key,
    required this.fields,
    required this.items,
  }) : super(key: key);

  final List fields;
  final List items;

  @override
  State<BaseTable> createState() => _BaseTableStateful();
}

class _BaseTableStateful extends State<BaseTable> {
  Widget _buildTable() {
    List<Widget> table = [];

    if (widget.fields.isNotEmpty) {
      List<Widget> tableHeader = [];
      for (var field in widget.fields) {
        tableHeader.add(
          Expanded(
            child: Text(
              field.key,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        );
      }

      table.addAll([
        Row(children: tableHeader),
        const Divider(color: Colors.black38),
      ]);

      if (widget.items.isNotEmpty) {
        // List<Widget> tableRows = [];
        // int index = 0;
        for (var item in widget.items) {
          List<Widget> tableRow = [];
          for (var field in widget.fields) {
            tableRow.add(
              Expanded(
                child: Text(
                  item[field.key],
                  style: const TextStyle(fontWeight: FontWeight.bold),
                  overflow: TextOverflow.visible,
                  softWrap: true,
                ),
              ),
            );
          }

          table.addAll([
            Row(children: tableHeader),
            const Divider(color: Colors.black38),
          ]);
        }
      }
    }

    return Wrap(children: table);
  }

  @override
  Widget build(BuildContext context) {
    return _buildTable();
  }
}
