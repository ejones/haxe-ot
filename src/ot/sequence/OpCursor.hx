package ot.sequence;

using Lambda;
import ot.sequence.SequenceOp;

class OpCursor<TElem> {
  var ops: Iterator<SequenceOp<TElem>>;

  public var currentOp(default, null): SequenceOp<TElem>;

  public function new(ops: SequenceOps<TElem>) {
    this.ops = ops.iterator();
    this.getNextOp();
  }

  function getNextOp() {
    this.currentOp = this.ops.hasNext() ? this.ops.next() : null;
  }

  public function advance(maxNum: Int) {
    if (this.currentOp == null || maxNum == 0) {
      return;
    }

    switch (this.currentOp) {
      case Skip(num) if (maxNum < num):
        this.currentOp = Skip(num - maxNum);

      case Delete(num) if (maxNum < num):
        this.currentOp = Delete(num - maxNum);

      case Insert(elems):
        var newElems = new SliceIterator(elems, maxNum).array();

        if (newElems.length > 0) {
          this.currentOp = Insert(newElems);
        } else {
          this.getNextOp();
        }

      case _:
        this.getNextOp();
    }
  }
}

