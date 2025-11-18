// Fractional indexing for stable element ordering in multiplayer
// Based on fractional-indexing npm package

class FractionalIndex {
  final String value;

  const FractionalIndex(this.value);

  static const String _minChar = 'a';
  static const String _maxChar = 'z';
  static const int _base = 26; // z - a + 1

  // Generate a key between two keys
  static FractionalIndex between(FractionalIndex? a, FractionalIndex? b) {
    if (a == null && b == null) {
      return const FractionalIndex('a0');
    }

    if (a == null) {
      return _decrementString(b!.value);
    }

    if (b == null) {
      return _incrementString(a.value);
    }

    return FractionalIndex(_midpoint(a.value, b.value));
  }

  static String _midpoint(String a, String b) {
    if (a >= b) {
      throw ArgumentError('a must be < b');
    }

    final buffer = StringBuffer();
    int i = 0;

    while (true) {
      final aChar = i < a.length ? a[i] : _minChar;
      final bChar = i < b.length ? b[i] : _minChar;

      if (aChar == bChar) {
        buffer.write(aChar);
        i++;
        continue;
      }

      final aCode = aChar.codeUnitAt(0) - _minChar.codeUnitAt(0);
      final bCode = bChar.codeUnitAt(0) - _minChar.codeUnitAt(0);
      final mid = (aCode + bCode) ~/ 2;

      if (mid > aCode) {
        buffer.write(String.fromCharCode(_minChar.codeUnitAt(0) + mid));
        break;
      }

      buffer.write(aChar);
      i++;

      // If we've exhausted b but not a, we need to add a suffix
      if (i >= b.length) {
        buffer.write('m'); // Midpoint suffix
        break;
      }
    }

    return buffer.toString();
  }

  static FractionalIndex _incrementString(String s) {
    final buffer = StringBuffer();
    bool carry = true;

    for (int i = s.length - 1; i >= 0; i--) {
      if (!carry) {
        buffer.write(s.substring(0, i + 1));
        break;
      }

      final charCode = s.codeUnitAt(i);
      if (charCode < _maxChar.codeUnitAt(0)) {
        buffer.write(s.substring(0, i));
        buffer.write(String.fromCharCode(charCode + 1));
        carry = false;
        break;
      }
    }

    if (carry) {
      return FractionalIndex('${s}a');
    }

    return FractionalIndex(buffer.toString());
  }

  static FractionalIndex _decrementString(String s) {
    int i = 0;
    for (; i < s.length; i++) {
      final charCode = s.codeUnitAt(i);
      if (charCode > _minChar.codeUnitAt(0)) {
        final newChar = String.fromCharCode(charCode - 1);
        return FractionalIndex('${s.substring(0, i)}$newChar');
      }
    }

    // All characters are 'a', prepend new level
    return FractionalIndex('Z$s'); // Z < a
  }

  @override
  String toString() => value;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FractionalIndex &&
          runtimeType == other.runtimeType &&
          value == other.value;

  @override
  int get hashCode => value.hashCode;

  bool operator <(FractionalIndex other) => value.compareTo(other.value) < 0;
  bool operator <=(FractionalIndex other) => value.compareTo(other.value) <= 0;
  bool operator >(FractionalIndex other) => value.compareTo(other.value) > 0;
  bool operator >=(FractionalIndex other) => value.compareTo(other.value) >= 0;
}
