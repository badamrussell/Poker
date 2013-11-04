require_relative "card"

class Deck
  attr_reader :deck

  def initialize()
    @deck = set
    shuffle
  end

  def set
    [].tap do |full_deck|
      Card.get_suits.each do |suit|
        Card.get_symbols.each do |symbol|
          full_deck << Card.new(suit, symbol)
        end
      end
    end
  end

  def shuffle
    @deck.shuffle!
  end

  def size
    @deck.size
  end

  def draw(num = 1)
    [].tap do |draws|
      num.times do
        draws << @deck.pop
      end
    end
  end

  def replace(cards)
    cards.each do |card|
      @deck << card
    end
  end
end