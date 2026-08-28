/// Shared JSON coercions.
///
/// The API returns money as plain JSON numbers, which Dart decodes as `int`
/// whenever the value has no fractional part. Every monetary field runs through
/// these so `0` and `0.0` both arrive as a double.
double toDouble(Object? value) => switch (value) {
      num n => n.toDouble(),
      String s => double.tryParse(s) ?? 0,
      _ => 0,
    };

double? toDoubleOrNull(Object? value) =>
    value == null ? null : toDouble(value);
