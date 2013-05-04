# Player Class 
#Contains methods associated to a blackjack player

load 'Deck.rb'

class Player
  attr_accessor :index, :balance, :bet, :splittedcard, :cards, :hassplitted
  #initialize balance to be 1000 as instructed
  #index represents player's index number
  def initialize (index)
    @index = index
    @balance = 1000
    @bet = 0
    @cards = Array.new
    @hassplitted = 0
  end

  #draws two cards from the deck
  def draw_two_cards(deck)
    @cards << deck.drawcard
    @cards << deck.drawcard
  end

  #draws one card from the deck
  def hit(deck)
    @cards << deck.drawcard
  end

  def split(deck)
    @splittedcard = @cards.pop
  end



  #when player doesn't decide to hit
  def stay
    puts "Player #{index.to_s} decides to stay"
  end

  #resets the hand of the cards
  def handreset
    @cards = Array.new
  end

  #used for printing out what players' hand looks like
  def print (index)
    puts "\nPlayer #{index.to_s} has cards:"
    @cards.each do |card|
      puts "#{card.suit} #{card.value}"
    end
    puts "The total value of the cards is #{totalvalue}\n"
  end

  #total value of the cards
  #ace can be represented as both 1 or 11 
  def totalvalue
    values = @cards.map{|c| c.value}
    total = 0
    values.each do |v|
      if v == "A"
      total += 11
      elsif v.to_i == 0
      total += 10
      else
      total += v.to_i
      end
    end
    values.select{|value| value == "A"}.count.times do
      total -= 10 if total > 21
    end
    total
  end
end