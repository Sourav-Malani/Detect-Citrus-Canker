class RecentSearch {
  late String lat;
  late String long;
  late String city;

  RecentSearch(this.lat, this.long, this.city);

  RecentSearch.fromJson(Map<String, dynamic> json) {
    lat = json['lat'];
    long = json['long'];
    city = json['city'];
  }

  Map<String, dynamic> get json => {
        'lat': lat,
        'long': long,
        'city': city,
      };

  Map<String, dynamic> toJson() {
    return json;
  }
}
