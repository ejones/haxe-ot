package ot.sequence;

using Lambda;
import ot.sequence.SequenceOp;

class TransformIterator<TElem, TOp> {
  var opCursor: OpCursor<TElem, TOp>;
  var otherCursor: OpCursor<TElem, TOp>;
  var nextOp: SequenceOp<TElem, TOp>;
  var isBefore: Bool;

  public function new(op: SequenceOps<TElem, TOp>, other: SequenceOps<TElem, TOp>, isBefore: Bool) {
    this.opCursor = new OpCursor(op);
    this.otherCursor = new OpCursor(other);
    this.isBefore = isBefore;
    this.makeNext();
  }

  function makeNext() {
    var opCursor = this.opCursor;
    var otherCursor = this.otherCursor;
    var opDelta = 0;
    var otherDelta = 0;
    var nextOp = null;

    while (nextOp == null && opCursor.currentOp != null) {
      if (opCursor.currentOp != null && otherCursor.currentOp != null) {
        switch (otherCursor.currentOp) {
          case Skip(otherNum):
            switch (opCursor.currentOp) {
              case Skip(num) | Delete(num):
                opDelta = otherDelta = Math.floor(Math.min(num, otherNum));
                nextOp = opCursor.currentOp;
              case Insert(elems):
                opDelta = Constants.INT_MAX;
                nextOp = Insert(elems);
              case Apply(_, _):
                opDelta = otherDelta = 1;
                nextOp = opCursor.currentOp;
            }
          case Delete(otherNum):
            switch (opCursor.currentOp) {
              case Skip(num):
                opDelta = otherDelta = Math.floor(Math.min(num, otherNum));
              case Delete(num):
                opDelta = otherDelta = Math.floor(Math.min(num, otherNum));
              case Insert(elems):
                opDelta = Constants.INT_MAX;
                nextOp = Insert(elems);
              case Apply(_, _):
                opDelta = otherDelta = 1;
            }
          case Insert(otherElems):
            switch (opCursor.currentOp) {
              case Insert(elems) if (this.isBefore):
                opDelta = Constants.INT_MAX;
                nextOp = Insert(elems);
              case _:
                otherDelta = Constants.INT_MAX;
                nextOp = Skip(otherElems.count());
            }
          case Apply(otherOp, otherOt):
            switch (opCursor.currentOp) {
              case Skip(_) | Delete(_):
                opDelta = otherDelta = 1;
                nextOp = opCursor.currentOp;
              case Insert(elems):
                opDelta = Constants.INT_MAX;
                nextOp = Insert(elems);
              case Apply(op, ot):
                opDelta = otherDelta = 1;
                var otToUse = isBefore ? otherOt : ot;
                nextOp = Apply(otToUse.transform(op, otherOp, isBefore), otToUse);
            }
        }
      } else {
        opDelta = Constants.INT_MAX;
        nextOp = opCursor.currentOp;
      }

      opCursor.advance(opDelta);
      otherCursor.advance(otherDelta);
    }

    this.nextOp = nextOp;
  }

  public function hasNext() {
    return this.nextOp != null;
  }

  public function next() {
    var val = this.nextOp;
    this.makeNext();
    return val;
  }

  public function iterator() {
    return this;
  }
}
