package ot.sequence;

using Lambda;
import ot.sequence.SequenceOp;

class TransformIterator<TElem> {
  var opCursor: OpCursor<TElem>;
  var otherCursor: OpCursor<TElem>;
  var nextOp: SequenceOp<TElem>;
  var isBefore: Bool;

  public function new(op: SequenceOps<TElem>, other: SequenceOps<TElem>, isBefore: Bool) {
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
              case Skip(num):
                opDelta = otherDelta = Math.floor(Math.min(num, otherNum));
                nextOp = Skip(opDelta);
              case Delete(num):
                opDelta = otherDelta = Math.floor(Math.min(num, otherNum));
                nextOp = Skip(opDelta);
              case Insert(elems):
                opDelta = Constants.INT_MAX;
                nextOp = Insert(elems);
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
