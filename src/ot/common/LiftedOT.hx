package ot.common;

class LiftedOT<TSnapOld, TSnapNew, TOp> implements OT<TSnapNew, TOp> {
  var oldOT: OT<TSnapOld, TOp>;
  var oldToNew: TSnapOld -> TSnapNew;
  var newToOld: TSnapNew -> TSnapOld;

  public function new(oldOT: OT<TSnapOld, TOp>, oldToNew: TSnapOld -> TSnapNew, newToOld: TSnapNew -> TSnapOld) {
    this.oldOT = oldOT;
    this.oldToNew = oldToNew;
    this.newToOld = newToOld;
  }

  public function apply(snap: TSnapNew, op: TOp) {
    return this.oldToNew(this.oldOT.apply(this.newToOld(snap), op));
  }

  public function compose(op1: TOp, op2: TOp) {
    return this.oldOT.compose(op1, op2);
  }

  public function transform(op1: TOp, op2: TOp, isBefore: Bool) {
    return this.oldOT.transform(op1, op2, isBefore);
  }
}
