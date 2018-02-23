class Game
  DEFAULT_BANK = 100
  CARDS = 2
  BET = 10
  MAX_CARDS = 3
  ACTION_METHODS = %i[skip_turn add_card open_cards].freeze

  attr_reader :player, :dealer, :status, :player_turn

  def initialize(player)
    @player = player
    @player.deposit(DEFAULT_BANK)
    @dealer = Player.new('Дилер', DEFAULT_BANK)

    start_game
  end

  def start_game
    @game_bank = 0
    @deck = Deck.new
    @player_turn = true
    player.zero_cards
    dealer.zero_cards
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
    self.game_bank = BET * 2
  end

  def return_bet
    player.deposit(BET)
    dealer.deposit(BET)
    self.game_bank = 0
  end

  def next_player_turn(player_choice)
    send ACTION_METHODS[player_choice]
  end

  def next_dealer_turn
    if dealer.score_for_skip?
      skip_turn
    else
      add_card(dealer)
    end
  end

  def finish_turn
    self.player_turn = !player_turn
    open_cards if score_overage? || max_cards?
  end

  def skip_turn
    finish_turn
  end

  def add_card(player = self.player)
    return if player.cards.size == MAX_CARDS
    player.add_card(deck.take_card)
    finish_turn
  end

  def open_cards
    case result
    when :win then player.deposit(game_bank)
    when :loss then dealer.deposit(game_bank)
    else return_bet
    end

    self.status = :finished
  end

  def result
    return :draw if player.score == dealer.score
    return :win if (player.score > dealer.score && player.score <= 21) || (dealer.score > 21 && player.score <= 21)
    :loss
  end

  def in_progress?
    status == :in_progress
  end

  def finished?
    status == :finished
  end

  def score_overage?
    player.score_overage? || dealer.score_overage?
  end

  def max_cards?
    player.cards.size == MAX_CARDS && dealer.cards.size == MAX_CARDS
  end

  def players_bank_zero?
    player.bank.zero? || dealer.bank.zero?
  end

  protected

  attr_accessor :game_bank, :deck
  attr_writer :player, :dealer, :status, :player_turn
end
