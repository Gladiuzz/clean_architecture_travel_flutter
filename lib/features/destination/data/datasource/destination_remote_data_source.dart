import 'dart:convert';

import 'package:travel/api/urls.dart';
import 'package:travel/core/error/exceptions.dart';
import 'package:travel/features/destination/data/models/destination_model.dart';
import 'package:http/http.dart' as http;

abstract class DestinationRemoteDataSource {
  Future<List<DestinationModel>> all();
  Future<List<DestinationModel>> top();
  Future<List<DestinationModel>> search(String query);
}

class DestinationRemoteDataSourceImplementation
    implements DestinationRemoteDataSource {
  final http.Client client;

  DestinationRemoteDataSourceImplementation(this.client);

  @override
  Future<List<DestinationModel>> all() async {
    Uri url = Uri.parse('${URLs.baseUrl}/destination/all.php');
    final response = await client.get(url).timeout(const Duration(seconds: 1));
    if (response.statusCode == 200) {
      List list = jsonDecode(response.body);
      return list.map((e) => DestinationModel.fromJson(e)).toList();
      // list.map((e) => DestinationModel.fromJson(Map.from(e))).toList(); kalau data belum berbentuk map
    } else if (response.statusCode == 404) {
      Map body = jsonDecode(response.body);
      throw NotFoundException(body['message']);
    } else {
      throw ServerException();
    }
  }

  @override
  Future<List<DestinationModel>> search(String query) async {
    Uri url = Uri.parse('${URLs.baseUrl}/destination/search.php');
    final response = await client.post(url, body: {
      'query': query,
    }).timeout(const Duration(seconds: 1));
    if (response.statusCode == 200) {
      List list = jsonDecode(response.body);
      return list.map((e) => DestinationModel.fromJson(e)).toList();
      // list.map((e) => DestinationModel.fromJson(Map.from(e))).toList(); kalau data belum berbentuk map
    } else if (response.statusCode == 404) {
      Map body = jsonDecode(response.body);
      throw NotFoundException(body['message']);
    } else {
      throw ServerException();
    }
  }

  @override
  Future<List<DestinationModel>> top() async {
    Uri url = Uri.parse('${URLs.baseUrl}/destination/top.php');
    final response = await client.get(url).timeout(const Duration(seconds: 1));
    if (response.statusCode == 200) {
      List list = jsonDecode(response.body);
      return list.map((e) => DestinationModel.fromJson(e)).toList();
      // list.map((e) => DestinationModel.fromJson(Map.from(e))).toList(); kalau data belum berbentuk map
    } else if (response.statusCode == 404) {
      Map body = jsonDecode(response.body);
      throw NotFoundException(body['message']);
    } else {
      throw ServerException();
    }
  }
}
