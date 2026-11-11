import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'app_preferences.dart';
import 'city_dto.dart';
import 'city_search_bloc.dart';
import 'city_repository.dart';
import 'l10n/generated/app_localizations.dart';
import 'photon_repository.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  final CityRepository repository;
  final AppPreferences preferences;

  MyApp({super.key, CityRepository? repository, AppPreferences? preferences})
    : repository = repository ?? PhotonRepository(),
      preferences = preferences ?? AppPreferences();

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Locale? _locale = const Locale('ru');

  @override
  void initState() {
    super.initState();
    _restoreLanguage();
  }

  Future<void> _restoreLanguage() async {
    try {
      final languageCode = await widget.preferences.loadLanguage();
      if (!mounted || (languageCode != 'ru' && languageCode != 'en')) return;
      setState(() => _locale = Locale(languageCode!));
    } catch (_) {}
  }

  void _toggleLanguage() {
    final systemLanguage = WidgetsBinding.instance.platformDispatcher.locale;
    final currentCode =
        _locale?.languageCode ??
        (systemLanguage.languageCode == 'en' ? 'en' : 'ru');
    final nextCode = currentCode == 'ru' ? 'en' : 'ru';
    setState(() => _locale = Locale(nextCode));
    unawaited(widget.preferences.saveLanguage(nextCode).catchError((_) {}));
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
        scaffoldBackgroundColor: const Color(0xFFF2F8F7),
      ),
      onGenerateTitle: (context) => AppLocalizations.of(context)!.appTitle,
      locale: _locale,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: BlocProvider(
        create: (_) => CitySearchBloc(widget.repository),
        child: CitySearchPage(
          preferences: widget.preferences,
          onLanguageToggle: _toggleLanguage,
        ),
      ),
    );
  }
}

class CitySearchPage extends StatefulWidget {
  final AppPreferences preferences;
  final VoidCallback onLanguageToggle;

  const CitySearchPage({
    super.key,
    required this.preferences,
    required this.onLanguageToggle,
  });

  @override
  State<CitySearchPage> createState() => _CitySearchPageState();
}

class _CitySearchPageState extends State<CitySearchPage> {
  final controller = TextEditingController();
  final likedIds = <int>{};

