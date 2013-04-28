#Dealer class 
#Inherits from the Player Class

load 'Player.rb'

class Dealer < Player

  def print
    puts "\nDealer's cards are:"
    @cards.each do |card|
      puts "#{card.suit} #{card.value}"
    end
    puts "The total value of Dealer's cards is #{totalvalue}\n"
  end

  def printonecard
    puts "\nThe Dealer cards you can see is :"
    puts "#{@cards[0].suit} #{@cards[0].value}"
    puts "The total value of Dealer's cards is unknown\n"
  end

end