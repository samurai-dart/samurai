import 'package:samurai/samurai.dart';
import 'function_constructor.dart';
import 'misc.dart';

void loadBuiltinObjects(Samurai samurai) {
  loadMiscObjects(samurai);

  samurai.global.properties['Function'] =
      new JsFunctionConstructor(samurai.global);
}
