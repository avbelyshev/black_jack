class Game
  DEFAULT_BANK = 100
  CARDS = 2
  BET = 10
  PLAYER_ACTIONS = ['Пропустить ход', 'Добавить карту', 'Открыть карты'].freeze
  ACTION_METHOD = %i[skip_turn add_card open_cards].freeze

  attr_reader :player, :dealer

  def initialize(player)
    @player = player
    @player.deposit(DEFAULT_BANK)
    @dealer = Player.new('Дилер', DEFAULT_BANK)
    @game_bank = 0
    @deck = Deck.new
    @player_turn = true
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

  def next_turn
    view_game_info
    if player_turn
      puts "Ваши действия:\n"
      PLAYER_ACTIONS.each.with_index(1) { |num, action| puts "#{num}. #{action}" }
      player_choice = gets.to_i - 1
      send ACTION_METHOD[player_choice]
      self.player_turn = false
    else
      if dealer.score >= 17
        skip_turn
      else
        add_card(dealer)
      end
      self.player_turn = true
    end
  end

  def finish_turn
    self.player_turn = !player_turn
  end

  def skip_turn
    finish_turn
  end

  def add_card(player = self.player)
    player.add_card(deck.take_card)
    finish_turn
  end

  def open_cards
    case result
      when :win
        player.deposit(game_bank)
        result_message = 'Вы выиграли'
      when :lose
        dealer.deposit(game_bank)
        result_message = 'Вы проиграли'
      else
        return_bet
        result_message = 'Ничья'
    end

    self.status = :finish
    view_game_info
    puts result_message
  end

  def result
    return :draw if player.score == dealer.score
    return :win if ((player.score > dealer.score) && (player.score <= 21)) || (dealer.score > 21 && player.score <= 21)
    :loss
  end

  def in_progress?
    self.status == :in_progress
  end

  def view_game_info
    player.view_info
    dealer.view_info(in_progress?)
  end

  def cls
    system "clear" or system "cls"
  end

  protected

  attr_accessor :game_bank, :deck, :status, :player_turn
  attr_writer :player, :dealer
end
