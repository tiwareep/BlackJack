#Deck class
#contains methods associated with a deck of card

load 'Card.rb'

class Deck
  attr_accessor :deck

  #creates a deck of card by creating an array of cards
  def initialize
    @deck = Array.new
    suits = ['Club', 'Diamond', 'Heart','Spades']
    cards = ['2', '3', '4', '5', '6', '7', '8', '9', '10', 'J', 'Q', 'K', 'A']
    suits.each do |suit|
      cards.each do |card|
        @deck << Card.new(suit,card)
      end
    end
    @deck.shuffle!
  end

  #shuffle the deck of card by sorting in randomly
  def shuffle
    @deck.sort_by{rand}
  end

  #draw a card by popping from the stack of cards
  def drawcard
    @deck.pop
  end

end