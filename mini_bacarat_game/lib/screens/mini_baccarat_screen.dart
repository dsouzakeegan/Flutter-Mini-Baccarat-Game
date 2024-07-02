import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
// import 'package:provider/provider.dart';

import '../widgets/cards_grid_view.dart';
import '../widgets/custom_button.dart';

class MiniBaccaratScreen extends StatefulWidget {
  const MiniBaccaratScreen({Key? key}) : super(key: key);

  @override
  State<MiniBaccaratScreen> createState() => _MiniBaccaratScreenState();
}

class _MiniBaccaratScreenState extends State<MiniBaccaratScreen> {
  double? bankroll;
  Bet? bet;
  String? comparisonResult = ''; // To store the comparison result
  String? betResult;

  void addBankRoll(double amount) {
    setState(() {
      bankroll = amount;
    });
  }

  void newRound() {
    setState(() {
      bet = null;
      dealersFirstCard = null;
      comparisonResult = null;
      betResult = null;
    });
  }

  void placeBet(double amount, BetType type) {
    setState(() {
      bet = Bet(amount, type);
      bankroll = bankroll! - amount;
    });
  }

  void resolveBet(Winner winner) {
    switch (winner) {
      case Winner.tie:
        setState(() {
          bankroll = bankroll! + bet!.amount;
        });
        break;
      case Winner.player:
        if (bet!.type == BetType.player) {
          setState(() {
            bankroll = bankroll! + (bet!.amount * 2);
            betResult = 'Player wins ${bet!.amount}';
          });
        } else {
          betResult = 'Player loses ${bet!.amount}';
        }
        break;
      case Winner.banker:
        if (bet!.type == BetType.banker) {
          setState(() {
            bankroll = bankroll! + (bet!.amount * 2);
            betResult = 'Player wins ${bet!.amount}';
          });
        } else {
          betResult = 'Player loses ${bet!.amount}';
        }
        break;
    }
  }

  final playerScoreController = TextEditingController();
  final dealerScoreController = TextEditingController();

  bool _isGameStarted = false;

  //Card Images
  List<Image> myCards = [];
  List<Image> dealersCards = [];
  List<Image> playersCards = [];

  //Cards
  String? dealersFirstCard;
  String? dealersSecondCard;
  String? playersFirstCard;
  String? playersSecondCard;

  //Scores
  int dealersScore = 0;
  int playersScore = 0;

  //Deck of Cards
  final Map<String, int> deckOfCards = {
    "cards/2.1.png": 2,
    "cards/2.2.png": 2,
    "cards/2.3.png": 2,
    "cards/2.4.png": 2,
    "cards/3.1.png": 3,
    "cards/3.2.png": 3,
    "cards/3.3.png": 3,
    "cards/3.4.png": 3,
    "cards/4.1.png": 4,
    "cards/4.2.png": 4,
    "cards/4.3.png": 4,
    "cards/4.4.png": 4,
    "cards/5.1.png": 5,
    "cards/5.2.png": 5,
    "cards/5.3.png": 5,
    "cards/5.4.png": 5,
    "cards/6.1.png": 6,
    "cards/6.2.png": 6,
    "cards/6.3.png": 6,
    "cards/6.4.png": 6,
    "cards/7.1.png": 7,
    "cards/7.2.png": 7,
    "cards/7.3.png": 7,
    "cards/7.4.png": 7,
    "cards/8.1.png": 8,
    "cards/8.2.png": 8,
    "cards/8.3.png": 8,
    "cards/8.4.png": 8,
    "cards/9.1.png": 9,
    "cards/9.2.png": 9,
    "cards/9.3.png": 9,
    "cards/9.4.png": 9,
    "cards/10.1.png": 0,
    "cards/10.2.png": 0,
    "cards/10.3.png": 0,
    "cards/10.4.png": 0,
    "cards/J1.png": 0,
    "cards/J2.png": 0,
    "cards/J3.png": 0,
    "cards/J4.png": 0,
    "cards/Q1.png": 0,
    "cards/Q2.png": 0,
    "cards/Q3.png": 0,
    "cards/Q4.png": 0,
    "cards/K1.png": 0,
    "cards/K2.png": 0,
    "cards/K3.png": 0,
    "cards/K4.png": 0,
    "cards/A1.png": 1,
    "cards/A2.png": 1,
    "cards/A3.png": 1,
    "cards/A4.png": 1,
  };

  Map<String, int> playingCards = {};

  @override
  void initState() {
    super.initState();

    playingCards.addAll(deckOfCards);
  }

  startGame() {
    setState(() {
      _isGameStarted = true;
    });
  }

