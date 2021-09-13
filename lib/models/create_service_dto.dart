import 'package:provider/provider.dart';

class CreateServiceDTO {
  CreateServiceDTO({this.ids, this.location});
  final List<int> ids;
  final String location;

  Map<String, dynamic> toJson() => {
    'ids': ids,
    'location': location
    };

}
