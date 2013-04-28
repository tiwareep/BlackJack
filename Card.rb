#Card class

class Card
  attr_accessor :value, :suit

  # A card contains suit and value
  def initialize(suit,value)
    @suit = suit
    @value = value
  end
end