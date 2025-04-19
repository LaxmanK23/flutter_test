import 'dart:async';

import 'package:flutter/material.dart';

import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter Demo',
        home: BlocProvider(
          create: (_) => CityBloc(
            CitySearchState.initial(),
          ),
          child: MyHomePage(),
        ));
  }
}

class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Search Delegate'),
      ),
      body: Container(
        child: Center(
          child: TextButton(
            child: Text('Show search'),
            onPressed: () async {
              City? selected = await showSearch<City>(
                context: context,
                delegate: CitySearch(BlocProvider.of<CityBloc>(context)),
              );
              print(selected);
            },
          ),
        ),
      ),
    );
  }
}

class City {
  final String name;

  const City(this.name);

  @override
  String toString() => 'City { name: $name }';
}

class CitySearch extends SearchDelegate<City> {
  final Bloc<CitySearchEvent, CitySearchState> cityBloc;

  CitySearch(this.cityBloc);

  @override
  List<Widget> buildActions(BuildContext context) => [
        IconButton(
          icon: Icon(Icons.clear),
          onPressed: () {
            query = '';
          },
        )
      ];

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: BackButtonIcon(),
      onPressed: () {
        // close(context,);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    cityBloc.add(CitySearchEvent(query));

    return BlocBuilder(
      bloc: cityBloc,
      builder: (BuildContext context, CitySearchState state) {
        if (state.isLoading) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
        if (state.hasError) {
          return Container(
            child: Text('Error'),
          );
        }
        return ListView.builder(
          itemBuilder: (context, index) {
            return ListTile(
              leading: Icon(Icons.location_city),
              title: Text(state.cities[index].name),
              onTap: () => close(context, state.cities[index]),
            );
          },
          itemCount: state.cities.length,
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) => Container();
}

class CitySearchEvent {
  final String query;

  const CitySearchEvent(this.query);

  @override
  String toString() => 'CitySearchEvent { query: $query }';
}

class CitySearchState {
  final bool isLoading;
  final List<City> cities;
  final bool hasError;

  const CitySearchState(
      {required this.isLoading, required this.cities, required this.hasError});

  factory CitySearchState.initial() {
    return CitySearchState(
      cities: [],
      isLoading: false,
      hasError: false,
    );
  }

  factory CitySearchState.loading() {
    return CitySearchState(
      cities: [],
      isLoading: true,
      hasError: false,
    );
  }

  factory CitySearchState.success(List<City> cities) {
    return CitySearchState(
      cities: cities,
      isLoading: false,
      hasError: false,
    );
  }

  factory CitySearchState.error() {
    return CitySearchState(
      cities: [],
      isLoading: false,
      hasError: true,
    );
  }

  @override
  String toString() =>
      'CitySearchState {cities: ${cities.toString()}, isLoading: $isLoading, hasError: $hasError }';
}

class CityBloc extends Bloc<CitySearchEvent, CitySearchState> {
  CityBloc(super.initialState);

  @override
  CitySearchState get initialState => CitySearchState.initial();

  @override
  void onTransition(Transition<CitySearchEvent, CitySearchState> transition) {
    print(transition.toString());
  }

  @override
  Stream<CitySearchState> mapEventToState(CitySearchEvent event) async* {
    yield CitySearchState.loading();

    try {
      List<City> cities = await _getSearchResults(event.query);
      yield CitySearchState.success(cities);
    } catch (_) {
      yield CitySearchState.error();
    }
  }

  Future<List<City>> _getSearchResults(String query) async {
    // Simulating network latency
    await Future.delayed(Duration(seconds: 1));
    return [City('Chicago'), City('Los Angeles')];
  }
}
