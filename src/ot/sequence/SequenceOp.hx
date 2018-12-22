package ot.sequence;

enum SequenceOp<TElem> {
  Skip(num: Int);
  Delete(num: Int);
  Insert(elems: Iterable<TElem>);
}
