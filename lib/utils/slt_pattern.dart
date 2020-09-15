import 'package:crypto/crypto.dart';
import 'package:tcc_projeto_app/pacient/models/pacient_hash_model.dart';
import 'dart:convert';
import 'dart:math';

class SltPattern {
  static const String _ppr = '5gN2qTa4RW8esf42wCwudhUWD73d5u2p2VVUCbuE9zU=';

  static final Random _random = Random.secure();

  //final _storage = new FlutterSecureStorage();

  static String createCryptoString([int length = 32]) {
    var values = List<int>.generate(length, (i) => _random.nextInt(256));

    return base64Url.encode(values);
  }

  static PacientHashModel pacientHash(id) {
    var salt = createCryptoString();

    var bytes = utf8.encode(_ppr + id + salt);

    //var hmacSha256 = new Hmac(sha256, key);

    //var digest = hmacSha256.convert(bytes);

    var digest = base64Url.encode(bytes);

    PacientHashModel pacientHash = PacientHashModel(hash: digest, salt: salt);

    return pacientHash;
  }

  static String retrivepacientHash(id, salt) {
    var bytes = utf8.encode(_ppr + id + salt);

    var digest = base64Url.encode(bytes);

    return digest;
  }

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
