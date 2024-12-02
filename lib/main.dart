import 'dart:math';
import 'data.dart';
import 'package:flutter/material.dart';
import 'package:war_game/home.dart';

var player1Deck = [];
var player2Deck = [];

void splitDeck(List cardDeck) {
  var deck = List.from(cardDeck);

  int sizeDeck = deck.length;

  for (int i = 0; i < sizeDeck ~/ 2; i++) {
    int random = Random().nextInt(deck.length);
    player1Deck.add(deck[random]);
    deck.removeAt(random);
  }
  //bcz we have to shuffle the deck
  sizeDeck = deck.length;
  for (int i = 0; i < sizeDeck; i++) {
    int random = Random().nextInt(deck.length);
    player2Deck.add(deck[random]);
  }

  //player2Deck = List.from(deck);
}

void main() {
  splitDeck(deck);

  runApp(MaterialApp(
    home: Wargame(player1Deck, player2Deck),
  ));
}
