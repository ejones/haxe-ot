package ot.sequence;

class SequenceOT<TElem> implements ot.common.OT<Iterable<TElem>, SequenceOps<TElem>> {
  function new() {}
  public static var instance = new SequenceOT();

  public function apply(snapshot: Iterable<TElem>, op: SequenceOps<TElem>): Iterable<TElem> {
    return new ApplyIterator(snapshot, op);
  }

  public function compose(op1: SequenceOps<TElem>, op2: SequenceOps<TElem>): SequenceOps<TElem> {
    return new ComposeIterator(op1, op2);
  }

  public function transform(op: SequenceOps<TElem>, other: SequenceOps<TElem>, isBefore: Bool): SequenceOps<TElem> {
    return new TransformIterator(op, other, isBefore);
  }
}
