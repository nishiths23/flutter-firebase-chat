//
// created by Nishith on 19/09/20.
//

class Message {
  String from;
  String fromName;
  String groupId;
  String message;
  String status;
  String timestamp;
  String to;
  String id;
  String image;

  Message({this.from, this.fromName, this.groupId, this.message, this.status, this.timestamp, this.to, this.id, this.image});

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      from: json['from'],
      fromName: json['fromName'],
      groupId: json['groupId'],
      message: json['message'],
      status: json['status'],
      timestamp: json['timestamp'],
      to: json['to'],
      id: json['id'],
      image: json['image'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['from'] = this.from;
    data['fromName'] = this.fromName;
    data['groupId'] = this.groupId;
    data['message'] = this.message;
    data['status'] = this.status;
    data['timestamp'] = this.timestamp;
    data['to'] = this.to;
    data['id'] = this.id;
    data['image'] = this.image;
    return data;
  }
}
