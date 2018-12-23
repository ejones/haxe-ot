package ot.sequence;

import ot.common.OT;

enum SequenceOp<TElem, TOp> {
  Skip(num: Int);
  Delete(num: Int);
  Insert(elems: Iterable<TElem>);
  Apply(op: TOp, ot: OT<TElem, TOp>);
}
