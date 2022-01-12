class HistoryModel {
  final int total;
  final String colorVal;
  final String month;
  HistoryModel(this.total, this.colorVal, this.month);

  HistoryModel.fromMap(Map<String, dynamic> map)
      : assert(map['total'] !=null),
        assert(map['colorVal'] != null),
        assert(map['month'] != null),
        total = map['total'],
        colorVal = map['colorVal'],
        month = map['month'];

//@override
//String toString() => "Record<$amount:$title:$colorVal:$category>";
}
