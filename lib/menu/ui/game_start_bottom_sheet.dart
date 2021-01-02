import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tic_tac_no/game/bloc/game_bloc.dart';
import 'package:tic_tac_no/game/data/models/models.dart';
import 'package:tic_tac_no/menu/ui/primary_button.dart';
import 'package:tic_tac_no/menu/ui/colour_circle.dart';
import 'package:tic_tac_no/menu/ui/piece_shapes.dart';
import 'package:tic_tac_no/menu/menu_enums.dart';

class GameStartModal extends StatefulWidget {
  GameStartModal({this.gameType});
  final GameType gameType;
  @override
  _GameStartModalState createState() => _GameStartModalState();
}

class _GameStartModalState extends State<GameStartModal> {
  CustomPainter p1SelectedPiece;
  CustomPainter p2SelectedPiece;

  // List of colours for each player
  List<Color> p1ColourList = [
    Colors.red,
    Colors.deepOrange,
    Colors.deepOrangeAccent
  ];
  List<Color> p2ColourList = [
    Colors.orangeAccent,
    Colors.yellow,
    Colors.yellowAccent
  ];

  List<String> listOfAI = ['EASY', 'MEDIUM', 'HARD'];

  // Variable to hold the index of the colour
  int _p1Value = 0;
  int _p2Value = 0;
  int _aiValue = 0;

  @override
  void initState() {
    // Initialise the pieces
    p1SelectedPiece = CrossPainter(drawingColor: p1ColourList[_p1Value]);
    p2SelectedPiece = CirclePainter(drawingColor: p2ColourList[_p2Value]);
    super.initState();
  }

  void updatePlayer1Colour(int value) {
    if (p1SelectedPiece is CrossPainter) {
      setState(() {
        p1SelectedPiece = CrossPainter(drawingColor: p1ColourList[value]);
      });
    } else {
      setState(() {
        p1SelectedPiece = TrianglePainter(drawingColor: p1ColourList[value]);
      });
    }
  }

  void updatePlayer1Piece() {
    if (p1SelectedPiece is CrossPainter) {
      setState(() {
        p1SelectedPiece = TrianglePainter(drawingColor: p1ColourList[_p1Value]);
      });
    } else {
      setState(() {
        p1SelectedPiece = CrossPainter(drawingColor: p1ColourList[_p1Value]);
      });
    }
  }

  void updatePlayer2Colour(int value) {
    setState(() {
      if (p2SelectedPiece is CirclePainter) {
        p2SelectedPiece = CirclePainter(drawingColor: p2ColourList[value]);
      } else {
        p2SelectedPiece = SquirclePainter(drawingColor: p2ColourList[value]);
      }
    });
  }

  void updatePlayer2Piece() {
    if (p2SelectedPiece is CirclePainter) {
      setState(() {
        p2SelectedPiece = SquirclePainter(drawingColor: p2ColourList[_p2Value]);
      });
    } else {
      setState(() {
        p2SelectedPiece = CirclePainter(drawingColor: p2ColourList[_p2Value]);
      });
    }
  }

