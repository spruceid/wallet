class SsiData {}

class SsiCredential extends SsiData {}

class SsiPresentation extends SsiData {}

class Ssi {
  static dynamic parse(String data) {
    if (data != null && data.isNotEmpty) {
      if (data == 'schema://domain.tld/receive') {
        return SsiCredential();
      } else if (data == 'schema://domain.tld/present') {
        return SsiPresentation();
      }

      throw SsiFormatException('Data must be an url');
    }

    throw SsiFormatException('Data cannot be null');
  }
}

class SsiFormatException implements Exception {
  final String message;

  SsiFormatException(this.message);
}
