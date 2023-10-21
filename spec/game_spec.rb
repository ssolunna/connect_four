# frozen_string_literal: true

require_relative '../lib/game'

describe Game do
  let(:board) { subject.instance_variable_get(:@board) }
  let (:player_one) { subject.instance_variable_get(:@player_one) }
  let (:player_two) { subject.instance_variable_get(:@player_two) }
  let (:current_player) { subject.instance_variable_get(:@current_player) }
  let(:winner) { subject.instance_variable_get(:@winner) }

  describe '#play' do
    subject(:play_game) { described_class.new }

    it 'displays the board and plays the game' do
      allow(play_game).to receive(:display_game_intro)
      allow(play_game).to receive(:set_players)
      allow(play_game).to receive(:player_turns)
      allow(play_game).to receive(:game_over)
      expect(board).to receive(:display)
      play_game.play
    end
  end

  describe '#set_players' do
    subject(:game_players) { described_class.new }

    before do
      allow(game_players).to receive(:display_select_prompt)
    end

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

    before do
      allow(game_input).to receive(:puts)
      allow(game_input).to receive(:print)
    end

    context 'when user inputs a number inside the range' do
      let(:range) { (1..2) }

      it 'stops loop' do
        valid_input = '1'

        allow(game_input).to receive(:gets).and_return(valid_input)
        expect(game_input).not_to receive(:display_err_invalid_input)
        game_input.player_input(range)
      end
    end

    context 'when user inputs an invalid number, then a valid one' do
      let(:range) { (1..7) }

      it 'displays error message once' do
        invalid_input = '8'
        valid_input = '5'

        allow(game_input).to receive(:gets).and_return(invalid_input, valid_input)
        expect(game_input).to receive(:display_err_invalid_input).once
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
        expect(game_input).to receive(:display_err_invalid_input).twice
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

  describe '#player_turns' do
    subject(:game_turns) { described_class.new }
    let(:board) { double(Board) }

    before do
      game_turns.instance_variable_set(:@board, board)
      allow(game_turns).to receive(:place_token)
      allow(board).to receive(:display)
    end

    context 'when board is full' do
      it 'stops loop' do
        allow(board).to receive(:full?).and_return(true)
        expect(game_turns).not_to receive(:place_token)
        game_turns.player_turns
      end
    end

    context 'when player_won? is true' do
      before do
        allow(board).to receive(:full?).and_return(false)
        allow(game_turns).to receive(:player_won?).and_return(true)
      end

      it 'stops loop' do
        expect(board).to receive(:full?).once
        game_turns.player_turns
      end

      it 'sets winner to current_player' do
        game_turns.player_turns
        expect(winner).to be(current_player)
      end
    end

    context 'when board is not full, and then full' do
      it 'calls switch_current_player at least once' do
        allow(board).to receive(:full?).and_return(false, true)
        allow(game_turns).to receive(:player_won?).and_return(false)
        expect(game_turns).to receive(:switch_current_player).once
        game_turns.player_turns
      end
    end
  end

  describe '#place_token' do
    subject(:game_token) { described_class.new }
    let(:current_player) { double(Player, token: 'X') }
    let(:column) { 7 }

    before do
      game_token.instance_variable_set(:@board, double(Board))
      allow(board).to receive(:update_column)
      allow(game_token).to receive(:player_input).and_return(column)
    end

    context 'when the selected column has empty spaces' do
      it 'updates the board and does not display error message' do
        allow(board).to receive(:column_full?).and_return(false)
        expect(board).to receive(:update_column)
        expect(game_token).not_to receive(:display_err_column_full)
        game_token.place_token(current_player)
      end
    end
    
    context 'when player selects a full column, then one with empty spaces' do
      it 'displays error message once' do
        allow(board).to receive(:column_full?).and_return(true, false)
        expect(game_token).to receive(:display_err_column_full).once
        game_token.place_token(current_player)
      end
    end
  end

  describe '#player_won?' do
    subject(:game_won) { described_class.new }

    it 'sends vertical, horizontal and/or diagonal messages to Board' do
      expect(board).to receive(:vertical_line?)
      expect(board).to receive(:horizontal_line?)
      expect(board).to receive(:diagonal_line?)
      game_won.player_won?
    end
  end

  describe '#switch_current_player' do
    subject(:game_switch) { described_class.new }

    before do
      player_one = double(Player, name: 'Player 1')
      player_two = double(Player, name: 'Player 2')
      game_switch.instance_variable_set(:@player_one, player_one)
      game_switch.instance_variable_set(:@player_two, player_two)
    end
    
    context 'when @current_player is @player_one' do
      it 'assigns @player_two to @current_player' do
        game_switch.instance_variable_set(:@current_player, player_one)
        game_switch.switch_current_player
        expect(current_player).to be(player_two)
      end
    end

    context 'when @current_player is @player_two' do
      it 'assigns @player_one to @current_player' do
        game_switch.instance_variable_set(:@current_player, player_two)
        game_switch.switch_current_player
        expect(current_player).to be(player_one)
      end
    end
  end
end
