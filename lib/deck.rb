class Deck
  VALUES = [2, 3, 4, 5, 6, 7, 8, 9, 10, 'J', 'Q', 'K', 'A'].freeze
  SUITS = %w(♦ ♠ ♥ ♣).freeze

  attr_reader :cards

  def initialize
    @cards = build_deck.shuffle
  end

  def take_card
    cards.pop
  end

  protected

  attr_writer :cards

  def build_deck
    cards = []
    SUITS.each do |suit|
      VALUES.each do |value|
        cards << Card.new(value, suit)
      end
    end
    cards
  end

  def shuffle
    cards.shuffle!
  end
end
