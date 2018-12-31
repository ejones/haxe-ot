package ot.map;

import ot.common.NamedValue;
import ot.map.MapOp;

using Lambda;

class ApplyIterator<TValue, TOp> {
  var namedValues: Iterator<NamedValue<TValue>>;
  var remainingOp: MapOp<TValue, TOp>;
  var tailItems: Iterator<NamedValue<TValue>> = null;

  public function new(namedValues: Iterable<NamedValue<TValue>>, op: MapOp<TValue, TOp>) {
    this.namedValues = namedValues.iterator();
    this.remainingOp = new Map();

    for (k in op.keys()) {
      this.remainingOp.set(k, op[k]);
    }
  }

  public function hasNext() {
    return this.namedValues.hasNext() || (this.tailItems != null && this.tailItems.hasNext());
  }

  public function next() {
    if (this.tailItems != null) {
      return this.tailItems.next();
    }

    var namedValue = this.namedValues.next();
    var opPart = this.remainingOp[namedValue.name];
    this.remainingOp.remove(namedValue.name);

    if (!this.namedValues.hasNext()) {
      this.createTailItems();
    }

    if (opPart == null) {
      return namedValue;
    }

    var newValue =
      switch (opPart) {
        case Set(value):
          value;
        case Apply(op, ot):
          ot.apply(namedValue.value, op);
      };

    return new NamedValue(namedValue.name, newValue);
  }

  function createTailItems() {
    var tailItems = new List<NamedValue<TValue>>();

    for (k in this.remainingOp.keys()) {
      switch (this.remainingOp[k]) {
        case Set(v):
          tailItems.add(new NamedValue(k, v));
        case _:
      }
    }

    this.tailItems = tailItems.iterator();
  }

  public function iterator() {
    return this;
  }
}
