class Subscrpion {
  bool status;
  String msg;
  List<Subscriptions> subscriptions;

  Subscrpion({this.status, this.msg, this.subscriptions});

  Subscrpion.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    msg = json['msg'];
    if (json['subscriptions'] != null) {
      subscriptions = new List<Subscriptions>();
      json['subscriptions'].forEach((v) {
        subscriptions.add(new Subscriptions.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['msg'] = this.msg;
    if (this.subscriptions != null) {
      data['subscriptions'] =
          this.subscriptions.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Subscriptions {
  int id;
  String name;
  int dinar;
  int dollar;
  int duration;
  String createdAt;
  String updatedAt;

  Subscriptions(
      {this.id,
      this.name,
      this.dinar,
      this.dollar,
      this.duration,
      this.createdAt,
      this.updatedAt});

  Subscriptions.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    dinar = json['dinar'];
    dollar = json['dollar'];
    duration = json['duration'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['dinar'] = this.dinar;
    data['dollar'] = this.dollar;
    data['duration'] = this.duration;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}