  @override
  void initState() {
    super.initState();
    _loadLikes();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  void search() {
    FocusScope.of(context).unfocus();
    context.read<CitySearchBloc>().add(
      SearchSubmitted(
        controller.text,
        languageCode: Localizations.localeOf(context).languageCode,
      ),
    );
  }

  Future<void> _loadLikes() async {
    try {
      final savedIds = await widget.preferences.loadLikedCityIds();
      if (mounted) setState(() => likedIds.addAll(savedIds));
    } catch (_) {}
  }

  void toggleLanguage() {
    final nextLanguage = Localizations.localeOf(context).languageCode == 'ru'
        ? 'en'
        : 'ru';
    widget.onLanguageToggle();
    final bloc = context.read<CitySearchBloc>();
    if (bloc.state.query.trim().length >= 2) {
      bloc.add(SearchSubmitted(bloc.state.query, languageCode: nextLanguage));
    }
  }

  void toggleLike(CityDto city) {
    setState(() {
      if (likedIds.contains(city.id)) {
        likedIds.remove(city.id);
      } else {
        likedIds.add(city.id);
      }
    });
    unawaited(widget.preferences.saveLikedCityIds(likedIds).catchError((_) {}));
    final strings = AppLocalizations.of(context)!;
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(
            likedIds.contains(city.id)
                ? strings.likedCity(city.name)
                : strings.unlikedCity(city.name),
          ),
        ),
      );
  }

  Widget buildResults(CitySearchState state) {
    final strings = AppLocalizations.of(context)!;
    late final List<Widget> children;
    switch (state.status) {
      case CitySearchStatus.initial:
        final message = state.query.trim().isEmpty
            ? strings.typeCity
            : state.query.trim().length < 2
            ? strings.shortQuery
            : strings.waitingSearch;
        children = [SizedBox(height: 300, child: Center(child: Text(message)))];
        break;
      case CitySearchStatus.loading:
        children = const [
          SizedBox(
            height: 300,
            child: Center(child: CircularProgressIndicator()),
          ),
        ];
        break;
      case CitySearchStatus.failure:
        children = [
          SizedBox(
            height: 300,
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Text(
                  state.failure == CitySearchFailure.shortQuery
                      ? strings.shortQuery
                      : strings.searchError,
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
        ];
        break;
      case CitySearchStatus.success:
        children = state.cities.isEmpty
            ? [
                SizedBox(
                  height: 300,
                  child: Center(child: Text(strings.noCities)),
                ),
              ]
            : state.cities
                  .map(
                    (city) => CityCard(
                      city: city,
                      isLiked: likedIds.contains(city.id),
                      onLike: () => toggleLike(city),
                    ),
                  )
                  .toList();
        break;
    }

    return ListView(
      physics: const AlwaysScrollableScrollPhysics(),
      children: children,
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CitySearchBloc, CitySearchState>(
      builder: (context, state) {
        final strings = AppLocalizations.of(context)!;
        return Scaffold(
          appBar: AppBar(
            title: Text(strings.searchTitle),
            backgroundColor: const Color(0xFFB2DFDB),
            actions: [
              IconButton(
                onPressed: toggleLanguage,
                tooltip: strings.switchLanguage,
                icon: Text(
                  Localizations.localeOf(context).languageCode == 'ru'
                      ? 'EN'
                      : 'RU',
                ),
              ),
              IconButton(
                onPressed: state.isLoading || state.query.trim().length < 2
                    ? null
                    : () => context.read<CitySearchBloc>().add(
                        const RefreshRequested(),
                      ),
                tooltip: strings.refreshList,
                icon: const Icon(Icons.refresh),
              ),
            ],
          ),
          body: SafeArea(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: controller,
                          textInputAction: TextInputAction.search,
                          onChanged: (query) =>
                              context.read<CitySearchBloc>().add(
                                SearchTextChanged(
                                  query,
                                  languageCode: Localizations.localeOf(context)
                                      .languageCode,
                                ),
                              ),
                          onSubmitted: (_) => search(),
                          decoration: InputDecoration(
                            labelText: strings.searchLabel,
                            hintText: strings.searchHint,
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      IconButton.filled(
                        onPressed: search,
                        tooltip: strings.searchButton,
                        icon: const Icon(Icons.search),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: RefreshIndicator(
                    onRefresh: () async {
                      if (state.isLoading || state.query.trim().length < 2) {
                        return;
                      }
                      final bloc = context.read<CitySearchBloc>();
                      final completed = bloc.stream.firstWhere(
                        (nextState) => !nextState.isLoading,
                      );
                      bloc.add(const RefreshRequested());
                      await completed;
                    },
                    child: buildResults(state),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class CityCard extends StatelessWidget {
  final CityDto city;
  final bool isLiked;
  final VoidCallback onLike;

  const CityCard({
    super.key,
    required this.city,
    required this.isLiked,
    required this.onLike,
  });

  @override
  Widget build(BuildContext context) {
    final strings = AppLocalizations.of(context)!;
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Material(
        color: const Color(0xFFB2DFDB),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: const BorderSide(color: Color(0xFF80CBC4)),
        ),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute<void>(builder: (_) => CityDetails(city)),
            );
          },
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        city.name,
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                      Text('${city.country}\n${city.region}'),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                CountryFlag(city.countryCode, countryName: city.country),
                IconButton(
                  onPressed: onLike,
                  tooltip: isLiked ? strings.removeLike : strings.addLike,
                  isSelected: isLiked,
                  icon: Icon(
                    isLiked ? Icons.favorite : Icons.favorite_border,
                    color: isLiked ? Colors.red : Colors.black,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class CountryFlag extends StatelessWidget {
  final String code;
  final String countryName;

  const CountryFlag(this.code, {super.key, this.countryName = ''});

  @override
  Widget build(BuildContext context) {
    if (code.isEmpty) return const Icon(Icons.location_city, size: 48);
    return Image.network(
      'https://flagcdn.com/w160/${code.toLowerCase()}.png',
      width: 64,
      height: 48,
      fit: BoxFit.contain,
      semanticLabel: AppLocalizations.of(context)!.flagLabel(countryName),
      errorBuilder: (_, _, _) => const Icon(Icons.location_city, size: 48),
    );
  }
}

class CityDetails extends StatelessWidget {
  final CityDto city;

  const CityDetails(this.city, {super.key});

  @override
  Widget build(BuildContext context) {
    final strings = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        title: Text(city.name),
        backgroundColor: const Color(0xFFB2DFDB),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CountryFlag(city.countryCode, countryName: city.country),
            const SizedBox(height: 16),
            Text(city.name, style: Theme.of(context).textTheme.headlineMedium),
            const SizedBox(height: 16),
            Text(
              '${strings.countryLabel}: ${city.country}\n'
              '${strings.regionLabel}: ${city.region}\n'
              '${strings.populationLabel}: ${city.population ?? strings.notAvailable}\n'
              '${strings.latitudeLabel}: ${city.latitude}\n'
              '${strings.longitudeLabel}: ${city.longitude}\n'
              '${strings.timezoneLabel}: ${city.timezone.isEmpty ? strings.notAvailable : city.timezone}',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ],
        ),
      ),
    );
  }
}
