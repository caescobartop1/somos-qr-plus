class NotificationModel {
  final int id;
  final int userId;
  final String userUsername;
  final String userFirstName;
  final String userLastName;
  final String userEmail;
  final bool userIsActive;
  final bool userIsStaff;
  final String? userLastLogin;
  final String? userDateJoined;
  final bool userIsSuperuser;
  final bool userIsVerified;
  final String level;
  final String title;
  final String message;
  final String? urlAccess;
  final bool unread;
  final String created;
  final String modified;

  NotificationModel({
    required this.id,
    required this.userId,
    required this.userUsername,
    required this.userFirstName,
    required this.userLastName,
    required this.userEmail,
    required this.userIsActive,
    required this.userIsStaff,
    this.userLastLogin,
    this.userDateJoined,
    required this.userIsSuperuser,
    required this.userIsVerified,
    required this.level,
    required this.title,
    required this.message,
    this.urlAccess,
    required this.unread,
    required this.created,
    required this.modified,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    final user = json['user'] ?? {};
    return NotificationModel(
      id: json['id'] ?? 0,
      userId: user['id'] ?? 0,
      userUsername: user['username'] ?? '',
      userFirstName: user['first_name'] ?? '',
      userLastName: user['last_name'] ?? '',
      userEmail: user['email'] ?? '',
      userIsActive: user['is_active'] ?? false,
      userIsStaff: user['is_staff'] ?? false,
      userLastLogin: user['last_login'],
      userDateJoined: user['date_joined'],
      userIsSuperuser: user['is_superuser'] ?? false,
      userIsVerified: user['is_verified'] ?? false,
      level: json['level'] ?? '',
      title: json['title'] ?? '',
      message: json['message'] ?? '',
      urlAccess: json['url_access'],
      unread: json['unread'] ?? false,
      created: json['created'] ?? '',
      modified: json['modified'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'user_username': userUsername,
      'user_first_name': userFirstName,
      'user_last_name': userLastName,
      'user_email': userEmail,
      'user_is_active': userIsActive,
      'user_is_staff': userIsStaff,
      'user_last_login': userLastLogin,
      'user_date_joined': userDateJoined,
      'user_is_superuser': userIsSuperuser,
      'user_is_verified': userIsVerified,
      'level': level,
      'title': title,
      'message': message,
      'url_access': urlAccess,
      'unread': unread,
      'created': created,
      'modified': modified,
    };
  }
}
