import 'package:get/route_manager.dart';
import 'package:travelwin/language/ar.dart';
import 'package:travelwin/language/en.dart';
// import 'package:travelwin/language/fr.dart';
import 'package:travelwin/utils/my_string.dart';

class LocaliztionApp extends Translations {
  @override
  Map<String, Map<String, String>> get keys => {
        ene: en,
        ara: ar,
      };
}
