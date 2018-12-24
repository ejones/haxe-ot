package ot.map;

import ot.common.NamedValue;

class ApplyIterator<TValue, TOp> {
  var namedValues: Iterator<NamedValue<TValue>>;
  var op: MapOp<TValue, TOp>;

  public function new(namedValues: Iterable<NamedValue<TValue>>, op: MapOp<TValue, TOp>) {
    this.namedValues = namedValues.iterator();
    this.op = op;
  }

  public function hasNext() {
    return this.namedValues.hasNext();
  }

  public function next() {
    var namedValue = this.namedValues.next();
    var opPart = this.op[namedValue.name];

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

  public function iterator() {
    return this;
  }
}
