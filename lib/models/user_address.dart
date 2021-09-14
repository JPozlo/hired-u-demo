class UserAddress {
  UserAddress({this.id, this.country, this.county, this.building, this.streetAddress, this.suite, this.homeTown});
  final String country;
  final int id;
  final String county;
  final String homeTown;
  final String streetAddress;
  final String building;
  final String suite;

  factory UserAddress.fromJson(Map<String, dynamic> json) {
    return UserAddress(
      id: json['id'] as int,
      country: json['country'] as String,
      homeTown: json['home_town'] as String,
      county: json['county'] as String,
      streetAddress: json['street_address'] as String,
      building: json['building'] as String,
      suite: json['suite'] as String,
    );
  }

  Map<String, dynamic> toJson() => {
        'country': country,
        'county': county,
        'home_town': homeTown,
        'street_address': streetAddress,
        'building': building,
        'suite': suite
      };

      @override
  String toString() {
    return "Country: $country";
  }
}
