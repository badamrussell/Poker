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

  def determine_hand
    flush_hand = find_flush_hand
    kinds_hand = find_kinds_hand
    SETS.index(flush_hand) < SETS.index(kinds_hand) ? flush_hand : kinds_hand
  end

  def beats?(other_hand)
    SETS.index(determine_hand) < SETS.index(other_hand.determine_hand)
  end

  def render
    puts "\n"
    str_hand = "  "
    cards.each_with_index do |card, index|
      str_hand += card.render + "  "
    end
    puts str_hand  + "  "+ determine_hand.to_s.upcase
    puts "    1      2      3      4      5 "
    puts "\n"

  end

  def select_cards
    render
    print "Type in the cards you want to discard or 's' to skip:  "
    str_input = gets.downcase.chomp.split(",")
    #puts str_input
    #str_input = "1,2,3".split(",")
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

  def find_high_card

  end

  def score
    total = case determine_hand

    when :r_flush
      # 10000 + flush_value(14*10) + 14
      10000 + (high_card.value * 10)
    when :s_flush
      # 9000 + flush_value(14*10) + 14
      9000 + (high_card.value * 10)
    when :four_kind
      # 8000 + kind_value(14*10) + 14
      kinds = find_kinds

      8000 +
    when :full_house
      # 6000 + three_pair(14*100) + two_pair(14*10) + 14

    when :flush
      # 5000 + flush_value(14*10) + 14
      5000 + (high_card.value * 10)
    when :straight
      # 4000 + straight_value(14*10) + 14
    when :three_kind
      # 3000 + three_pair(14*10) + 14
    when :two_pair
      # 1000 + high_pair(14*100) + low_pair(14*10) + 14
    when :one_pair
      # 100 + pair_high_card(14*10) + 14
    end

    total += high_card.value
  end

  private

  def find_kinds
    {}.tap do |kinds|
      @cards.each do |card|
        kinds[card.symbol] = count(card)
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
    diff = 0
    sort_cards = @cards.sort.reverse
    (0...(sort_cards.size - 1)).each do |index|
      diff += (sort_cards[index].value - sort_cards[index+1].value).abs
    end

    diff == 4
  end



  def find_flush_hand
    return :high_card unless flush?
    return :flush unless straight?
    return :r_flush if high_card.symbol == "A"
    :s_flush
  end

  def find_kinds_hand
    kinds = find_kinds
    return :four_kind if kinds.values.include?(4)
    return :full_house if kinds.values.include?(3) and kinds.values.include?(2)
    return :three_kind if kinds.values.include?(3)
    return :two_pair if kinds.select { |key, val| val == 2 }.size == 2
    return :one_pair if kinds.values.include?(2)
    :high_card
  end


end


