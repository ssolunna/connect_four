# frozen_string_literal: true

# Connect Four Players
class Player
  attr_reader :token

  def initialize(name, token)
    @name = name
    @token = token
  end
end
