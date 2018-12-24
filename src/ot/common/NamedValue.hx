package ot.common;

@:publicFields
class NamedValue<T> {
  var name(default, null): String;
  var value(default, null): T;

  function new(name: String, value: T) {
    this.name = name;
    this.value = value;
  }
}
