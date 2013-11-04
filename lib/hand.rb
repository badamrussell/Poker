# -*- coding: utf-8 -*-

class Hand

  SETS = [:r_flush,     # 10000 + flush_value(14*10) + 14
          :s_flush,     # 9000 + flush_value(14*10) + 14
          :four_kind,   # 8000 + kind_value(14*10) + 14
          :full_house,  # 6000 + three_pair(14*100) + two_pair(14*10) + 14
          :flush,       # 5000 + flush_value(14*10) + 14
          :straight,    # 4000 + straight_value(14*10) + 14
          :three_kind,  # 3000 + three_pair(14*10) + 14
          :two_pair,    # 1000 + high_pair(14*100) + low_pair(14*10) + 14
          :one_pair,    # 100 + pair_high_card(14*10) + 14
          :high_card]   # 14

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

  protected

  def find_kind_value(kinds_set, match_value, hi = true)
    matches = []
    kinds_set.each do |card_value, match_count|
      matches << card_value if match_count == match_value
    end

    return matches[0] if matches.count == 1

    if hi
      matches[0] > matches[1] ? matches[0] : matches[1]
    else
      matches[0] < matches[1] ? matches[0] : matches[1]
    end
  end

  def score
    x_10 = 0
    x_100 = 0

    case name
    when :r_flush
      x_10 = high_card.value
    when :s_flush
      x_10 = high_card.value
    when :four_kind
      x_10 = find_kind_value(find_kinds,4)
    when :full_house
      kinds = find_kinds
      x_10 = find_kind_value(kinds,2)
      x_100 = find_kind_value(kinds,3)
    when :flush
      x_10 = high_card.value
    when :straight
      x_10 = high_card.value
    when :three_kind
      x_10 = find_kind_value(find_kinds,3)
    when :two_pair
      kinds = find_kinds
      x_10 = find_kind_value(kinds,2,false)
      x_100 = find_kind_value(kinds,2,true)
    when :one_pair
      x_10 = find_kind_value(find_kinds,2)
    else
      0
    end

    total = (SETS.length - SETS.index(name)) * 100
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

    next_value = if sort_cards[0].symbol == :ace && sort_cards[1].value == 5
      5
    else
      sort_cards[0].value - 1
    end

    (1...sort_cards.length).each do |index|
      return false unless next_value == sort_cards[index].value
      next_value -= 1
    end

    true
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


