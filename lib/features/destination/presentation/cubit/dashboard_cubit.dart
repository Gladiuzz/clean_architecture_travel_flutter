import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:travel/features/destination/presentation/pages/home_page.dart';

class DashboardCubit extends Cubit<int> {
  DashboardCubit() : super(0);

  change(int i) => emit(i);

  final List menuDashboard = [
    [
      'Home',
      Icons.home,
      const HomePage(),
    ],
    [
      'Near',
      Icons.near_me,
      const Center(
        child: Text('Near me page'),
      )
    ],
    [
      'Favorite',
      Icons.favorite,
      const Center(
        child: Text('Favorite Page'),
      )
    ],
    [
      'Profile',
      Icons.person,
      const Center(
        child: Text('Profile Page'),
      )
    ],
  ];

  Widget get page => menuDashboard[state][2];
}
