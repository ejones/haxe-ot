package ot.json;

import ot.map.MapOp;
import ot.json.JsonOp;

class JsonOpConverter {
  public static function fromNative(value: Any): JsonOp {
#if python
    if (Std.is(value, python.Dict)) {
      var dict: python.Dict<String, Any> = cast value;
      var mapOp = new MapOp<Any, JsonOp>();

      for (key in dict.keys()) {
        mapOp.set(key, Set(dict.get(key)));
      }

      return ObjectOp(mapOp);
    }
#end

    throw 'unrecognized type for JSON OP: $value';
  }
}
