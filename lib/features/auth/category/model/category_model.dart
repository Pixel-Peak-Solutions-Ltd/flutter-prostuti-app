class Category {
  bool? success;
  String? message;
  Meta? meta;
  List<String>? data;

  Category({this.success, this.message, this.meta, this.data});

  Category.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    meta = json['meta'] != null ? new Meta.fromJson(json['meta']) : null;
    data = json['data'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['success'] = this.success;
    data['message'] = this.message;
    if (this.meta != null) {
      data['meta'] = this.meta!.toJson();
    }
    data['data'] = this.data;
    return data;
  }
}

class Meta {
  int? count;

  Meta({this.count});

  Meta.fromJson(Map<String, dynamic> json) {
    count = json['count'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['count'] = this.count;
    return data;
  }
}
