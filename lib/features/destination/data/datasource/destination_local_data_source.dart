import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:travel/core/error/exceptions.dart';
import 'package:travel/features/destination/data/models/destination_model.dart';

const cacheAllDestinationKey = 'all_destination';

abstract class DestinationLocalDataSource {
  Future<List<DestinationModel>> getAll();
  Future<bool> cacheAll(List<DestinationModel> list);
}

class DestinationLocalDataSourceImplementation
    implements DestinationLocalDataSource {
  final SharedPreferences sharedPreferences;

  DestinationLocalDataSourceImplementation(this.sharedPreferences);

  @override
  Future<bool> cacheAll(List<DestinationModel> list) {
    // sesuaikan data dari api
    List<Map<String, dynamic>> listMap = list.map((e) => e.toJson()).toList();
    String allDestination = jsonEncode(listMap);
    return sharedPreferences.setString(cacheAllDestinationKey, allDestination);
  }

  @override
  Future<List<DestinationModel>> getAll() async {
    String? allDestination =
        sharedPreferences.getString(cacheAllDestinationKey);
    if (allDestination != null) {
      List<Map<String, dynamic>> listMap =
          List<Map<String, dynamic>>.from(jsonDecode(allDestination));
      List<DestinationModel> list =
          listMap.map((e) => DestinationModel.fromJson(e)).toList();

      return list;
    }
    throw CachedException();
  }
}
