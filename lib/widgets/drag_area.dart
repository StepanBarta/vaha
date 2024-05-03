import 'package:flutter/material.dart';

class StatefulDragArea extends StatefulWidget {
  final Widget child;

  const StatefulDragArea({Key? key, required this.child}) : super(key: key);

  @override
  State<StatefulDragArea> createState() => _DragAreaStateStateful();
}

class _DragAreaStateStateful extends State<StatefulDragArea> {
  Offset position = const Offset(100, 100);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          left: position.dx,
          top: position.dy,
          child: Draggable(
            feedback: widget.child,
            childWhenDragging: Opacity(
              opacity: .3,
              child: widget.child,
            ),
            onDragEnd: (details) => setState(() => position = details.offset),
            child: widget.child,
          ),
        )
      ],
    );
  }
}