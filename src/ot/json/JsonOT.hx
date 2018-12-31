package ot.json;

import ot.common.OT;
import ot.common.NamedValue;
import ot.common.LiftedOT;
import ot.map.MapOT;
import ot.map.MapOp;
import ot.sequence.SequenceOT;

using Lambda;

#if python
typedef PyStringDict = python.Dict<String, Any>;
#end

class JsonOT implements OT<Any, JsonOp> {
  public static var instance = new JsonOT();

  static var objectOT: OT<Any, MapOp<Any, JsonOp>> = new LiftedOT(
        new MapOT<Any, JsonOp>(),
        function (values: Iterable<NamedValue<Any>>): Any {
#if python
          var d = new PyStringDict();
#else
          throw "not implemented";
#end
          for (v in values) {
            d.set(v.name, v.value);
          }

          return d;
        },
        function (value: Any): Iterable<NamedValue<Any>> {
#if python
          var d: PyStringDict = Std.is(value, python.Dict) ? cast value : new PyStringDict();
          var keyIter = {iterator: function() return d.keys().iterator()};
          return keyIter.map(function (k) return new NamedValue(k, d.get(k)));
#else
          throw "not implemented";
#end

        }
      );

  function new() {}

  public function apply(snap: Any, op: JsonOp): Any {
    switch (op) {
      case ObjectOp(mapOp):
        return objectOT.apply(snap, mapOp);
      case _:
        return null;
    }
  }

  public function compose(op1: JsonOp, op2: JsonOp): JsonOp {
    return null;
  }

  public function transform(op: JsonOp, other: JsonOp, isBefore: Bool): JsonOp {
    return null;
  }
}
