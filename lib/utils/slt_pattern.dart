import 'package:crypto/crypto.dart';
import 'package:tcc_projeto_app/pacient/models/pacient_hash_model.dart';
import 'dart:convert';
import 'dart:math';

class SltPattern {
  static const String _ppr = '5gNA2qTaKmHdP94W8s4wCudEQh7uVE9z';

  static final Random _random = Random.secure();

  static String createCryptoString([int length = 32]) {
    var values = List<int>.generate(length, (i) => _random.nextInt(256));

    final String crypto =
        Uri.encodeComponent(base64Url.encode(values).toString());

    return crypto;
  }

  static PacientHashModel pacientHash(id) {
    var salt = createCryptoString();

    var bytes = utf8.encode('$id$salt');

    var key = utf8.encode(_ppr);

    var hmacSha256 = new Hmac(sha256, key);

    var digest = hmacSha256.convert(bytes);

    PacientHashModel pacientHash =
        PacientHashModel(hash: digest.toString(), salt: salt);

    return pacientHash;
  }

  static String retrivepacientHash(id, salt) {
    var bytes = utf8.encode('$id$salt');

    var key = utf8.encode(_ppr);

    var hmacSha256 = new Hmac(sha256, key);

    var digest = hmacSha256.convert(bytes);

    return digest.toString();
  }

  //final _storage = new FlutterSecureStorage();

/*
// Read value 
String value = await storage.read(key: key);

// Read all values
Map<String, String> allValues = await storage.readAll();

// Delete value 
await storage.delete(key: key);

// Delete all 
await storage.deleteAll();

// Write value 
await storage.write(key: key, value: value);
*/
}
