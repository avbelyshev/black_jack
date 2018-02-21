class Game
  DEFAULT_BANK = 100
  CARDS = 2
  BET = 10

  attr_reader :player, :dealer

  def initialize(player)
    @player = player
    @player.deposit(DEFAULT_BANK)
    @dealer = Player.new('Дилер', DEFAULT_BANK)
    @game_bank = 0
    @deck = Deck.new
    give_cards
    place_a_bet

    @status = :in_progress
  end

  def give_cards
    CARDS.times do
      player.add_card(deck.take_card)
      dealer.add_card(deck.take_card)
    end
  end

  def place_a_bet
    player.withdraw(BET)
    dealer.withdraw(BET)
    game_bank = BET * 2
  end

  def in_progress?
    status = :in_progress
  end

  protected

  attr_accessor :game_bank, :deck, :status
  attr_writer :player, :dealer
end
