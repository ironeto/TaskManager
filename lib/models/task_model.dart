class TaskModel {
  String id;
  String name;
  int effortHours;
  double latitude;
  double longitude;
  DateTime date;
  String imageName;

  TaskModel(
    this.id,
    this.name,
    this.effortHours,
    this.latitude,
    this.longitude,
    this.date,
    this.imageName);

  TaskModel.fromJson(String this.id, Map<String, dynamic> json)
      : name = json['name'],
        effortHours = json['effortHours'],
        latitude = json['latitude'],
        longitude = json['longitude'],
        date = json['date'].toDate(),
        imageName = json['imageName'];

  Map<String, dynamic> toJson() => {
    'name': name,
    'effortHours': effortHours,
    'latitude': latitude,
    'longitude': longitude,
    'date': date,
    'imageName': imageName
  };
}
