package ot.sequence;

using Lambda;
import ot.sequence.SequenceOp;

class ComposeIterator<TElem, TOp> {
  var cursor1: OpCursor<TElem, TOp>;
  var cursor2: OpCursor<TElem, TOp>;
  var nextOp: SequenceOp<TElem, TOp>;

  public function new(op1: SequenceOps<TElem, TOp>, op2: SequenceOps<TElem, TOp>) {
    this.cursor1 = new OpCursor(op1);
    this.cursor2 = new OpCursor(op2);
    this.makeNext();
  }

  function makeNext() {
    var cursor1 = this.cursor1;
    var cursor2 = this.cursor2;
    var delta1 = 0;
    var delta2 = 0;
    var nextOp = null;

    while (nextOp == null && (cursor1.currentOp != null || cursor2.currentOp != null)) {
      if (cursor1.currentOp != null && cursor2.currentOp != null) {
        switch (cursor2.currentOp) {
          case Skip(num2):
            switch (cursor1.currentOp) {
              case Skip(num1):
                delta1 = delta2 = Math.floor(Math.min(num1, num2));
                nextOp = Skip(delta1);
              case Delete(num1):
                delta1 = num1;
                nextOp = Delete(num1);
              case Insert(elems1):
                var newElems1 = new SliceIterator(elems1, 0, num2).array();
                delta1 = delta2 = Math.floor(Math.min(num2, newElems1.length));
                nextOp = Insert(newElems1);
              case Apply(op1, ot1):
                delta1 = delta2 = 1;
                nextOp = Apply(op1, ot1);
            }
          case Delete(num2):
            switch (cursor1.currentOp) {
              case Skip(num1):
                delta1 = delta2 = Math.floor(Math.min(num1, num2));
                nextOp = Delete(delta1);
              case Delete(num1):
                delta1 = num1;
                nextOp = Delete(num1);
              case Insert(elems1):
                var newElems1 = new SliceIterator(elems1, 0, num2).array();
                delta1 = delta2 = Math.floor(Math.min(num2, newElems1.length));
              case Apply(_, _):
                delta1 = delta2 = 1;
                nextOp = Delete(delta1);
            }
          case Insert(elems2):
            delta2 = Constants.INT_MAX;
            nextOp = Insert(elems2);
          case Apply(op2, ot2):
            switch (cursor1.currentOp) {
              case Skip(num1):
                delta1 = delta2 = 1;
                nextOp = Apply(op2, ot2);
              case Delete(num1):
                delta1 = num1;
                nextOp = Delete(num1);
              case Insert(elems1):
                var elem1 = elems1.iterator().next();
                delta1 = delta2 = 1;
                nextOp = Insert([ot2.apply(elem1, op2)]);
              case Apply(op1, _):
                delta1 = delta2 = 1;
                nextOp = Apply(ot2.compose(op1, op2), ot2);
            }
        }
      } else if (cursor1.currentOp != null) {
        delta1 = Constants.INT_MAX;
        nextOp = cursor1.currentOp;
      } else {
        delta2 = Constants.INT_MAX;
        nextOp = cursor2.currentOp;
      }

      cursor1.advance(delta1);
      cursor2.advance(delta2);
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
