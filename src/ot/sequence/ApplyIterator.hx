package ot.sequence;

class ApplyIterator<TElem, TOp> {
  var ops: Iterator<SequenceOp<TElem, TOp>>;
  var elems: Iterator<TElem>;

  var currentElems: Iterator<TElem> = null;
  var currentLimit = 0;
  var nextVal: TElem = null;
  var isDone = false;

  public function new(elems: Iterable<TElem>, op: SequenceOps<TElem, TOp>) {
    this.elems = elems.iterator();
    this.ops = op.iterator();
    this.findNext();
  }

  function hasCurrentElem() {
    return this.currentElems != null && this.currentElems.hasNext() && this.currentLimit > 0;
  }

  function findNext() {
    if (!this.hasCurrentElem()) {
      for (nextOp in this.ops) {
        switch (nextOp) {
          case Skip(num):
            this.currentElems = this.elems;
            this.currentLimit = num;
            break;

          case Delete(num):
            for (_i in 0...num) {
              if (this.elems.hasNext()) {
                this.elems.next();
              }
            }

          case Insert(elems):
            this.currentElems = elems.iterator();
            this.currentLimit = Constants.INT_MAX;
            break;

          case Apply(op, ot):
            this.currentElems = null;
            this.currentLimit = 0;

            if (this.elems.hasNext()) {
              this.nextVal = ot.apply(this.elems.next(), op);
            } else {
              this.nextVal = null;
              this.isDone = true;
            }

            return;
        }
      }
    }

    if (!this.hasCurrentElem()) {
      this.currentElems = this.elems;
      this.currentLimit = Constants.INT_MAX;
    }

    if (this.hasCurrentElem()) {
      this.currentLimit -= 1;
      this.nextVal = this.currentElems.next();
    } else {
      this.nextVal = null;
      this.isDone = true;
    }
  }

  public function hasNext() {
    return !this.isDone;
  }

  public function next() {
    var val = this.nextVal;
    this.findNext();
    return val;
  }

  public function iterator() {
    return this;
  }
}
