package ot.json;

import ot.map.MapOp;
import ot.sequence.SequenceOps;

enum JsonOp {
  ObjectOp(op: MapOp<Dynamic, JsonOp>);
  ArrayOp(op: SequenceOps<Dynamic, JsonOp>);
  StringOp(op: SequenceOps<String, Void>);
}
