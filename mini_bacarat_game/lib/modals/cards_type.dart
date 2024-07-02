/// Thirteen standard card ranks.
enum CardValue {
  two(2),
  three(3),
  four(4),
  five(5),
  six(6),
  seven(7),
  eight(8),
  nine(9),
  ten(0),
  jack(0),
  queen(0),
  king(0),
  ace(1);

  final int _value;
  const CardValue(int value) : _value = value;

  int get value => _value;

}