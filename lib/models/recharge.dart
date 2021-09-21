class Recharge {
  int id;
  double amount;
  String createdAt, method, status, paymentId, orderId, signature, uid;

  Recharge({
    this.id,
    this.amount,
    this.createdAt,
    this.method,
    this.status,
    this.orderId,
    this.paymentId,
    this.signature,
    this.uid
  });

  factory Recharge.fromJson(Map json) {
    return Recharge(
      id: json['id'],
      amount: json['amount'],
      createdAt: json['created_at'],
      method: json['razorpay_method'],
      status: json['razorpay_status'],
      signature: json['razorpay_signature'],
      paymentId: json['razorpay_payment_id'],
      orderId: json['razorpay_order_id']
    );
  }
}
