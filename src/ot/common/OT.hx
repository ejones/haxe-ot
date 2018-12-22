package ot.common;

interface OT<TSnapshot, TOp> {
  function apply(snapshot: TSnapshot, op: TOp): TSnapshot;
  function compose(op1: TOp , op2: TOp): TOp;
  function transform(op: TOp, other: TOp, isBefore: Bool): TOp;
}
