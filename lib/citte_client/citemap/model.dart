class MapModel {
  MapModel({
    required this.id,
    required this.venueName,
    required this.address,  
    required this.latitude,
    required this.venueId,
    required this.longitude 
  }); 
  late final int id;
  late final String venueName;
  late final String address;
  late final double latitude;
  late final double longitude;
late final int venueId;
  MapModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    venueId = json['venueId'];
    venueName = json['venueName'];
    address =json['address'];
    latitude = double.parse(json['latitude']);
    longitude =double.parse( json['longitude']);
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['id'] = id;
    _data['venueId']=venueId;
    _data['venueName'] = venueName;
    _data['address'] = address;
    _data['latitude'] = latitude;
    _data['longitude'] = longitude;
    return _data;
  }
}