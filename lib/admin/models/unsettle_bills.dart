class UnsettledBills{
  final String id;
  final String memberId;
  final String name;
  final String areaId;
  final String connectionId;
  final double previousReading;
  final double currentReading;
  final String dateRead;
  final double totalCubic;
  final double billingPrice;
  final String flatRate;
  final double flatRatePrice;
  final String status;
  final bool toBill;
  final double balance;
  final String billMonth;
  final String billYear;


  UnsettledBills(this.id, this.memberId, this.name, this.areaId,
  this.connectionId, this.previousReading, this.currentReading, this.dateRead,this.totalCubic, this.billingPrice, this.flatRate,
  this.flatRatePrice, this.status, this.toBill, this.balance,this.billMonth,this.billYear);
}