  //Reset round && cards
  startNewRound() {
    //Start new round with full deck of cards.
    playingCards = {};
    playingCards.addAll(deckOfCards);

    //reset card images
    myCards = [];
    dealersCards = [];

    //Random card one for dealer
    Random random = Random();
    String cardOneKey =
        playingCards.keys.elementAt(random.nextInt(playingCards.length));
    //Remove used card key from playingCards
    playingCards.removeWhere((key, value) => key == cardOneKey);

    //Random card two for dealer
    String cardTwoKey =
        playingCards.keys.elementAt(random.nextInt(playingCards.length));
    //Remove used card key from playingCards
    playingCards.removeWhere((key, value) => key == cardTwoKey);

    //Random card one for the player
    String cardThreeKey =
        playingCards.keys.elementAt(random.nextInt(playingCards.length));
    playingCards.removeWhere((key, value) => key == cardThreeKey);

    //Random card two for the player
    String cardFourkey =
        playingCards.keys.elementAt(random.nextInt(playingCards.length));
    playingCards.removeWhere((key, value) => key == cardFourkey);

    //Assign card keys to dealer's cards
    dealersFirstCard = cardOneKey;
    dealersSecondCard = cardTwoKey;

    //Assign card keys to player's cards
    playersFirstCard = cardThreeKey;
    playersSecondCard = cardFourkey;

    //Adding dealers card images to display them in Grid View
    dealersCards.add(Image.asset(dealersFirstCard!));
    dealersCards.add(Image.asset(dealersSecondCard!));

    //Score for dealer
    dealersScore =
        (deckOfCards[dealersFirstCard]! + deckOfCards[dealersSecondCard]!) % 10;

    //Adding player card images to display them in grid view
    myCards.add(Image.asset(playersFirstCard!));
    myCards.add(Image.asset(playersSecondCard!));

    //Calculate score for the player (my score)
    playersScore =
        (deckOfCards[playersFirstCard]! + deckOfCards[playersSecondCard]!) % 10;

    if (dealersScore < 6) {
      String thirdDealersCard =
          playingCards.keys.elementAt(random.nextInt(playingCards.length));
      //playingCards.removeWhere((key, value) => key == thirdDealersCard);
      dealersCards.add(Image.asset(thirdDealersCard));

      dealersScore = (dealersScore + deckOfCards[thirdDealersCard]!) % 10;
    }

    if (playersScore < 6) {
      // String cardKey =
      //     playingCards.keys.elementAt(random.nextInt(playingCards.length));
      String thirdDealersCard =
          playingCards.keys.elementAt(random.nextInt(playingCards.length));
      //playingCards.removeWhere((key, value) => key == cardKey);
      myCards.add(Image.asset(thirdDealersCard));

      playersScore = (playersScore + deckOfCards[thirdDealersCard]!) % 10;
    }
    // if (playersScore < 6) {
    //   String thirdPlayersCard =
    //   playingCards.keys.elementAt(random.nextInt(playingCards.length));
    //   //playingCards.removeWhere((key, value) => key == thirdDealersCard);
    //   playersScore.add(Image.asset(thirdPlayersCard));
    //
    //   playersScore = playersScore + deckOfCards[thirdPlayersCard]!;
    // }\
    Winner result;
    if (playersScore > dealersScore && playersScore <= 9) {
      result = Winner.player;
    } else if (playersScore < dealersScore) {
      result = Winner.banker;
    } else {
      result = Winner.tie;
    }
    setState(() {
      comparisonResult = (result == Winner.player
          ? 'PLAYER WINS!!'
          : result == Winner.banker
              ? 'BANKER WINS!!'
              : 'ITS A TIE!!');
      resolveBet(result);
    });
  }

//Add extra card to the player
//   void addCard() {
//     Random random = Random();
//   }
//
//   void compareScores() {
//
//   }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green[800],
      body: bankroll != null
          ? SafeArea(
              child: bet != null
                  ? dealersFirstCard != null
                      ? Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            // Align(
                            //     alignment: Alignment.topLeft,
                            //     child: Text('Bankroll: ${bankroll!.toString()}')),
                            Column(
                              children: [
                                Text(
                                  "Banker's Score: $dealersScore",
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: dealersScore <= 9
                                          ? Colors.white
                                          : Colors.red[900]),
                                ),
                                CardsGridView(cards: dealersCards),
                              ],
                            ),
                            // Row(
                            //   children: [
                            //     ElevatedButton(
                            //       onPressed: compareScores,
                            //       child: Text('Compare Scores'),
                            //     ),
                            //     Text(comparisonResult), // Display the comparison result
                            //   ],
                            // ),
                            Column(
                              children: [
                                Text("Player's Score: $playersScore",
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: playersScore <= 9
                                            ? Colors.white
                                            : Colors.red[900])),
                                CardsGridView(cards: myCards)
                              ],
                            ),
                            IntrinsicWidth(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  // CustomButton(
                                  //   onPressed: () {
                                  //     addCard();
                                  //   },
                                  //   label: "Another Card",
                                  // ),
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(comparisonResult ?? '',style: TextStyle( color: Colors.white70, fontWeight: FontWeight.bold ),),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      Text('Bet Placed on : ${bet!.type.name} \$${bet!.amount}',style: TextStyle( color: Colors.white70 ),),
                                      Text(betResult ?? '', style: TextStyle( color: Colors.white70 ),),
                                      Text('Current Bankroll : ${bankroll!.toString()}',style: TextStyle( color: Colors.white70),),
                                      //Text('Bet: ${bet!.type.name} \$${bet!.amount}'),
                                    ],
                                  ),

                                  // ElevatedButton(
                                  //   onPressed: () {
                                  //     addCard();
                                  //   },
                                  //   style: ElevatedButton.styleFrom(
                                  //     shape: RoundedRectangleBorder(
                                  //       borderRadius: BorderRadius.circular(20.0),
                                  //     ),
                                  //     backgroundColor: Colors.grey, // Set your desired button color
                                  //     foregroundColor: Colors.black
                                  //   ),
                                  //   child: Text('Another Card'),
                                  // ),

                                  SizedBox(
                                    height: 10,
                                  ),
                                  // CustomButton(
                                  //   onPressed: () {
                                  //     startNewRound();
                                  //   },
                                  //   label: "Next Round",
                                  // ),
                                  ElevatedButton(
                                    onPressed: () {
                                      newRound();
                                    },
                                    style: ElevatedButton.styleFrom(
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(20.0),
                                        ),
                                        backgroundColor: Colors.white,
                                        // Set your desired button color
                                        foregroundColor: Colors.deepPurple),
                                    child: Text('Next Round', style: TextStyle( fontWeight: FontWeight.bold,),),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        )
                      : Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text('Bankroll: ${(bankroll! + bet!.amount)}'),
                              const SizedBox(
                                height: 20,
                              ),
                              Text('~ Bet \$${bet!.amount} on ${bet!.type.name.capitalizeFirstLetter()} ~'),
                              const SizedBox(
                                height: 10,
                              ),
                              CustomButton(
                                onPressed: () => startNewRound(),
                                label: 'DEAL CARDS',
                              ),
                            ],
                          ),
                        )
                  : Center(
                      child: CustomButton(
                        onPressed: () {
                          showCustomModalBottomSheet(
                              context: context,
                              title: 'Place Bet',
                              form: PlaceBetForm(
                                bankroll: bankroll!,
                                placeBet: placeBet,
                              ));
                        },
                        label: "PLACE BET",
                      ),
                    ),
            )
          : Center(
              child: CustomButton(
                onPressed: () => showCustomModalBottomSheet(
                    context: context,
                    title: 'Add Bankroll',
                    form: AddBankrollForm(addBankRoll: addBankRoll)),
                label: "ADD BANKROLL",
              ),
            ),
    );
  }
}

