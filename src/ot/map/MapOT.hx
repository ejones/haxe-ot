package ot.map;

import ot.common.OT;
import ot.common.NamedValue;
import ot.map.MapOpComponent;

class MapOT<TValue, TOp> implements OT<Iterable<NamedValue<TValue>>, MapOp<TValue, TOp>> {
  public function new() {}

  public function apply(snapshot: Iterable<NamedValue<TValue>>, op: MapOp<TValue, TOp>): Iterable<NamedValue<TValue>> {
    return new ApplyIterator(snapshot, op);
  }

  public function compose(op1: MapOp<TValue, TOp>, op2: MapOp<TValue, TOp>): MapOp<TValue, TOp> {
    var newOp = new MapOp<TValue, TOp>();

    for (key in op1.keys()) {
      if (!op2.exists(key)) {
        newOp[key] = op1[key];
      }
    }

    for (key in op2.keys()) {
      var op2Part = op2[key];

      newOp[key] =
        switch (op2Part) {
          case Set(_):
            op2Part;
          case Apply(subOp2, subOt2):
            switch (op1[key]) {
              case null:
                op2Part;
              case Set(value1):
                Set(subOt2.apply(value1, subOp2));
              case Apply(subOp1, _):
                Apply(subOt2.compose(subOp1, subOp2), subOt2);
            }
        };
    }

    return newOp;
  }

  public function transform(op: MapOp<TValue, TOp>, other: MapOp<TValue, TOp>, isBefore: Bool): MapOp<TValue, TOp> {
    var newOp = new MapOp<TValue, TOp>();

    for (key in op.keys()) {
      var opPart = op[key];

      var newOpPart =
        switch (opPart) {
          case Set(_):
            switch (other[key]) {
              case Set(_) if (isBefore):
                null;
              case _:
                opPart;
            }
          case Apply(subOp, subOt):
            switch (other[key]) {
              case null:
                opPart;
              case Set(_):
                null;
              case Apply(otherSubOp, otherSubOt):
                var otToUse = isBefore ? otherSubOt : subOt;
                Apply(otToUse.transform(subOp, otherSubOp, isBefore), otToUse);
            }
        };

      if (newOpPart != null) {
        newOp[key] = newOpPart;
      }
    }

    return newOp;
  }
}
