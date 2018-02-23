class Interface
  PLAYER_ACTIONS = ['Пропустить ход', 'Добавить карту', 'Открыть карты'].freeze
  RESULT_MESSAGE = {win: 'Вы выиграли', loss: 'Вы проиграли', draw: 'Ничья'}.freeze

  attr_reader :game

  def initialize(game)
    @game = game
  end

  def view_player_info(player, hide = false)
    puts "Игрок: #{player.name}\nСчет: #{hide ? '**' : player.score}\nОстаток средст: #{player.bank}\n"
    cards_list = ''
    player.cards.each { |card| cards_list += hide ? ' **' : " #{card}" }
    puts "Карты: #{cards_list}"
    puts "____________________\n"
  end

  def print_game_status(game)
    cls
    view_player_info(game.player)
    view_player_info(game.dealer, game.in_progress?)

    puts ''
    puts RESULT_MESSAGE.fetch(game.result) if game.finished?
  end

  def get_player_choice
    puts "Ваши действия:\n"
    PLAYER_ACTIONS.each.with_index(1) { |action, num| puts "#{num}. #{action}" }
    gets.to_i - 1
  end

  def next_game_request
    if game.players_bank_zero?
      puts 'Не достаточно денег для продолжения игры.'
      return
    end

    puts 'Хотите сыграть еще раз? (1 - да, 0 - нет)'
    return if gets.to_i.zero?
    game.start_game
  end

  def cls
    system "clear"
  end
end
