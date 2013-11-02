require_relative "player"

class Dealer < Player
  attr_reader :pot, :name


  def initialize(name, pot)
    @name = name
    @pot = pot
  end


end