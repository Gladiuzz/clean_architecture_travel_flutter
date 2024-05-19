import 'package:flutter/material.dart';
import 'package:travel/features/destination/domain/entities/destination_entity.dart';
import 'package:travel/features/destination/presentation/pages/dashboard.dart';
import 'package:travel/features/destination/presentation/pages/detail_destination_page.dart';
import 'package:travel/features/destination/presentation/pages/search_destination_page.dart';

class AppRoute {
  static const dashboard = '/';
  static const detailDestination = '/destination/detail';
  static const searchDestination = '/destination/search';

  static Route<dynamic>? onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case dashboard:
        return MaterialPageRoute(builder: (context) => const Dashboard());
      case detailDestination:
        final destination = settings.arguments;
        if (destination == null) return _invalidArugemntPage;
        if (destination is! DestinationEntity) return _invalidArugemntPage;
        return MaterialPageRoute(
            builder: (context) => DetailDestinationPage(
                  destination: destination,
                ));
      case searchDestination:
        final search = settings.arguments;
        return MaterialPageRoute(
            builder: (context) => SearchDestinationPage(
                  searchText: search.toString(),
                ));
      default:
        return _notFoundPage;
    }
  }

  static MaterialPageRoute get _invalidArugemntPage => MaterialPageRoute(
        builder: (context) => const Scaffold(
          body: Center(
            child: Text('Invalid Argument'),
          ),
        ),
      );

  static MaterialPageRoute get _notFoundPage => MaterialPageRoute(
        builder: (context) => const Scaffold(
          body: Center(
            child: Text('Page Not Found'),
          ),
        ),
      );
}
