/**
 * created by Nishith on 24/09/20.
 */

class Group {
  String createdAt;
  String createdBy;
  String id;
  List<String> members;
  List<String> readBy;
  RecentMessage recentMessage;

  Group({this.createdAt, this.createdBy, this.id, this.members, this.readBy, this.recentMessage});

  factory Group.fromJson(Map<String, dynamic> json) {
    return Group(
      createdAt: json['createdAt'],
      createdBy: json['createdBy'],
      id: json['id'],
      members: json['members'] != null ? new List<String>.from(json['members']) : null,
      readBy: json['readBy'] != null ? new List<String>.from(json['readBy']) : null,
      recentMessage: json['recentMessage'] != null ? RecentMessage.fromJson(json['recentMessage']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['createdAt'] = this.createdAt;
    data['createdBy'] = this.createdBy;
    data['id'] = this.id;
    if (this.members != null) {
      data['members'] = this.members;
    }
    if (this.readBy != null) {
      data['readBy'] = this.readBy;
    }
    if (this.recentMessage != null) {
      data['recentMessage'] = this.recentMessage.toJson();
    }
    return data;
  }
}

class RecentMessage {
  String message;
  String sentAt;
  String sentBy;

  RecentMessage({this.message, this.sentAt, this.sentBy});

  factory RecentMessage.fromJson(Map<String, dynamic> json) {
    return RecentMessage(
      message: json['message'],
      sentAt: json['sentAt'],
      sentBy: json['sentBy'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['message'] = this.message;
    data['sentAt'] = this.sentAt;
    data['sentBy'] = this.sentBy;
    return data;
  }
}