void showCustomModalBottomSheet(
    {required BuildContext context,
    required String title,
    required Widget form}) {
  showModalBottomSheet<void>(
    context: context,
    isDismissible: true,
    isScrollControlled: true,
    builder: (context) => Container(
      width: double.infinity,
      decoration: const BoxDecoration(
          color: Color(0xFFF0EDF6),
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(24), topRight: Radius.circular(24))),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: 32,
              height: 4,
              decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.secondary,
                  borderRadius: BorderRadius.circular(42)),
            ),
            const SizedBox(height: 30),
            SizedBox(
              width: MediaQuery.of(context).size.width - 54,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                        fontSize: 22, fontWeight: FontWeight.w700),
                  ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: const Padding(
                        padding: EdgeInsets.only(left: 27.0),
                        child: Icon(
                          Icons.expand_more_rounded,
                          size: 32,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            form
          ],
        ),
      ),
    ),
  );
}

class AddBankrollForm extends StatefulWidget {
  // final Function(int) onAdd; // Callback function to handle adding a bet

  const AddBankrollForm({super.key, required this.addBankRoll});

  final Function(double) addBankRoll;

  @override
  State<AddBankrollForm> createState() => _AddBankrollFormState();
}

class _AddBankrollFormState extends State<AddBankrollForm> {
  final _formKey = GlobalKey<FormState>(); // Key for form validation
  final _amountController = TextEditingController();

