import 'package:provider/provider.dart';

class CreateServiceDTO {
  CreateServiceDTO({required this.ids, required this.location});
  final List<int> ids;
  final String location;

  Map<String, dynamic> toJson() => {
    'ids': ids,
    'location': location
    };

}
