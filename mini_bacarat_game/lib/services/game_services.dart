enum GameState { playerActive, playerWon, dealerWon, equal }

abstract class GameService {
  GameState getGameState();
  String getWinner();
}