class ExpenseModel {
  final int total;
  final String colorVal;
  final String category;
  ExpenseModel(this.total, this.colorVal, this.category);

  ExpenseModel.fromMap(Map<String, dynamic> map)
      : assert(map['total'] !=null),
        assert(map['colorVal'] != null),
        assert(map['category'] != null),
        total = map['total'],
        colorVal = map['colorVal'],
        category = map['category'];

//@override
//String toString() => "Record<$amount:$title:$colorVal:$category>";
}