  String getModalTitle() {
    if (widget.gameType == GameType.SinglePlayer) {
      return 'SINGLE PLAYER SETUP';
    } else if (widget.gameType == GameType.LocalMultiplayer) {
      return 'LOCAL MULTIPLER SETUP';
    } else {
      return 'ONLINE MULTIPAYER SETUP';
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.gameType == GameType.OnlineMultiplayer) {
      return Wrap(
        children: [
          Container(
            width: double.infinity,
            padding: EdgeInsets.fromLTRB(24, 24, 24, 48),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Color(0xff012E44),
            ),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: SizedBox(
                    child: CircularProgressIndicator(),
                    width: 70,
                    height: 70,
                  ),
                ),
                Text('Searching for game...'),
              ],
            ),
          )
        ],
      );
    } else {
      return Wrap(
        children: [
          Container(
            padding: EdgeInsets.symmetric(vertical: 24, horizontal: 24),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Color(0xff012E44),
            ),
            child: Column(
              children: [
                Text(
                  getModalTitle(),
                  style: GoogleFonts.asap(
                    textStyle: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                SizedBox(
                  height: 8,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.baseline,
                  textBaseline: TextBaseline.alphabetic,
                  children: [
                    Column(
                      children: [
                        Text(
                          widget.gameType == GameType.SinglePlayer
                              ? 'YOU'
                              : 'PLAYER 1',
                          style: GoogleFonts.asap(
                            textStyle:
                                TextStyle(color: Colors.white, fontSize: 18),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            updatePlayer1Piece();
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Container(
                              margin: EdgeInsets.all(8),
                              height: 100,
                              width: 100,
                              child: CustomPaint(
                                painter: p1SelectedPiece,
                              ),
                            ),
                          ),
                        ),
                        Row(
                          children: List<Widget>.generate(p1ColourList.length,
                              (int index) {
                            return ColourCircle(
                              isSelected: _p1Value == index,
                              circleColor: p1ColourList[index],
                              selectorFunction: () {
                                _p1Value = index;

                                updatePlayer1Colour(_p1Value);
                              },
                            );
                          }),
                        ),
                      ],
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Text(
                          widget.gameType == GameType.SinglePlayer
                              ? 'AI'
                              : 'PLAYER 2',
                          style: GoogleFonts.asap(
                            textStyle:
                                TextStyle(color: Colors.white, fontSize: 18),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: GestureDetector(
                            onTap: () {
                              updatePlayer2Piece();
                            },
                            child: Container(
                              margin: EdgeInsets.all(8),
                              height: 100,
                              width: 100,
                              child: CustomPaint(
                                willChange: true,
                                painter: p2SelectedPiece,
                              ),
                            ),
                          ),
                        ),
                        widget.gameType == GameType.SinglePlayer
                            ? GestureDetector(
                                onTap: () {
                                  setState(() {
                                    if (_aiValue == listOfAI.length - 1) {
                                      _aiValue = 0;
                                    } else {
                                      _aiValue++;
                                    }
                                  });
                                },
                                child: Padding(
                                  padding: const EdgeInsets.only(top: 7),
                                  child: Text(
                                    listOfAI[_aiValue],
                                    style: GoogleFonts.asap(
                                      textStyle: TextStyle(
                                          color: Colors.white, fontSize: 24),
                                    ),
                                  ),
                                ),
                              )
                            : Row(
                                children: List<Widget>.generate(
                                    p2ColourList.length, (int index) {
                                  return ColourCircle(
                                    isSelected: _p2Value == index,
                                    circleColor: p2ColourList[index],
                                    selectorFunction: () {
                                      _p2Value = index;
                                      updatePlayer2Colour(_p2Value);
                                    },
                                  );
                                }),
                              ),
                      ],
                    ),
                  ],
                ),
                PrimaryButton(
                  buttonText: 'START GAME',
                  buttonPress: () {
                    BlocProvider.of<GameBloc>(context).add(
                      SetPlayers(
                        player1: Player(
                          id: 1,
                          name: 'Player 1',
                          color: p1ColourList[_p1Value],
                          symbol: p1SelectedPiece,
                          type: PlayerType.me, // PlayerType.ai,
                          // aiStrength: 2,
                        ),
                        player2: Player(
                          id: 2,
                          name: 'Player 2',
                          color: p2ColourList[_p2Value],
                          symbol: p2SelectedPiece,
                          type: _decidePlayerType(),
                          aiStrength: _aiValue,
                        ),
                      ),
                    );
                    Navigator.of(context).pushNamed('/game');
                  },
                  buttonGradient: LinearGradient(
                      colors: [Color(0xffFF5F6D), Color(0xffFFC371)]),
                )
              ],
            ),
          )
        ],
      );
    }
  }

  PlayerType _decidePlayerType() {
    switch (widget.gameType) {
      case GameType.SinglePlayer:
        return PlayerType.ai;
      case GameType.LocalMultiplayer:
        return PlayerType.friend;
      default:
        return PlayerType.ai;
    }
  }
}