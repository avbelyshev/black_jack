class Card
  COSTS = {'V' => 10, 'Q' => 10, 'K' => 10, 'A' => 11}.freeze

  attr_reader :value, :suit

  def initialize(value, suit)
    @value = value
    @suit = suit
  end

  def to_s
    "#{value}#{suit}"
  end

  def cost
    COSTS.fetch(value, value)
  end
end
