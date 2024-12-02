import 'package:flutter/material.dart';

class Wargame extends StatefulWidget {
  const Wargame(this.player1cards, this.player2cards, {super.key});

  final List player1cards;
  final List player2cards;

  @override
  State<Wargame> createState() => _WargameState();
}

class _WargameState extends State<Wargame> {
  List tempGameCards = [];
  List viewGameCards = [];
  bool startWar = false;
  List warGameCards1 = [];
  List warGameCards2 = [];
  int player1Score = 0;
  int player2Score = 0;
  String winnerMessage = "";

  void warGameplay(int offset) {
    if (widget.player1cards.length < offset + 4 ||
        widget.player2cards.length < offset + 4) {
      gameplayStart();
      return;
    }

    List hiddenCardsP1 = widget.player1cards.sublist(offset, offset + 3);
    List hiddenCardsP2 = widget.player2cards.sublist(offset, offset + 3);

    warGameCards1.addAll(hiddenCardsP1);
    warGameCards2.addAll(hiddenCardsP2);

    Map<String, dynamic> warCardP1 = widget.player1cards[offset + 3];
    Map<String, dynamic> warCardP2 = widget.player2cards[offset + 3];

    warGameCards1.add(warCardP1);
    warGameCards2.add(warCardP2);

    if (warCardP1['value'] == warCardP2['value']) {
      warGameplay(offset + 4);
    } else if (warCardP1['value'] > warCardP2['value']) {
      widget.player1cards.addAll(warGameCards1);
      widget.player1cards.addAll(warGameCards2);
      widget.player2cards.removeRange(offset, offset + 4);
      player1Score += warGameCards1.length + warGameCards2.length;
    } else {
      widget.player2cards.addAll(warGameCards1);
      widget.player2cards.addAll(warGameCards2);
      widget.player1cards.removeRange(offset, offset + 4);
      player2Score += warGameCards1.length + warGameCards2.length;
    }

    warGameCards1.clear();
    warGameCards2.clear();
    gameplayStart();
  }

  void checkValues() {
    setState(() {
      if (tempGameCards[0]['value'] == tempGameCards[1]['value']) {
        warGameplay(0);
      } else if (tempGameCards[0]['value'] > tempGameCards[1]['value']) {
        widget.player1cards.add(tempGameCards[1]);
        widget.player2cards.remove(tempGameCards[1]);
        List temp = [tempGameCards[0]];
        widget.player1cards.remove(temp[0]);
        widget.player1cards.add(temp[0]);
        player1Score++;
      } else if (tempGameCards[0]['value'] < tempGameCards[1]['value']) {
        widget.player2cards.add(tempGameCards[0]);
        widget.player1cards.remove(tempGameCards[0]);
        List temp = [tempGameCards[1]];
        widget.player2cards.remove(temp[0]);
        widget.player2cards.add(temp[0]);
        player2Score++;
      }
      tempGameCards = [];
    });
  }

  void checkWinner() {
    setState(() {
      if (widget.player1cards.isEmpty) {
        winnerMessage = "Player 2 Wins!";
      } else if (widget.player2cards.isEmpty) {
        winnerMessage = "Player 1 Wins!";
      }
    });
  }

  void gameplayStart() {
    setState(() {
      if (widget.player1cards.isNotEmpty && widget.player2cards.isNotEmpty) {
        int random1 = 0;
        int random2 = 0;

        var cardPlayer1 = widget.player1cards[random1];
        var cardPlayer2 = widget.player2cards[random2];

        tempGameCards = [cardPlayer1, cardPlayer2];
        viewGameCards = List.from(tempGameCards);

        checkValues();
      } else {
        checkWinner();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "War Game",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.green,
        centerTitle: true,
      ),
      body: Container(
        color: Colors.green,
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text(
                  "Player 1: $player1Score",
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  "Player 2: $player2Score",
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/img/card_back.png',
                  width: 75,
                ),
              ],
            ),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (winnerMessage.isNotEmpty)
                    Text(
                      winnerMessage,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (viewGameCards.isNotEmpty)
                        Image.asset(
                          viewGameCards[1]['image'],
                          width: 75,
                        ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (viewGameCards.isNotEmpty)
                        Image.asset(
                          viewGameCards[0]['image'],
                          width: 75,
                        ),
                    ],
                  ),
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: gameplayStart,
                  child: Image.asset(
                    'assets/img/card_back.png',
                    width: 75,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
