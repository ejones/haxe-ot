package ot.map;

import ot.common.OT;

enum MapOpComponent<TValue, TOp> {
  Set(value: TValue);
  Apply(op: TOp, ot: OT<TValue, TOp>);
}

