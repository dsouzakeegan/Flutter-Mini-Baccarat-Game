import 'package:mini_bacarat_game/modals/suits.dart';

import 'cards_type.dart';

class PlayingCard {
  // The suit of the card.
  final Suit suit;
  // The rank of the card. ace->king.
  final CardValue value;

  // Creates a playing card.
  PlayingCard(this.suit, this.value);
}
