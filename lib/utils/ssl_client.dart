import 'package:http/io_client.dart';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;

class SSLClient extends IOClient{

  Future<SecurityContext> get globalContext async {
    final sslCert = await rootBundle.load('certificates/certificates.cer');
    SecurityContext securityContext = SecurityContext(withTrustedRoots: false);
    securityContext.setTrustedCertificatesBytes(sslCert.buffer.asInt8List());
    return securityContext;
  }

  @override
  Future<http.Response> get(Uri url, {Map<String, String>? headers}) async {
    // Http Client
    HttpClient httpClient = HttpClient(context: await globalContext);
    httpClient.badCertificateCallback = (
        X509Certificate cert,
        String host,
        int port
        ) => false;

    var result = await IOClient(httpClient).get(url);
    return result;
  }
}