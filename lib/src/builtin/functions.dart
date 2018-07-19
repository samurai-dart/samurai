import 'package:samurai/samurai.dart';
import 'boolean_constructor.dart';
import 'function_constructor.dart';
import 'misc.dart';

void loadBuiltinObjects(Samurai samurai) {
  loadMiscObjects(samurai);

  samurai.global.properties.addAll({
    'Boolean': new JsBooleanConstructor(samurai.global),
    'Function': new JsFunctionConstructor(samurai.global),
  });
}
