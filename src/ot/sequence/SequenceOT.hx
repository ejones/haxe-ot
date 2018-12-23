package ot.sequence;

class SequenceOT<TElem, TOp> implements ot.common.OT<Iterable<TElem>, SequenceOps<TElem, TOp>> {
  function new() {}
  public static var instance = new SequenceOT();

  public function apply(snapshot: Iterable<TElem>, op: SequenceOps<TElem, TOp>): Iterable<TElem> {
    return new ApplyIterator(snapshot, op);
  }

  public function compose(op1: SequenceOps<TElem, TOp>, op2: SequenceOps<TElem, TOp>): SequenceOps<TElem, TOp> {
    return new ComposeIterator(op1, op2);
  }

  public function transform(op: SequenceOps<TElem, TOp>, other: SequenceOps<TElem, TOp>, isBefore: Bool): SequenceOps<TElem, TOp> {
    return new TransformIterator(op, other, isBefore);
  }
}
