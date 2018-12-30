package ot.json;

import ot.map.MapOp;
import ot.sequence.SequenceOps;

enum JsonOp {
  ObjectOp(op: MapOp<Any, JsonOp>);
  ArrayOp(op: SequenceOps<Any, JsonOp>);
  StringOp(op: SequenceOps<String, Void>);
  Reset(op: JsonOp);
}
