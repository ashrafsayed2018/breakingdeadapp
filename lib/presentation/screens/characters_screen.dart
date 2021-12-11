import '../../business_logic/cubit/characters_cubit.dart';
import '../../constants/app_colors.dart';
import '../../data/models/character.dart';
import '../widgets/character_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_offline/flutter_offline.dart';

class CharactersScreen extends StatefulWidget {
  const CharactersScreen({Key? key}) : super(key: key);

  @override
  State<CharactersScreen> createState() => _CharactersScreenState();
}

class _CharactersScreenState extends State<CharactersScreen> {
  late List<Character> allCharacters;
  late List<Character> searchedCharacters;
  bool _isSearching = false;
  final _searchTextController = TextEditingController();

  Widget _buildSearchFeild() {
    return TextField(
      controller: _searchTextController,
      cursorColor: AppColors.grey,
      decoration: const InputDecoration(
        hintText: "search for a character",
        border: InputBorder.none,
        hintStyle: TextStyle(
          color: AppColors.grey,
          fontSize: 18,
        ),
      ),
      style: const TextStyle(color: AppColors.grey, fontSize: 18),
      onChanged: (searchedCharacter) {
        _addSearchedItemToSearchedList(searchedCharacter);
      },
    );
  }

  void _addSearchedItemToSearchedList(searchedCharacter) {
    searchedCharacters = allCharacters
        .where(
          (character) =>
              character.name.toLowerCase().contains(searchedCharacter),
        )
        .toList();

    setState(() {});
  }

  List<Widget> _buildAppBarActions() {
    if (_isSearching) {
      return [
        IconButton(
          onPressed: () {
            _clearSearch();
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.clear,
            color: AppColors.grey,
          ),
        )
      ];
    } else {
      return [
        IconButton(
          onPressed: _startSearch,
          icon: const Icon(
            Icons.search,
            color: AppColors.grey,
          ),
        )
      ];
    }
  }

  void _startSearch() {
    ModalRoute.of(context)!
        .addLocalHistoryEntry(LocalHistoryEntry(onRemove: _stopSearching));
    setState(() {
      _isSearching = true;
    });
  }

  void _stopSearching() {
    _clearSearch();
    setState(() {
      _isSearching = false;
    });
  }

  void _clearSearch() {
    setState(() {
      _searchTextController.clear();
    });
  }

  @override
  void initState() {
    super.initState();
    BlocProvider.of<CharactersCubit>(context).getAllCharacters();
  }

  Widget buildBlocWidget() {
    return BlocBuilder<CharactersCubit, CharactersState>(
        builder: (context, state) {
      if (state is CharactersLoaded) {
        allCharacters = state.characters;
        return buildLoadListWidget();
      } else {
        return showLoadingIndicator();
      }
    });
  }

  Widget buildLoadListWidget() {
    return SingleChildScrollView(
      child: Container(
        color: AppColors.grey,
        child: Column(
          children: [
            buildCharactersList(),
          ],
        ),
      ),
    );
  }

  Widget buildCharactersList() {
    return GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            childAspectRatio: 2 / 3,
            crossAxisCount: 2,
            crossAxisSpacing: 1,
            mainAxisSpacing: 1),
        shrinkWrap: true,
        physics: const ClampingScrollPhysics(),
        padding: EdgeInsets.zero,
        itemCount: _searchTextController.text.isEmpty
            ? allCharacters.length
            : searchedCharacters.length,
        itemBuilder: (context, index) {
          return CharacterItem(
            character: _searchTextController.text.isEmpty
                ? allCharacters[index]
                : searchedCharacters[index],
          );
        });
  }

  Widget showLoadingIndicator() {
    return const Center(
      child: CircularProgressIndicator(
        color: AppColors.yellow,
      ),
    );
  }

  Widget _buidAppBarTitle() {
    return const Text(
      "Characters",
      style: TextStyle(color: AppColors.grey),
    );
  }

  Widget buildNoInterntWidget() {
    return Center(
      child: Container(
        color: Colors.white,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "can't connect check the internet",
              style: TextStyle(
                fontSize: 22,
                color: AppColors.grey,
              ),
            ),
            Image.asset("assets/icons/offline.svg"),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.yellow,
        title: _isSearching ? _buildSearchFeild() : _buidAppBarTitle(),
        leading: _isSearching
            ? const BackButton(
                color: AppColors.grey,
              )
            : Container(),
        actions: _buildAppBarActions(),
      ),
      body: OfflineBuilder(
        connectivityBuilder: (
          BuildContext context,
          ConnectivityResult connectivity,
          Widget child,
        ) {
          final bool connected = connectivity != ConnectivityResult.none;
          if (connected) {
            return buildBlocWidget();
          } else {
            return buildNoInterntWidget();
          }
        },
        child: showLoadingIndicator(),
      ),
    );
  }
}
