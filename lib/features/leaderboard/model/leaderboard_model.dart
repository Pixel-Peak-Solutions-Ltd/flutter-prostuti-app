class LeaderboardResponse {
  bool? success;
  String? message;
  LeaderboardMeta? meta;
  List<LeaderboardData>? data;

  LeaderboardResponse({
    this.success,
    this.message,
    this.meta,
    this.data,
  });

  LeaderboardResponse.fromJson(Map<String, dynamic> json) {
    // Handle the case where the response has direct meta and data fields
    if (json.containsKey('meta') && !json.containsKey('success')) {
      print('📊 Detected direct API response structure');

      // Extract meta directly from the root
      meta =
          json['meta'] != null ? LeaderboardMeta.fromJson(json['meta']) : null;

      // Extract success/message (defaults if not present)
      success = true; // Assume success since we got a response
      message = "Success";

      // Extract data array from the nested data property
      if (json.containsKey('data') && json['data'] is List) {
        final dataList = json['data'] as List;
        data = dataList.map((item) => LeaderboardData.fromJson(item)).toList();
        print('📊 Successfully parsed ${data!.length} leaderboard entries');
      } else {
        print('⚠️ No valid data array found in response');
        data = [];
      }
    }
    // Handle the case where the actual data is nested inside a data property
    else if (json.containsKey('data') && json['data'] is Map<String, dynamic>) {
      print('📊 Detected nested response structure inside data property');

      final nestedData = json['data'] as Map<String, dynamic>;

      // Extract from the nested data
      if (nestedData.containsKey('meta')) {
        meta = LeaderboardMeta.fromJson(nestedData['meta']);
      }

      success = json['success'];
      message = json['message'];

      if (nestedData.containsKey('data') && nestedData['data'] is List) {
        final dataList = nestedData['data'] as List;
        data = dataList.map((item) => LeaderboardData.fromJson(item)).toList();
        print(
            '📊 Successfully parsed ${data!.length} leaderboard entries from nested data');
      } else {
        print('⚠️ No valid data array found in nested data');
        data = [];
      }
    }
    // Original expected structure
    else {
      print('📊 Using original expected response structure');
      success = json['success'];
      message = json['message'];
      meta =
          json['meta'] != null ? LeaderboardMeta.fromJson(json['meta']) : null;

      if (json['data'] != null && json['data'] is List) {
        final dataList = json['data'] as List;
        data = dataList.map((item) => LeaderboardData.fromJson(item)).toList();
      } else {
        print(
            '⚠️ Expected data to be a List, but got: ${json['data']?.runtimeType}');
        print('⚠️ Data value: ${json['data']}');
        data = [];
      }
    }

    // Final debug output
    print(
        '📊 Parsed response: meta=${meta != null}, data count=${data?.length ?? 0}');
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['success'] = success;
    data['message'] = message;
    if (meta != null) {
      data['meta'] = meta!.toJson();
    }
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class LeaderboardMeta {
  int? page;
  int? limit;
  int? count;

  LeaderboardMeta({
    this.page,
    this.limit,
    this.count,
  });

  LeaderboardMeta.fromJson(Map<String, dynamic> json) {
    page = json['page'];
    limit = json['limit'];
    count = json['count'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['page'] = page;
    data['limit'] = limit;
    data['count'] = count;
    return data;
  }
}

class LeaderboardData {
  String? sId;
  dynamic studentId; // Changed to dynamic to handle both string ID and object
  String? courseId;
  int? totalTestScore;
  int? totalAssignmentScore;
  int? totalScore;
  int? attemptedTests;
  int? attemptedAssignments;
  String? updatedAt;
  String? createdAt;

  LeaderboardData({
    this.sId,
    this.studentId,
    this.courseId,
    this.totalTestScore,
    this.totalAssignmentScore,
    this.totalScore,
    this.attemptedTests,
    this.attemptedAssignments,
    this.updatedAt,
    this.createdAt,
  });

  LeaderboardData.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];

    // Handle student_id which could be a string ID or a nested object
    if (json['student_id'] != null) {
      if (json['student_id'] is Map<String, dynamic>) {
        studentId = StudentData.fromJson(json['student_id']);
      } else {
        // If it's just an ID string, create a StudentData with just the ID
        studentId = StudentData(sId: json['student_id'].toString());
      }
    }

    courseId = json['course_id'];
    totalTestScore = json['totalTestScore'];
    totalAssignmentScore = json['totalAssignmentScore'];
    totalScore = json['totalScore'];
    attemptedTests = json['attemptedTests'];
    attemptedAssignments = json['attemptedAssignments'];
    updatedAt = json['updatedAt'];
    createdAt = json['createdAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = sId;
    if (studentId != null) {
      if (studentId is StudentData) {
        data['student_id'] = (studentId as StudentData).toJson();
      } else {
        data['student_id'] = studentId.toString();
      }
    }
    data['course_id'] = courseId;
    data['totalTestScore'] = totalTestScore;
    data['totalAssignmentScore'] = totalAssignmentScore;
    data['totalScore'] = totalScore;
    data['attemptedTests'] = attemptedTests;
    data['attemptedAssignments'] = attemptedAssignments;
    data['updatedAt'] = updatedAt;
    data['createdAt'] = createdAt;
    return data;
  }
}

class StudentData {
  String? sId;
  String? name;
  ImageData? image;

  StudentData({
    this.sId,
    this.name,
    this.image,
  });

  StudentData.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    name = json['name'];
    image = json['image'] != null ? ImageData.fromJson(json['image']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = sId;
    data['name'] = name;
    if (image != null) {
      data['image'] = image!.toJson();
    }
    return data;
  }
}

class ImageData {
  String? diskType;
  String? path;
  String? originalName;
  String? modifiedName;
  String? fileId;

  ImageData({
    this.diskType,
    this.path,
    this.originalName,
    this.modifiedName,
    this.fileId,
  });

  ImageData.fromJson(Map<String, dynamic> json) {
    diskType = json['diskType'];
    path = json['path'];
    originalName = json['originalName'];
    modifiedName = json['modifiedName'];
    fileId = json['fileId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['diskType'] = diskType;
    data['path'] = path;
    data['originalName'] = originalName;
    data['modifiedName'] = modifiedName;
    data['fileId'] = fileId;
    return data;
  }
}
