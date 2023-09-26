import 'dart:io';
import 'dart:convert';
import 'package:credible/app/pages/profile/models/root.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/src/intl/date_format.dart';

final rootCandidatesExample = jsonDecode(
    File('test/data/root_candidates_example.json').readAsStringSync());

void main() {
  group('RootCandidateModel', () {
    test('.fromMap() should convert a root candidate map', () {
      final rootCandidateExample = jsonDecode('''{
            "did": "did:ion:test:EiAcmytgsm-AUWtmJ9cioW-MWq-DnjIUfGYdIVUnrpg6kw",
            "txid": "1fae017f2c9f14cec0487a04b3f1d1b7336bd38547f755748beb635296de3ee8"
        }''');

      final model = RootCandidateModel.fromMap(rootCandidateExample);
      expect(
          model.did,
          equals(
              'did:ion:test:EiAcmytgsm-AUWtmJ9cioW-MWq-DnjIUfGYdIVUnrpg6kw'));
      expect(
          model.txid,
          equals(
              '1fae017f2c9f14cec0487a04b3f1d1b7336bd38547f755748beb635296de3ee8'));
    });
  });

  group('RootCandidatesModel', () {
    test('.fromMap() throws FormatException if date cannot be parsed', () {
      final badDateExample = jsonDecode('''{
        "date": "2022x-10-20",
        "rootCandidates": []
      }''');
      expect(
          () => RootCandidatesModel.fromMap(badDateExample), throwsException);

      // Note: the DateTime.parse() method accepts out-of-range values and
      // interprets them as overflows. If necessary, use instead the
      // DateFormat.parseStrict() method from the intl package.
      final overflowDateExample = jsonDecode('''{
        "date": "2022-10-44",
        "rootCandidates": []
      }''');
      final model = RootCandidatesModel.fromMap(overflowDateExample);
      expect(model.date, equals(DateTime.parse('2022-11-13')));
    });

    test('.fromMap() should convert a root candidates response map', () {
      final model = RootCandidatesModel.fromMap(rootCandidatesExample);

      expect(model.date, equals(DateTime.parse('2022-10-20')));

      expect(model.candidates, isNotEmpty);
      expect(model.candidates.length, equals(38));
    });
  });
}
