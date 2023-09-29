import 'package:credible/app/shared/globals.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('TimestampDateValidation', () {
    test('validate_timestamp ', () {
      var timestamp = 22222222;
      var date = DateTime.parse("2022-10-20");
      var result = validate_timestamp(timestamp, date);
      expect(result, isFalse);

      // First second on 2022-10-20:
      timestamp = 1666224000;
      result = validate_timestamp(timestamp, date);
      expect(result, isTrue);

      // During 2022-10-20:
      timestamp = 1666282092;
      result = validate_timestamp(timestamp, date);
      expect(result, isTrue);

      // Last second on 2022-10-20:
      timestamp = 1666310399;
      result = validate_timestamp(timestamp, date);
      expect(result, isTrue);

      // First second on 2022-10-21:
      timestamp = 1666310400;
      result = validate_timestamp(timestamp, date);
      expect(result, isFalse);
    });
  });
}
