class Cell
  attr_accessor :value

  def initialize(value = ' ')
    self.value = value
  end
end

class Board
  attr_accessor :board, :player1, :player2

  def initialize
    self.board = Array.new(3) { Array.new(3) { Cell.new } }
    self.player1 = Hash[name: 'Player1', symbol: 'X']
    self.player2 = Hash[name: 'Player2', symbol: 'O']
    @LINES = [[0, 1, 2], [0, 0, 0], [1, 1, 1], [2, 2, 2], [2, 1, 0]]
  end

  def initGame
    gameOver = false
    currentPlayer = player1

    while gameOver == false
      puts "#{currentPlayer[:name]} enter row and col:"
      playerChoice = gets.chomp

      row = playerChoice[0].to_i - 1
      col = playerChoice[1].to_i - 1

      if row < 0 || row > 2 || col < 0 || col > 2
        puts 'Player choice is out of bounderies!'
      elsif getValue(row, col) == player1[:symbol] || getValue(row, col) == player2[:symbol]
        puts "Choice already made in cell with #{getValue(row, col)}"
      else
        setValue(row, col, currentPlayer[:symbol])

        sequence = []

        board.each_with_index do |_vi, i|
          board[i].each_with_index do |vy, y|
            sequence.push(y) if vy.value == currentPlayer[:symbol]
          end
        end

        displayBoard

        if winningMove?(sequence)
          p "GAME OVER! #{currentPlayer[:name]} WINS!"
          gameOver = true
        elsif isFull?
          p 'GAME IS TIE!'
          clearBoard
        end

        currentPlayer = currentPlayer == player1 ? player2 : player1
      end
    end
  end

  def getValue(row, col)
    board[row][col].value
  end

  def setValue(row, col, value)
    board[row][col].value = value
  end

  def displayBoard
    puts '========='
    puts "|#{getValue(0, 0)}|#{getValue(0, 1)}|#{getValue(0, 2)}|"
    puts '---------'
    puts "|#{getValue(1, 0)}|#{getValue(1, 1)}|#{getValue(1, 2)}|"
    puts '---------'
    puts "|#{getValue(2, 0)}|#{getValue(2, 1)}|#{getValue(2, 2)}|"
    puts '========='
  end

  def isFull?
    full = true

    board.each_with_index do |_vi, i|
      board[i].each_with_index do |vy, _y|
        full = false if vy.value == ' '
      end
    end

    full
  end

  def clearBoard
    board.each_with_index do |_vi, i|
      board[i].each_with_index do |vy, _y|
        vy.value = ''
      end
    end
  end

  def winningMove?(sequence)
    @LINES.each do |winLine|
      return true if sequence.eql?(winLine)
    end

    false
  end
end

gameBoard = Board.new
gameBoard.initGame
