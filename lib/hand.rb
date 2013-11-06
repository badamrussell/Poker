# -*- coding: utf-8 -*-

class Hand

  SETS = [:r_flush,
          :s_flush,
          :four_kind,
          :full_house,
          :flush,
          :straight,
          :three_kind,
          :two_pair,
          :one_pair,
          :high_card]

  attr_reader :cards, :hand_size

  def initialize(cards,hand_size = 5)
    @cards = cards
    @hand_size = hand_size
  end

  def size
    self.cards.size
  end

  def name
    flush_hand = find_flush_hand
    kinds_hand = find_kinds_hand
    SETS.index(flush_hand) < SETS.index(kinds_hand) ? flush_hand : kinds_hand
  end

  def beats?(other_hand)
    #p "#{score}  ><  #{other_hand.score}"
    score > other_hand.score
  end

  def show
    str_hand = "  "
    cards.each_with_index do |card, index|
      str_hand += card.show + "   "
    end

    str_hand
  end

  def hide
    str_hand = "  "
    cards.size.times do
       str_hand += "[ ⛆  ]".blue + "  "
    end
    str_hand
  end

  def select_cards
    puts "\n"
    puts show
    puts "    1       2       3       4       5 "
    puts "\n"

    print "Type in the cards you want to discard or 's' to skip:  "
    str_input = gets.downcase.chomp.split(",")

    str_input = [] if str_input[0] == "s"

    selected_cards = []
    str_input.each do |num|
      index = num.to_i - 1
      selected_cards << cards[index]
    end

    selected_cards
  end

  def discard(discard_cards)
    raise "cannot discard that many cards" if discard_cards.size > size
    discard_cards.each do |card|
      @cards -= [card]
    end
  end

  def draw(deck, number)
    @cards += deck.draw(number)
  end

  def count(card)
    @cards.select { |my_card| my_card.symbol == card.symbol }.size
  end

  def has_a?(card_value)
    @cards.any? { |card| card.value == card_value }
  end

  protected

  def score
    x_10 = 0
    x_100 = 0

    case name
    when :r_flush, :s_flush, :flush, :straight
      x_10 = high_card.value
    when :four_kind, :three_kind, :two_pair, :one_pair
      card_values = find_kinds.keys.sort
      x_10 = card_values.first
      x_100 = card_values.last if card_values.length > 1
    when :full_house
      kinds = find_kinds.sort_by { |value, count| count }
      x_10 = kinds.first[0]
      x_100 = kinds.last[0]
    end

    #VALUE FOR THE SET
    total = (SETS.length - SETS.index(name)) * 100
    #FINE-TUNE VALUE FOR TIE BREAKERS
    total += (x_10 * 10) + (x_100 * 100) + high_card.value

    #puts "#{name}: #{total}"
    total
  end

  def include_symbol?(other_symbol)
    @cards.any? { |card| card.symbol == other_symbol }
  end

  private

  def find_kinds
    {}.tap do |kinds|
      @cards.each do |card|
        kinds[card.value] = count(card)
      end
    end
  end

  def high_card
    @cards.sort.last
  end

  def flush?
    suit = @cards[0].suit
    @cards.all? { |my_card| my_card.suit == suit }
  end

  def straight?
    sort_cards = @cards.sort.reverse

    straight_set = if sort_cards[0] == "A" && has_a?(2)
      Card.get_symbols[0..3] + [:ace]
    else
      low_index = Cards.get_symbols.index[sort_cards.last.symbol]
      Card.get_symbols[low_index..(low_index+4)]
    end

    @cards.map(&:value) == straight_set
  end

  def find_flush_hand
    return :high_card unless flush?
    return :flush unless straight?
    return :r_flush if high_card.symbol == "A" && include_symbol?("K")
    :s_flush
  end

  def find_kinds_hand
    kinds = find_kinds
    return :four_kind if kinds.values.include?(4)
    return :full_house if kinds.values.include?(3) and kinds.values.include?(2)
    return :three_kind if kinds.values.include?(3)
    return :two_pair if kinds.select { |card, val| val == 2 }.size == 2
    return :one_pair if kinds.values.include?(2)
    :high_card
  end
end


