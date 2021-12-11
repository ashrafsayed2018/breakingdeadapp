import 'dart:math';

import 'package:animated_text_kit/animated_text_kit.dart';
import '../../business_logic/cubit/characters_cubit.dart';
import '../../constants/app_colors.dart';
import '../../data/models/character.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CharacterDetailsScreen extends StatelessWidget {
  final Character character;
  const CharacterDetailsScreen({
    Key? key,
    required this.character,
  }) : super(key: key);

  Widget buildSliverAppBar() {
    return SliverAppBar(
      expandedHeight: 600,
      pinned: true,
      stretch: true,
      backgroundColor: AppColors.grey,
      flexibleSpace: FlexibleSpaceBar(
        centerTitle: true,
        title: Text(
          character.nickName,
          style: const TextStyle(
            color: AppColors.white,
          ),
        ),
        background: Hero(
          tag: character.charId,
          child: Image.network(
            character.image,
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }

  Widget characterInfo(String title, String value) {
    return RichText(
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      text: TextSpan(
        children: [
          TextSpan(
            text: title,
            style: const TextStyle(
              color: AppColors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          TextSpan(
            text: value,
            style: const TextStyle(
              color: AppColors.white,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

  Widget buildDevider(double endIndent) {
    return Divider(
      height: 30,
      endIndent: endIndent,
      color: AppColors.yellow,
      thickness: 2,
    );
  }

  Widget checkIfQoutesAreLoaded(CharactersState state) {
    if (state is QuotesLoaded) {
      return displayRandomQouteOrEmptySpace(state);
    } else {
      return showProgressIndecator();
    }
  }

  Widget displayRandomQouteOrEmptySpace(state) {
    var quotes = state.quotes;

    if (quotes.length != 0) {
      int randomQuoteIndex = Random().nextInt(quotes.length - 1);
      return Center(
        child: DefaultTextStyle(
          textAlign: TextAlign.center,
          style:
              const TextStyle(fontSize: 20, color: AppColors.white, shadows: [
            Shadow(
              blurRadius: 7,
              color: AppColors.yellow,
              offset: Offset(0, 0),
            )
          ]),
          child: AnimatedTextKit(
            animatedTexts: [
              FlickerAnimatedText(
                quotes[randomQuoteIndex].quote,
              )
            ],
            repeatForever: true,
          ),
        ),
      );
    } else {
      return Container();
    }
  }

  Widget showProgressIndecator() {
    return const Center(
      child: CircularProgressIndicator(
        color: AppColors.yellow,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    BlocProvider.of<CharactersCubit>(context).getAllQuotes(character.name);

    return Scaffold(
      backgroundColor: AppColors.grey,
      body: CustomScrollView(
        slivers: [
          buildSliverAppBar(),
          SliverList(
            delegate: SliverChildListDelegate(
              [
                Container(
                  margin: const EdgeInsets.fromLTRB(14, 14, 14, 0),
                  padding: const EdgeInsets.all(8),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      characterInfo("Job : ", character.jobs.join(" / ")),
                      buildDevider(320),
                      characterInfo(
                          "Appeared in : ", character.categoryForTwoSeries),
                      buildDevider(265),
                      characterInfo("Sessions : ",
                          character.appearanceOfSessions.join(" , ")),
                      buildDevider(290),
                      characterInfo("Status : ", character.statusIfDeadOrAlive),
                      buildDevider(300),
                      character.betterCallSaulAppearence.isEmpty
                          ? Container()
                          : characterInfo("Better call sawl session : ",
                              character.betterCallSaulAppearence.join(" / ")),
                      character.betterCallSaulAppearence.isEmpty
                          ? Container()
                          : buildDevider(170),
                      characterInfo("Actor/Actress : ", character.actorName),
                      buildDevider(250),
                      const SizedBox(
                        height: 20,
                      ),
                      BlocBuilder<CharactersCubit, CharactersState>(
                        builder: (context, state) {
                          return checkIfQoutesAreLoaded(state);
                        },
                      )
                    ],
                  ),
                ),
                const SizedBox(
                  height: 500,
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
