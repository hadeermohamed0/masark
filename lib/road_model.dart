class RoadModel {
  final int? id;
  final String? geom;
  final String? name;
  final int? time;
  final double? distance;

  RoadModel({
    this.id,
    this.geom,
    this.name,
    this.time,
    this.distance,
  });

  factory RoadModel.fromJson(Map<String, dynamic> json) => RoadModel(
    id: json["id"],
    geom: json["geom"],
    name: json["Name"],
    time: json["Time"],
    distance: json["Distance"]?.toDouble(),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "geom": geom,
    "Name": name,
    "Time": time,
    "Distance": distance,
  };
}
