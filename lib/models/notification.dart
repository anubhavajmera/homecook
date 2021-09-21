class Notification {
  String title, body, notificationType, routeName, createdAt;
  num id, entityId;
  bool readStatus;

  Notification(
      {this.body,
      this.createdAt,
      this.id,
      this.notificationType,
      this.readStatus,
      this.routeName,
      this.title,
      this.entityId});

  factory Notification.fromJson(Map<String, dynamic> json) {
    return Notification(
      id: json['id'],
      body: json['body'],
      notificationType: json['notification_type'],
      readStatus: json['read_status'],
      routeName: json['route_name'],
      title: json['title'],
      entityId: json['entity_id'],
      createdAt: json['created_at'],
    );
  }
}
