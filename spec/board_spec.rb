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
        columns[column] = full_column
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
        columns[column] = non_full_column
        result = board_non_full_column.column_full?(column)
        expect(result).to eq(false)
      end
    end
  end

  describe '#vertical_line?' do
    subject(:board_vertical) { described_class.new }
    let(:columns) { board_vertical.instance_variable_get(:@columns) }

    context 'when a player forms a vertical line of 4 of their own token' do
      context 'when the vertical line is at the bottom of the column' do
        let(:line_bottom) { ['X', 'X', 'X', 'X', ' ', ' '] }

        it 'returns true' do
          column = 1
          columns[column] = line_bottom
          result = board_vertical.vertical_line?
          expect(result).to eq(true)
        end
      end

      context 'when the vertical line is at the middle of the column' do
        let(:line_middle) { [' ', 'X', 'X', 'X', 'X', ' '] }

        it 'returns true' do
          column = 1
          columns[column] = line_middle
          result = board_vertical.vertical_line?
          expect(result).to eq(true)
        end
      end

      context 'when the vertical line is at the top of the column' do
        let(:line_top) { [' ', ' ', 'X', 'X', 'X', 'X'] }

        it 'returns true' do
          column = 1
          columns[column] = line_top
          result = board_vertical.vertical_line?
          expect(result).to eq(true)
        end
      end
    end

    context "when the 4 tokens don't form a vertical line" do
      let(:no_vertical_line) { ['X', ' ', ' ', 'X', 'X', 'X'] }

      it 'returns false' do
        column = 1
        columns[column] = no_vertical_line
        result = board_vertical.vertical_line?
        expect(result).to eq(false)
      end
    end

    context 'if the column has less than 4 tokens' do
      let(:less_tokens) { ['X', ' ', 'X', ' ', ' ', 'X'] }

      it 'returns false' do
        column = 1
        columns[column] = less_tokens
        result = board_vertical.vertical_line?
        expect(result).to eq(false)
      end
    end
  end

  describe '#horizontal_line?' do
    subject(:board_horizontal) { described_class.new }

    context 'when a player forms a horizontal line of 4 of their own token' do 
      context 'when the horizontal line is at the beginning of the row' do
        let(:line_begin) { Hash[ 
          1 => ['X', ' ', ' ', ' ', ' ', ' '],
          2 => ['X', ' ', ' ', ' ', ' ', ' '],
          3 => ['X', ' ', ' ', ' ', ' ', ' '],
          4 => ['X', ' ', ' ', ' ', ' ', ' '],
          5 => [' ', ' ', ' ', ' ', ' ', ' '],
          6 => [' ', ' ', ' ', ' ', ' ', ' '],
          7 => [' ', ' ', ' ', ' ', ' ', ' ']]
        }

        it 'returns true' do
          board_horizontal.instance_variable_set(:@columns, line_begin)
          result = board_horizontal.horizontal_line?
          expect(result).to eq(true)
        end
      end

      context 'when the horizontal line is in the middle of the row' do
        let(:line_middle_one) { Hash[
          1 => [' ', ' ', ' ', ' ', ' ', ' '],
          2 => ['X', ' ', ' ', ' ', ' ', ' '],
          3 => ['X', ' ', ' ', ' ', ' ', ' '],
          4 => ['X', ' ', ' ', ' ', ' ', ' '],
          5 => ['X', ' ', ' ', ' ', ' ', ' '],
          6 => [' ', ' ', ' ', ' ', ' ', ' '],
          7 => [' ', ' ', ' ', ' ', ' ', ' ']]
        }

        it 'returns true' do
          board_horizontal.instance_variable_set(:@columns, line_middle_one)
          result = board_horizontal.horizontal_line?
          expect(result).to eq(true)
        end
      end
      
      context 'when the horizontal line is in the other middle of the row' do
        let(:line_middle_two) { Hash[
          1 => [' ', ' ', ' ', ' ', ' ', ' '],
          2 => [' ', ' ', ' ', ' ', ' ', ' '],
          3 => ['X', ' ', ' ', ' ', ' ', ' '],
          4 => ['X', ' ', ' ', ' ', ' ', ' '],
          5 => ['X', ' ', ' ', ' ', ' ', ' '],
          6 => ['X', ' ', ' ', ' ', ' ', ' '],
          7 => [' ', ' ', ' ', ' ', ' ', ' ']]
        }

        it 'returns true' do
          board_horizontal.instance_variable_set(:@columns, line_middle_two)
          result = board_horizontal.horizontal_line?
          expect(result).to eq(true)
        end
      end

      context 'when the horizontal line is at the end of the row' do
        let(:line_end) { Hash[
          1 => [' ', ' ', ' ', ' ', ' ', ' '],
          2 => [' ', ' ', ' ', ' ', ' ', ' '],
          3 => [' ', ' ', ' ', ' ', ' ', ' '],
          4 => ['X', ' ', ' ', ' ', ' ', ' '],
          5 => ['X', ' ', ' ', ' ', ' ', ' '],
          6 => ['X', ' ', ' ', ' ', ' ', ' '],
          7 => ['X', ' ', ' ', ' ', ' ', ' ']]
        }

        it 'returns true' do
          board_horizontal.instance_variable_set(:@columns, line_end)
          result = board_horizontal.horizontal_line?
          expect(result).to eq(true)
        end
      end
    end
    
    context "when the 4 tokens don't form a horizontal line" do
      let(:no_horizontal_line) { Hash[
        1 => [' ', ' ', ' ', ' ', ' ', ' '],
        2 => [' ', ' ', ' ', ' ', ' ', ' '],
        3 => ['X', ' ', ' ', ' ', ' ', ' '],
        4 => [' ', ' ', ' ', ' ', ' ', ' '],
        5 => ['X', ' ', ' ', ' ', ' ', ' '],
        6 => ['X', ' ', ' ', ' ', ' ', ' '],
        7 => ['X', ' ', ' ', ' ', ' ', ' ']]
      }

      it 'returns false' do
        board_horizontal.instance_variable_set(:@columns, no_horizontal_line)
        result = board_horizontal.horizontal_line?
        expect(result).to eq(false)
      end
    end

    context 'if a row has less than 4 tokens' do
      let(:less_than_four_tokens) { Hash[
        1 => [' ', ' ', ' ', ' ', ' ', ' '],
        2 => ['X', ' ', ' ', ' ', ' ', ' '],
        3 => [' ', ' ', ' ', ' ', ' ', ' '],
        4 => [' ', ' ', ' ', ' ', ' ', ' '],
        5 => ['X', ' ', ' ', ' ', ' ', ' '],
        6 => ['X', ' ', ' ', ' ', ' ', ' '],
        7 => [' ', ' ', ' ', ' ', ' ', ' ']]
      }

      it 'returns false' do
        board_horizontal.instance_variable_set(:@columns, less_than_four_tokens)
        result = board_horizontal.horizontal_line?
        expect(result).to eq(false)
      end
    end
  end

  describe '#diagonal_line?' do
    subject(:board_diagonal) { described_class.new }
    
    context 'when a player forms a diagonal line of 4 of their own token' do 
      context 'case 1: diagonal line from the bottom row' do
        let(:diagonal_one_left) { Hash[
          1 => ['X', ' ', ' ', ' ', ' ', ' '],
          2 => [' ', 'X', ' ', ' ', ' ', ' '],
          3 => [' ', ' ', 'X', ' ', ' ', ' '],
          4 => [' ', ' ', ' ', 'X', ' ', ' '],
          5 => [' ', ' ', ' ', ' ', ' ', ' '],
          6 => [' ', ' ', ' ', ' ', ' ', ' '],
          7 => [' ', ' ', ' ', ' ', ' ', ' ']]
        }

        it 'returns true (line from left to right side)' do
          board_diagonal.instance_variable_set(:@columns, diagonal_one_left)
          result = board_diagonal.diagonal_line?
          expect(result).to eq(true)
        end

        let(:diagonal_one_right) { Hash[
          1 => [' ', ' ', ' ', ' ', ' ', ' '],
          2 => [' ', ' ', ' ', ' ', ' ', ' '],
          3 => [' ', ' ', ' ', ' ', ' ', ' '],
          4 => [' ', ' ', ' ', 'X', ' ', ' '],
          5 => [' ', ' ', 'X', ' ', ' ', ' '],
          6 => [' ', 'X', ' ', ' ', ' ', ' '],
          7 => ['X', ' ', ' ', ' ', ' ', ' ']]
        }

        it 'returns true (line from right to left side)' do
          board_diagonal.instance_variable_set(:@columns, diagonal_one_right)
          result = board_diagonal.diagonal_line?
          expect(result).to eq(true)
        end
      end

      context 'case 2: diagonal line in the middle of the board' do
        let(:diagonal_two_left) { Hash[ 
          1 => [' ', ' ', ' ', ' ', ' ', ' '],
          2 => [' ', 'X', ' ', ' ', ' ', ' '],
          3 => [' ', ' ', 'X', ' ', ' ', ' '],
          4 => [' ', ' ', ' ', 'X', ' ', ' '],
          5 => [' ', ' ', ' ', ' ', 'X', ' '],
          6 => [' ', ' ', ' ', ' ', ' ', ' '],
          7 => [' ', ' ', ' ', ' ', ' ', ' ']]
        }

        it 'returns true (line from left to right side)' do
          board_diagonal.instance_variable_set(:@columns, diagonal_two_left)
          result = board_diagonal.diagonal_line?
          expect(result).to eq(true)
        end
        
        let(:diagonal_two_right) { Hash[ 
          1 => [' ', ' ', ' ', ' ', ' ', ' '],
          2 => [' ', ' ', ' ', ' ', ' ', ' '],
          3 => [' ', ' ', ' ', ' ', 'X', ' '],
          4 => [' ', ' ', ' ', 'X', ' ', ' '],
          5 => [' ', ' ', 'X', ' ', ' ', ' '],
          6 => [' ', 'X', ' ', ' ', ' ', ' '],
          7 => [' ', ' ', ' ', ' ', ' ', ' ']]
        }

        it 'returns true (line from right to left side)' do
          board_diagonal.instance_variable_set(:@columns, diagonal_two_right)
          result = board_diagonal.diagonal_line?
          expect(result).to eq(true)
        end
      end
      
      context 'case 3: diagonal line at the end of the board' do
        let(:diagonal_three_left) { Hash[ 
          1 => [' ', ' ', ' ', ' ', ' ', ' '],
          2 => [' ', ' ', ' ', ' ', ' ', ' '],
          3 => [' ', ' ', ' ', ' ', ' ', ' '],
          4 => [' ', ' ', 'X', ' ', ' ', ' '],
          5 => [' ', ' ', ' ', 'X', ' ', ' '],
          6 => [' ', ' ', ' ', ' ', 'X', ' '],
          7 => [' ', ' ', ' ', ' ', ' ', 'X']]
        }

        it 'returns true (line from left to right side)' do
          board_diagonal.instance_variable_set(:@columns, diagonal_three_left)
          result = board_diagonal.diagonal_line?
          expect(result).to eq(true)
        end
        
        let(:diagonal_three_right) { Hash[ 
          1 => [' ', ' ', ' ', ' ', ' ', 'X'],
          2 => [' ', ' ', ' ', ' ', 'X', ' '],
          3 => [' ', ' ', ' ', 'X', ' ', ' '],
          4 => [' ', ' ', 'X', ' ', ' ', ' '],
          5 => [' ', ' ', ' ', ' ', ' ', ' '],
          6 => [' ', ' ', ' ', ' ', ' ', ' '],
          7 => [' ', ' ', ' ', ' ', ' ', ' ']]
        }

        it 'returns true (line from right to left side)' do
          board_diagonal.instance_variable_set(:@columns, diagonal_three_right)
          result = board_diagonal.diagonal_line?
          expect(result).to eq(true)
        end

      end
    end

    context "when the diagonal line is not made of the same token" do
      let(:no_diagonal_line_left) { Hash[ 
        1 => [' ', ' ', ' ', ' ', ' ', ' '],
        2 => ['Z', ' ', ' ', ' ', ' ', ' '],
        3 => ['Z', 'X', ' ', ' ', ' ', ' '],
        4 => ['Z', 'X', 'X', ' ', ' ', ' '],
        5 => ['X', 'Z', 'Z', 'X', ' ', ' '],
        6 => [' ', ' ', ' ', ' ', ' ', ' '],
        7 => [' ', ' ', ' ', ' ', ' ', ' ']]
      }

      it 'returns false (line from left to right side)' do
        board_diagonal.instance_variable_set(:@columns, no_diagonal_line_left)
        result = board_diagonal.diagonal_line?
        expect(result).to eq(false)
      end
      
      let(:no_diagonal_line_right) { Hash[ 
        1 => [' ', ' ', ' ', ' ', ' ', ' '],
        2 => [' ', ' ', ' ', ' ', ' ', ' '],
        3 => ['X', 'Z', 'Z', 'X', ' ', ' '],
        4 => ['Z', 'Z', 'X', ' ', ' ', ' '],
        5 => ['X', 'Z', 'Z', 'X', ' ', ' '],
        6 => ['X', ' ', ' ', ' ', ' ', ' '],
        7 => ['Z', ' ', ' ', ' ', ' ', ' ']]
      }

      it 'returns false (line from right to left side)' do
        board_diagonal.instance_variable_set(:@columns, no_diagonal_line_right)
        result = board_diagonal.diagonal_line?
        expect(result).to eq(false)
      end
    end
  end
end
