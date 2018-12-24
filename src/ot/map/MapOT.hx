package ot.map;

import ot.common.OT;
import ot.common.NamedValue;

class MapOT<TValue, TOp> implements OT<Iterable<NamedValue<TValue>>, MapOp<TValue, TOp>> {
  function new() {}
  public static var instance = new MapOT();

  public function apply(snapshot: Iterable<NamedValue<TValue>>, op: MapOp<TValue, TOp>): Iterable<NamedValue<TValue>> {
    return new ApplyIterator(snapshot, op);
  }

  public function compose(op1: MapOp<TValue, TOp>, op2: MapOp<TValue, TOp>): MapOp<TValue, TOp> {
    return null;
  }

  public function transform(op: MapOp<TValue, TOp>, other: MapOp<TValue, TOp>, isBefore: Bool): MapOp<TValue, TOp> {
    return null;
  }
}
