package ot.sequence;

class SliceIterator<T> {
  var itor: Iterator<T>;
  var remaining: Int;

  public function new(items: Iterable<T>, start: Int, end = -1) {
    this.itor = items.iterator();

    for (_i in 0...start) {
      if (!this.itor.hasNext()) {
        break;
      }
      this.itor.next();
    }

    this.remaining = end < 0 ? end : end - start;
  }

  public function hasNext() {
    return this.itor.hasNext() && this.remaining != 0;
  }

  public function next() {
    if (this.remaining == 0) {
      return null;
    }

    if (this.remaining > 0) {
      this.remaining -= 1;
    }

    return this.itor.next();
  }

  public function iterator() {
    return this;
  }
}
