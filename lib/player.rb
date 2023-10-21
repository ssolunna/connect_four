# frozen_string_literal: true

# Connect Four Players
class Player
  attr_reader :name, :token

  def initialize(name, token)
    @name = name
    @token = token
  end
end
