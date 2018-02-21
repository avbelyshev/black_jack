require_relative 'lib/card'
require_relative 'lib/deck'
require_relative 'lib/player'
require_relative 'lib/game'
require_relative 'lib/interface'


puts "Игра \"Black Jack\"\n"
puts "Для начала игры введите ваше имя:\n"
player_name = gets.chomp
player_name = 'Аноним' if player_name.to_s.empty?

player = Player.new(player_name)

game = Game.new(player)

# interface = Interface.new(game)

game.player.view_info
game.dealer.view_info(true)

# while game.in_progress?
  
# end