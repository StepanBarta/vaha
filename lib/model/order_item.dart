class OrderItem {
  final int dbId;
  final int parentId;
  String name;
  final int storeCardId;
  final double qty;
  final String ordered;
  final String orderedQty;
  String userWeight = '';



  OrderItem (
      this.dbId,
      this.parentId,
      this.name,
      this.storeCardId,
      this.qty,
      this.ordered,
      this.orderedQty
      );
}
