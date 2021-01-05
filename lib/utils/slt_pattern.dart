import 'dart:typed_data';

import 'package:crypto/crypto.dart';
import 'package:tcc_projeto_app/pacient/models/pacient_hash_model.dart';
import 'dart:convert';
import 'dart:math';
import 'package:encrypt/encrypt.dart';

class SltPattern {
  static final _initVector = IV.fromSecureRandom(16);
  static final _cryptoKey = Key.fromSecureRandom(16);

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

  static String retrivepacientHash(cpf, salt) {
    var bytes = utf8.encode('$cpf$salt');

    var key = utf8.encode(_ppr);

    var hmacSha256 = new Hmac(sha256, key);

    var digest = hmacSha256.convert(bytes);

    return digest.toString();
  }

  static String encryptImageBytes(Uint8List imageBytes) {
    var encrypter = Encrypter(AES(_cryptoKey));
    var encripedBytes = encrypter.encryptBytes(imageBytes);

    return base64.encode(encripedBytes.bytes);
  }

  static String encodeImageBytes(List<int> imageBytes) {
    return base64.encode(imageBytes);
  }

  static List<int> decodeImageBytes(String encodedBytes) {
    return base64.decode(encodedBytes);
  }

  static List<int> decryptImageBytes(String encriptedBytes) {
    var decodedBytes = base64.decode(encriptedBytes);
    var encrypted = Encrypted(decodedBytes);
    var decrypter = Encrypter(AES(_cryptoKey));

    return Uint8List.fromList(decrypter.decryptBytes(encrypted));
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
