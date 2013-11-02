class Player
  attr_reader :pot, :name
  attr_accessor :hand

  def initialize(name, pot)
    @name = name
    @pot = pot
  end


end