# frozen_string_literal: true

require_relative '../lib/board'

# Connect Four Board
describe Board do
  describe '#create_board' do
    subject(:initial_board) { described_class.new }
    let(:columns) { initial_board.instance_variable_get(:@columns) }

    it 'is a hash of 7 columns each with an array of 6 empty rows' do
      column = 1
      row = 0
      expect(columns).to be_instance_of(Hash)
      expect(columns.size).to eq(7)
      expect(columns[column]).to be_instance_of(Array)
      expect(columns[column].size).to eq(6)
      expect(columns[column][row]).to eq(' ')
    end
  end

  describe '#update_column' do
    subject(:board_update) { described_class.new }
    let(:columns) { board_update.instance_variable_get(:@columns) }
    let(:player) { double('Player', token: '') }

    it 'piles the most recent token on top of the oldest one' do
      allow(player).to receive(:token).and_return('X', 'Y', 'Z')
      column = 3
      column_order = ['X', 'Y', 'Z', ' ', ' ', ' ']
      expect { 3.times { board_update.update_column(column, player.token) } }.to change{ columns[column] }.to eq(column_order)
    end

    context 'when all spaces within a column are available' do
      it 'adds the player token to the bottom row' do
        allow(player).to receive(:token).and_return('X')
        column = 1 
        row = 0 # bottom / first row
        expect { board_update.update_column(column, player.token) }.to change { columns[column][row] }.to eq('X')
      end
    end

    context 'when the lowest available space within column 2 is in row 1' do
      it 'adds the player token to column 2, row 1' do
        allow(player).to receive(:token).and_return('X', 'Y')
        column = 2 
        row = 1 # second row
        expect { 2.times { board_update.update_column(column, player.token) } }.to change{ columns[column][row] }.to eq('Y')
      end
    end
  end

  describe '#column_full?' do
    context 'when there are no spaces available within a column' do
      subject(:board_full_column) { described_class.new }
      let(:columns) { board_full_column.instance_variable_get(:@columns) }
      let(:full_column) { ['X', 'X', 'X', 'X', 'X', 'X'] }
  
      it 'returns true' do
        column = 4
        columns[4] = full_column
        result = board_full_column.column_full?(column)
        expect(result).to eq(true)
      end
    end
    
    context 'when there is at least one empty space within a column' do
      subject(:board_non_full_column) { described_class.new }
      let(:columns) { board_non_full_column.instance_variable_get(:@columns) }
      let(:non_full_column) { ['X', 'X', 'X', 'X', 'X', ' '] }
  
      it 'returns false' do
        column = 5
        columns[5] = non_full_column
        result = board_non_full_column.column_full?(column)
        expect(result).to eq(false)
      end
    end
  end
end