  void _addBankRoll() {
    // if (_formKey.currentState!.validate()) {
    //   int amount = int.parse(_amountController.text);
    //   widget.onAdd(amount); // Call the callback function with the bet amount
    //   _amountController.clear(); // Clear the amount field after adding
    // }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    controller: _amountController,
                    keyboardType: TextInputType.number,
                    // Set keyboard for numbers
                    decoration: const InputDecoration(
                      labelText: 'Amount',
                      //hintText: 'Enter bet amount',
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Enter Bankroll Amount';
                      }
                      return null;
                    },
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 30),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () {
                  widget.addBankRoll(double.parse(_amountController.text));
                  Navigator.pop(context);
                },
                child: const Text('ADD',style: TextStyle(fontWeight: FontWeight.bold),),
              ),
            ],
          ),
          SizedBox(height: 50,)
        ],
      ),
    );
  }
}

class PlaceBetForm extends StatefulWidget {
  //final Function(String) onSelectionChanged; // Callback for selection change

  const PlaceBetForm({
    super.key,
    required this.bankroll,
    required this.placeBet,
  });

  final double bankroll;
  final Function(double, BetType) placeBet;

  @override
  State<PlaceBetForm> createState() => _PlaceBetFormState();
}

class _PlaceBetFormState extends State<PlaceBetForm> {
  final _formKey = GlobalKey<FormState>(); // Key for form validation
  final _amountController = TextEditingController();

  void _palceBet() {
    // if (_formKey.currentState!.validate()) {
    //   int amount = int.parse(_amountController.text);
    //   widget.onAdd(amount); // Call the callback function with the bet amount
    //   _amountController.clear(); // Clear the amount field after adding
    // }
  }

  BetType _selectedOption =
      BetType.player; // Stores the currently selected option

  void _handleSelection(BetType value) {
    setState(() {
      _selectedOption = value;
    });
    //widget.onSelectionChanged(value); // Call the callback with the selected option
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          Text('Bankroll: ${widget.bankroll!.toString()}'),
          Row(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    controller: _amountController,
                    keyboardType: TextInputType.number,
                    // Set keyboard for numbers
                    decoration: const InputDecoration(
                      labelText: 'Amount',
                      //hintText: 'Enter bet amount',
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Enter Amount';
                      }
                      return null;
                    },
                  ),
                ),
              ),
            ],
          ),
          SizedBox(
            height: 20,
          ),
          Row(
            children: [
              Row(
                children: [
                  Radio<BetType>(
                    value: BetType.player,
                    groupValue: _selectedOption,
                    onChanged: (value) => _handleSelection(value!),
                  ),
                  Text('Player'),
                  const SizedBox(width: 10), // Add some spacing
                  Radio<BetType>(
                    value: BetType.banker,
                    groupValue: _selectedOption,
                    onChanged: (value) => _handleSelection(value!),
                  ),
                  Text('Banker'),
                ],
              ),
            ],
          ),
          SizedBox(height: 30),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () {
                  widget.placeBet(
                      double.parse(_amountController.text), _selectedOption);
                  Navigator.pop(context);
                },
                child: const Text('PLACE BET', style: TextStyle( fontWeight:FontWeight.bold ),),
              ),
            ],
          ),
          SizedBox( height: 50,)
        ],
      ),
    );
  }
}

enum Winner { player, banker, tie }

enum BetType { player, banker }

class Bet {
  final double amount;
  final BetType type;

  Bet(this.amount, this.type);
}

// class BankrollProvider extends ChangeNotifier {
//   double? bankroll;
//   Bet? bet;
//   String? comparisonResult = ''; // To store the comparison result
//
//   void addBankRoll(double amount) {
//     bankroll = amount;
//     notifyListeners();
//   }
//
//   void newRound() {
//     bet = null;
//     comparisonResult = null;
//     notifyListeners();
//   }
//
//   void placeBet(double amount, BetType type) {
//     bet = Bet(amount, type);
//     bankroll = bankroll! - amount;
//     notifyListeners();
//   }
//
//   void resolveBet(Winner winner) {
//     switch (winner) {
//       case Winner.tie:
//         bankroll = bankroll! + bet!.amount;
//         break;
//       case Winner.player:
//         if (bet!.type == BetType.player) {
//           bankroll = bankroll! + (bet!.amount * 2);
//         }
//         break;
//       case Winner.banker:
//         if (bet!.type == BetType.banker) {
//           bankroll = bankroll! + (bet!.amount * 2);
//         }
//         break;
//     }
//     bet = null;
//     comparisonResult = winner == Winner.player ? 'Player Wins!' : winner == Winner.banker ? 'Banker Wins!' : 'Tie!';
//     notifyListeners();
//   }
// }

extension StringExtensions on String {
  String capitalizeFirstLetter() {
    return '${this[0].toUpperCase()}${substring(1)}';
  }
}
