import 'package:credible/app/pages/credentials/models/credential.dart';
import 'package:credible/app/pages/credentials/models/credential_status.dart';
import 'package:dio/dio.dart';
import 'package:flutter_modular/flutter_modular.dart';

class CredentialsRepository extends Disposable {
  final Dio client;

  static final _mockData = [
    CredentialModel(
      id: 'ab98-cd76',
      issuer: 'Company A',
      image: 'abcd12',
      status: CredentialStatus.active,
    ),
    CredentialModel(
      id: 'ab98-cd75',
      issuer: 'Organization B',
      image: 'abcd13',
      status: CredentialStatus.expired,
    ),
    CredentialModel(
      id: 'ab98-cd74',
      issuer: 'Government C',
      image: 'abcd14',
      status: CredentialStatus.revoked,
    ),
  ];

  CredentialsRepository(this.client);

  Future<List<CredentialModel>> findAll(/* dynamic filters */) async {
    // final response =
    //     await client.get('credentials');

    await Future.delayed(Duration(milliseconds: 2500));

    return _mockData;
  }

  Future<CredentialModel> findById(String id) async {
    // final response =
    //     await client.get('credentials/$id');

    return _mockData.firstWhere(
      (d) => d.id == id,
      orElse: () => null,
    );
  }

  @override
  void dispose() {}
}
