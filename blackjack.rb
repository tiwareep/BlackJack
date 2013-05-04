#Blackjack class that allows one to play the game
#Contains a playgame method that allows users to play the game of Blackjack

load 'Player.rb'
load 'Deck.rb'
load 'Dealer.rb'
load 'Card.rb'

class Blackjack
  # start the game and ask the number of players
  def playgame
    puts "\nWelcome to BlackJack, also Known as 21!"
    puts "\nHow many players are at the table? (You can have maximum of 5 players)"
    numplayers = gets.to_i
    while ![1,2,3,4,5].include?(numplayers)
      puts "Please input a value between 1 and 5"
      numplayers = gets.to_i
    end

    puts "\nAll the players have 1000 dollars to start with and can bet any amount!\n"

    #create players array that contains an array of player object 
    players = Array.new
    numplayers.times do |i|
      players << Player.new(i)
    end

    #create winning array that initalizes every element as 0 
    winning = Array.new
    numplayers.times do |i|
      winning << 0
    end

    #totalbalance is the total balance of all the players
    totalbalance = 0
    numplayers.times do |i|
      totalbalance += players[i].balance
    end

    #Initializing number of splitting as 0
    numofsplit = 0 
    #don't stop playing untill the total balance is 0 so there is atleast one player with some money left
    while (totalbalance > 0)
      #input the bet and check if the bet is less than your balance

      #resets player's hassplitted attribute to 0
      players.each do |p|
        p.hassplitted = 0
      end

      players.each do |p|
        puts "\nPlayer #{p.index}, please input your bet!"
        p.bet = gets.to_i
        while p.bet > p.balance
          puts "Player #{p.index}, please input a value less than or equal to your balance of #{p.balance}"
          p.bet = gets.to_i
        end
      end

      #creates a deck object representing a deck of card
      deck = Deck.new

      #each player draws two cards
      players.each do |p|
        p.draw_two_cards(deck)
      end

      #creates one dealer and draws two cards for the dealer
      dealer = Dealer.new(0)
      dealer.draw_two_cards(deck)

      #printing all players' cards
      players.each do |p|
        p.print(p.index)
      end

      #print only one card for the dealer
      dealer.printonecard

      #this is when all of the players are playing a game of blackjack
      players.each do |p|
        #total value of the card should be less than 21 otherwise its no longer in this while loop
        while p.totalvalue <= 21
          puts "\nWhat would Player #{p.index} like to do? 1)hit 2)stay 3)double-bet 4)split-bet\n"
          input = gets.chomp
          #error checking
          while !['1', '2', '3', '4'].include?(input)
            puts "Error: you must enter 1, 2, 3 or 4"
            input = gets.chomp
          end

          #player chooses to stay
          if input == "2"
            puts "Player #{p.index} chooses to stay.\n"
            break
          end

          #player decides to double his bet so his bet increases by 2 times and he can only have one more card
          if input == "3"
            if p.balance >= 2 * p.bet
              puts "Players #{p.index} chooses to double bet.\n"
              p.hit(deck)
              p.print(p.index)
              p.bet *= 2
              break
            else
              puts "\nYou dont have enough balance to double-bet! So you will continue to hit"
            end
          end

          #player decides to split his bet so his bet decreased by 2 times and he can only have one more card
          size = players.size
          if input == "4" 
            if p.cards.size == 0 && p.cards[0].value.eql?(p.cards[1].value)
              if p.hassplitted == 0
                if p.balance >= 2 * p.bet
                  puts "\nPlayer #{p.index} chooses to split hands.\n"
                  players[size] = Player.new(p.index)
                  p.split(deck)
                  p.hassplitted = 1
                  players[size].hassplitted = 1
                  players[size].cards << p.splittedcard
                  players[size].hit(deck)
                  puts "The 2nd card of the splitted card is #{players[size].cards[1].suit} #{players[size].cards[1].value}"
                  puts "The total value of the splitted card is now #{players[size].totalvalue}" 
                  p.bet *=2
                  numofsplit += 1
                else
                  puts "\nYou dont have enough balance to split-hand! So you will continue to hit"
                end
              else
                puts "\nYou have already splitted the hands once before in the same round so you can't do it again! So you will continue with hit."
              end
            else
              puts "\nYou cannot split the hands because your two cards are not the same! So you will continue with hit!"
            end
          end

          #when player decies to hit, he draws one card and then it prints the player's cards
          p.hit(deck)
          p.print(p.index)

          #if the total value of the card is greater than 21 the player automatically looses the round
          if p.totalvalue > 21
            puts "\nPlayer #{p.index} loses this round"
            winning[players.index(p)] = -1
          end
        end
      end

      #dealer will only hit if dealer's totalvalue of the card is 17 or greater and if dealer gets 21, dealer wins
      while dealer.totalvalue < 17
        dealer.hit(deck)
        if dealer.totalvalue == 21
          dealer.print
          puts "\nEveryone Loses!"
          #updates the winning array to make sure that all the player loses after dealer wins with 21
          players.size.times do |i|
            winning[i] = -1
          end
          break
        end
      end

      #prints out the final cards for the players and the dealers
      puts "\nAll the Cards for the Players and the Dealer are:\n"
      players.each do |p|
        p.print(p.index)
      end
      dealer.print

      #if player's totalvalue is less than 22 and greater than dealer's, he wins, or if dealer's total value is over 21
      #and if player' totalvalue is less than 21, then player wins 
      players.each do |p|
        if (p.totalvalue > dealer.totalvalue && p.totalvalue < 22)  || (dealer.totalvalue > 21 && p.totalvalue < 22)
          puts "Player #{p.index} win!"
          #updates win array
          winning[players.index(p)] = 0
        else
          puts "Player #{p.index} loses!"
          winning[players.index(p)] = -1
        end
      end

      ##since splitting hands creates a new player element, you want to delete that now
      while numofsplit > 0
        players.delete_at(players.size - 1)
        winning.delete_at(winning.size - 1)
        numofsplit -= 1
      end

      #according to what the values are in the win array, prints out the balance of each player
      winning.each_with_index do |w, i|
        if winning[i] != -1
          players[i].balance += players[i].bet
          puts "Player #{players[i].index} now has the balance of #{players[i].balance}"
        else
          players[i].balance -= players[i].bet
          puts "Player #{players[i].index} now has the balance of #{players[i].balance}"
        end
      end

      #computes the new total balance of all the players's balance
      totalbalance = 0
      players.size.times do |i|
        totalbalance += players[i].balance
      end

      #creates two temporary array 
      temp = Array.new
      tempwin = Array.new

      #update player and player winning arrays according to game results
      players.each do |p|
        if p.balance != 0
          temp << p
        else
          puts "\nPlayer #{p.index} has been deleted because he has no money to continue!\n"
        end
      end

      players = temp
      players.size.times do |i|
        tempwin[i] = 0
      end

      winning = tempwin

      players.each do |p|
        p.handreset
      end

      #shuffle the deck before players play another game of blackjack
      deck.shuffle
      #if there are no more players in the game then the game ends
      if players.empty?
        puts "\nThere are no longer any players playing. The Game has ended!"
        break
      end
      
    end
  end
end

gameplay = Blackjack.new
gameplay.playgame


