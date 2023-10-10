# frozen_string_literal: true

require_relative '../lib/game'

describe Game do
  describe '#set_players' do
    subject(:game_players) { described_class.new }
    let (:player_one) { game_players.instance_variable_get(:@player_one) }
    let (:player_two) { game_players.instance_variable_get(:@player_two) }
    let (:current_player) { game_players.instance_variable_get(:@current_player) }

    it 'creates two instances of Player' do
      allow(game_players).to receive(:set_initial_player)
      game_players.set_players
      expect([player_one, player_two]).to all( be_an_instance_of(Player) )
    end

    context 'when player_input is 1' do
      it 'assigns @player_one to @current_player' do
        allow(game_players).to receive(:player_input).and_return(1)
        game_players.set_players
        expect(current_player).to be(player_one)
      end
    end

    context 'when player_input is 2' do
      it 'assigns @player_two to @current_player' do
        allow(game_players).to receive(:player_input).and_return(2)
        game_players.set_players
        expect(current_player).to be(player_two)
      end
    end
  end

  describe '#player_input' do
    subject(:game_input) { described_class.new }
    let(:error_message) { 'Invalid input' }

    context 'when user inputs a number inside the range' do
      let(:range) { (1..2) }

      it 'stops loop' do
        valid_input = '1'

        allow(game_input).to receive(:gets).and_return(valid_input)
        expect(game_input).not_to receive(:puts).with(error_message)
        game_input.player_input(range)
      end
    end

    context 'when user inputs an invalid number, then a valid one' do
      let(:range) { (1..7) }

      it 'displays error message once' do
        invalid_input = '8'
        valid_input = '5'

        allow(game_input).to receive(:gets).and_return(invalid_input, valid_input)
        expect(game_input).to receive(:puts).with(error_message).once
        game_input.player_input(range)
      end
    end
    
    context 'when user inputs two invalid numbers, then a valid one' do
      let(:range) { (2..3) }

      it 'displays error message twice' do
        invalid_input = 'x'
        invalid_input = '!'
        valid_input = '3'

        allow(game_input).to receive(:gets).and_return(invalid_input, invalid_input, valid_input)
        expect(game_input).to receive(:puts).with(error_message).twice
        game_input.player_input(range)
      end
    end
  end

  describe '#verify_number' do
    subject(:game_verified) { described_class.new }

    context 'when the number is inside the range' do
      it 'returns the number' do
        range = (1..2)
        number = 1 
        expect(game_verified.verify_number(range, number)).to eq(number)
      end
    end
    
    context 'when the number is outside the range' do
      it 'returns nil' do
        range = (1..2)
        number = 3 
        expect(game_verified.verify_number(range, number)).to be_nil 
      end
    end
  end
end
