
class MedicalTrips {
  MedicalTrips({
    this.id,
    this.titleAr,
    this.titleEn,});

  MedicalTrips.fromJson(dynamic json) {
    id = json['id'];
    titleAr = json['title_ar'];
    titleEn = json['title_en'];
  }
  int? id;
  String? titleAr;
  String? titleEn;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['title_ar'] = titleAr;
    map['title_en'] = titleEn;
    return map;
  }

}
class MedicalTrip {
  MedicalTrip({
      this.status, 
      this.medicalTrips,});

  MedicalTrip.fromJson(dynamic json) {
    status = json['status'];
    if (json['medicalTrips'] != null) {
      medicalTrips = [];
      json['medicalTrips'].forEach((v) {
        medicalTrips!.add(MedicalTrips.fromJson(v));
      });
    }
  }
  bool? status;
  List<MedicalTrips>? medicalTrips;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['status'] = status;
    if (medicalTrips != null) {
      map['medicalTrips'] = medicalTrips!.map((v) => v.toJson()).toList();
    }
    return map;
  }

}