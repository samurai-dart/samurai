import 'package:parsejs/parsejs.dart';
import 'package:samurai/samurai.dart';

class JsFunctionConstructor extends JsConstructor {
  JsFunctionConstructor(JsObject context) : super(context, constructor) {
    void _wrap(JsFunctionCallback f, String name) {
      prototype[name] = new JsFunction(context, f)..name = name;
    }

    _wrap(apply, 'apply');
    _wrap(bind_, 'bind');
    _wrap(call_, 'call');
    name = 'Function';
  }

  static JsObject constructor(
      Samurai samurai, JsArguments arguments, SamuraiContext ctx) {
    var paramNames = arguments.valueOf.length <= 1
        ? <String>[]
        : arguments.valueOf
            .take(arguments.valueOf.length - 1)
            .map((o) => coerceToString(o, samurai, ctx))
            .toList();
    var body = parsejs(arguments.valueOf.isEmpty
        ? ''
        : coerceToString(arguments.valueOf.last, samurai, ctx));

    var f = new JsFunction(ctx.scope.context, (samurai, arguments, ctx) {
      ctx = ctx.createChild();

      for (int i = 0; i < paramNames.length; i++) {
        ctx.scope
            .create(paramNames[i], value: arguments.getProperty(i.toDouble()));
      }

      return samurai.visitProgram(body);
    });
    f.closureScope = samurai.globalScope.createChild()
      ..context = samurai
          .global; // Yes, this is the intended semantics. Operates in the global scope.
    return f;
  }

  JsObject apply(Samurai samurai, JsArguments arguments, SamuraiContext ctx) {}

  JsObject bind_(Samurai samurai, JsArguments arguments, SamuraiContext ctx) {}

  JsObject call_(Samurai samurai, JsArguments arguments, SamuraiContext ctx) {}
}
