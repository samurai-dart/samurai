import 'package:parsejs/parsejs.dart';
import 'package:symbol_table/symbol_table.dart';
import 'arguments.dart';
import 'context.dart';
import 'literal.dart';
import 'object.dart';
import 'samurai.dart';

/// The Dart function that is responsible for the logic of a given [JsFunction].
typedef JsObject JsFunctionCallback(
    Samurai samurai, JsArguments arguments, SamuraiContext ctx);

class JsFunction extends JsObject {
  final JsObject Function(Samurai, JsArguments, SamuraiContext) f;
  final JsObject context;
  SymbolTable<JsObject> closureScope;
  Node declaration;

  JsFunction(this.context, this.f) {
    typeof = 'function';
    properties['length'] = new JsNumber(0);
    properties['name'] = new JsString('anonymous');
    properties['prototype'] = new JsObject();
  }

  bool get isAnonymous {
    return properties['name'] == null ||
        properties['name'].toString() == 'anonymous';
  }

  String get name {
    if (isAnonymous) {
      return '(anonymous function)';
    } else {
      return properties['name'].toString();
    }
  }

  void set name(String value) => properties['name'] = new JsString(value);

  JsFunction bind(JsObject newContext) {
    return new JsFunction(newContext, f)
      ..properties.addAll(properties)
      ..closureScope = closureScope.fork()
      ..declaration = declaration;
  }

  @override
  String toString() {
    return isAnonymous ? '[Function]' : '[Function: $name]';
  }
}

class JsConstructor extends JsFunction {
  JsConstructor(JsObject context,
      JsObject Function(Samurai, JsArguments, SamuraiContext) f)
      : super(context, f);
}
