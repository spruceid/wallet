import 'package:flutter/foundation.dart';

class DERDecoder {
  static Uint8List decodeECDSA(Uint8List der) {
    debugPrint('decode $der');
    final len = der.length;

    debugPrint('input length = $len');
    if (len < 70 || len > 72) {
      throw Exception('Invalid byte sequence, expected size >=70 and <=72');
    }

    debugPrint('[0] = ${der[0]}');
    if (der[0] != 0x30) {
      throw Exception(
          'Invalid byte sequence, expected COMPOUND STRUCTURE at 0');
    }

    // final lenRInt = der[1];
    debugPrint('[2] = ${der[2]}');
    if (der[2] != 0x02) {
      throw Exception('Invalid byte sequence, expected INTEGER at 2');
    }

    debugPrint('r length = ${der[3]}');
    final lenR = der[3];
    final end = 4 + lenR;
    final r = der.sublist(4, end);
    debugPrint('r = $r');

    // final lenSInt = der[end];
    debugPrint('[$end] = ${der[end]}');
    if (der[end] != 0x02) {
      throw Exception('Invalid byte sequence, expected INTEGER at $end');
    }

    debugPrint('s length = ${der[end + 1]}');
    final lenS = der[end + 1];
    final start = end + 2;
    final s = der.sublist(start, start + lenS);
    debugPrint('s = $s');

    final List<int> actualR;
    if (r.length > 32) {
      actualR = r.skip(1).toList();
    } else {
      actualR = r;
    }

    debugPrint('actual r = $actualR');

    final List<int> actualS;
    if (s.length > 32) {
      actualS = s.skip(1).toList();
    } else {
      actualS = s;
    }

    debugPrint('actual s = $actualS');

    final sig = actualR + actualS;

    debugPrint('signature = $sig');

    return Uint8List.fromList(sig);
  }
}
