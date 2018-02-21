class Player
  attr_accessor :name, :cards
  attr_reader :bank

  def initialize(name, bank = 0)
    @name = name
    @cards = []
    @bank = bank
  end

  def add_card(card)
    cards << card
  end

  def deposit(amount)
    self.bank += amount
  end

  def withdraw(amount)
    self.bank -= amount
  end

  def score
    score = 0
    cards.each { |card| score += card.cost }

    score
  end

  def view_info(hide = false)
    puts "Игрок: #{name},\nСчет: #{score},\nОстаток средст: #{bank}\n"
    cards_list = ""
    cards.each { |card| cards_list += hide ? " **" : "#{card}" }
    puts "Карты: #{cards_list}"
  end

  protected

  attr_writer :bank
end
