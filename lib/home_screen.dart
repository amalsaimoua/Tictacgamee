// ignore_for_file: avoid_print, curly_braces_in_flow_control_structures
import 'package:flutter/material.dart';
import 'package:tictacgame/game_logic.dart';

class ticTac extends StatefulWidget {
  const ticTac({Key? key}) : super(key: key);

  @override
  _ticTacState createState() => _ticTacState();
}

class _ticTacState extends State<ticTac> {
  String activePlayer = 'X';
  bool gameOver = false;
  int turn = 0;
  String result = '';
  bool isSwitched = false;
  Game game = Game();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: SafeArea(
          child: Column(
        children: [
          SwitchListTile.adaptive(
              inactiveTrackColor: Colors.white,
              title: const Text(
                'Turn on/off two players mode',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 15,
                  color: Colors.white,
                ),
              ),
              value: (isSwitched),
              onChanged: (newVal) {
                setState(() {
                  isSwitched = newVal;
                });
              }),
          Text(
            "It's $activePlayer turn".toUpperCase(),
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 35,
              color: Colors.white,
            ),
          ),
          Expanded(
            child: GridView.count(
              children: List.generate(
                9,
                (index) => InkWell(
                  borderRadius: BorderRadius.circular(16),
                  onTap: () => _onTap(index),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      color: Theme.of(context).shadowColor,
                    ),
                    child: Center(
                        child: Text(
                      Player.playerX.contains(index)
                          ? 'X'
                          : Player.playerO.contains(index)
                              ? 'O'
                              : '',
                      style: TextStyle(
                          color: Player.playerX.contains(index)
                              ? Colors.blue
                              : Colors.pink,
                          fontSize: 30),
                    )),
                  ),
                ),
              ),
              padding: const EdgeInsets.all(16),
              crossAxisCount: 3,
              mainAxisSpacing: 8.0,
              crossAxisSpacing: 8.0,
              childAspectRatio: 1.0,
            ),
          ),
          Text(
            result.toUpperCase(),
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 30,
              color: Colors.white,
            ),
          ),
          ElevatedButton.icon(
              onPressed: () {
                setState(() {
                  Player.playerO = [];
                  Player.playerX = [];
                  activePlayer = 'X';
                  gameOver = false;
                  turn = 0;
                  result = '';
                });
              },
              icon: const Icon(Icons.replay),
              label: const Text('Replay'),
              style: ButtonStyle(
                backgroundColor:
                    MaterialStateProperty.all(Theme.of(context).splashColor),
              ))
        ],
      )),
    );
  }

  _onTap(int index) async {
    if (!Player.playerX.contains(index) ||
        Player.playerX.isEmpty && !Player.playerO.contains(index) ||
        Player.playerO.isEmpty) game.playGame(index, activePlayer);
    updateState();

    if (!isSwitched && !gameOver) {
      await game.autoPlay(activePlayer);
      updateState();
    }
  }

  void updateState() {
    setState(() {
      activePlayer = (activePlayer == 'X') ? 'O' : 'X';
      turn ++;
      String winnerPlayer = game.checkWinner();

      if (winnerPlayer != '') {
        gameOver=true;
        result = ('$winnerPlayer wins');
      } else if(!gameOver && turn == 9)
        result = ('it is draw');
    });
  }
}
