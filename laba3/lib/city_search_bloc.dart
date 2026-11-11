import 'package:flutter/foundation.dart';

import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'city_dto.dart';
import 'city_repository.dart';

enum CitySearchStatus { initial, loading, success, failure }

enum CitySearchFailure { shortQuery, network }

class CitySearchState {
  final String query;
  final List<CityDto> cities;
  final CitySearchStatus status;
  final CitySearchFailure? failure;
  final String languageCode;

  const CitySearchState({
    this.query = '',
    this.cities = const [],
    this.status = CitySearchStatus.initial,
    this.failure,
    this.languageCode = 'ru',
  });

  bool get isLoading => status == CitySearchStatus.loading;
}

sealed class CitySearchEvent {
  const CitySearchEvent();
}

class SearchTextChanged extends CitySearchEvent {
  final String query;
  final String languageCode;

  const SearchTextChanged(this.query, {this.languageCode = 'ru'});
}

class SearchSubmitted extends CitySearchEvent {
  final String query;
  final String languageCode;

  const SearchSubmitted(this.query, {this.languageCode = 'ru'});
}

class RefreshRequested extends CitySearchEvent {
  const RefreshRequested();
}

class CitySearchBloc extends Bloc<CitySearchEvent, CitySearchState> {
  final CityRepository _repository;
  Timer? _debounce;
  int _requestId = 0;

  CitySearchBloc(this._repository) : super(const CitySearchState()) {
    on<CitySearchEvent>(_onEvent);
  }

  Future<void> _onEvent(
    CitySearchEvent event,
    Emitter<CitySearchState> emit,
  ) async {
    switch (event) {
      case SearchTextChanged():
        _debounce?.cancel();
        _requestId++;
        emit(
          CitySearchState(
            query: event.query,
            status: CitySearchStatus.initial,
            languageCode: event.languageCode,
          ),
        );
        if (event.query.trim().length >= 2) {
          _debounce = Timer(const Duration(milliseconds: 500), () {
            add(SearchSubmitted(event.query, languageCode: event.languageCode));
          });
        }
        break;
      case SearchSubmitted():
        _debounce?.cancel();
        await _search(event.query, event.languageCode, emit);
        break;
      case RefreshRequested():
        if (state.query.trim().length >= 2) {
          await _search(state.query, state.languageCode, emit);
        }
        break;
    }
  }

  Future<void> _search(
    String query,
    String languageCode,
    Emitter<CitySearchState> emit,
  ) async {
    final normalizedQuery = query.trim();
    if (normalizedQuery.length < 2) {
      emit(
        CitySearchState(
          query: normalizedQuery,
          status: CitySearchStatus.failure,
          failure: CitySearchFailure.shortQuery,
          languageCode: languageCode,
        ),
      );
      return;
    }

    final requestId = ++_requestId;
    emit(
      CitySearchState(
        query: normalizedQuery,
        status: CitySearchStatus.loading,
        languageCode: languageCode,
      ),
    );

    try {
      final repository = _repository;
      final cities = repository is LocalizedCityRepository
          ? await repository.searchCities(
              normalizedQuery,
              language: languageCode,
            )
          : await repository.searchCities(normalizedQuery);
      if (requestId != _requestId) return;
      emit(
        CitySearchState(
          query: normalizedQuery,
          cities: cities,
          status: CitySearchStatus.success,
          languageCode: languageCode,
        ),
      );
    } catch (error) {
      if (kDebugMode) debugPrint('City search failed: $error');
      if (requestId != _requestId) return;
      emit(
        CitySearchState(
          query: normalizedQuery,
          status: CitySearchStatus.failure,
          failure: CitySearchFailure.network,
          languageCode: languageCode,
        ),
      );
    }
  }

  @override
  Future<void> close() {
    _debounce?.cancel();
    return super.close();
  }
}
