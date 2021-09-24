class CreateOrderDTO{
  final int id;
  final String userId;
  final String services;
  final String phone;
  final String location;
  final String deliveryDate;
  final String deliveryTime;
  final String specifics;
  final String createdAt;
  final String updatedAt;

  const CreateOrderDTO({required this.id, required this.userId, required this.services, required this.phone, required this.location, required this.deliveryDate, required this.deliveryTime, required this.specifics, required this.updatedAt, required this.createdAt});

  factory CreateOrderDTO.fromJson(Map<String, dynamic> json) {
    return CreateOrderDTO(
      id: json['id'] as int,
        services: json['services'] as String,
        phone: json['phone'] as String,
        location: json['location'] as String,
        specifics: json['specifics'] as String,
        deliveryDate: json['date'],
        deliveryTime: json['time'],
        updatedAt: json['updated_at'],
        createdAt: json['created_at'],
      userId: json['user_id'].toString()
    );
  }

  Map<String, dynamic> toJson() => {
    'services': services,
    'phone': phone,
    'location': location,
    'specifics': specifics,
    'date': deliveryDate,
    'time': deliveryTime
  };

  @override
  String toString() {
    return "The phone:$phone\n location: $location\n specifics: $specifics\n services: ${services.toString()}\n deliveryDate: $deliveryDate\n deliveryTime: $deliveryTime";
  }

}