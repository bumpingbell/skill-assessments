## Header
### input
if (interactive()) {
  con <- stdin()
} else {
  con <- "stdin"
}

### decide player
input_player <- function() {
  cat("X or O?\n")
  input <- readLines(con = con, n = 1)
  if (input %in% c("X", "O")) {
    cat("Player set to", input, "\n")
    return(input)
  } else {
    cat("Error: You must enter \"X\" or \"O\"\n")
    input_player()
  }
}

### determine position
input_position <- function() {
  while (TRUE) {
    cat("Which row?\n")
    input <- readLines(con = con, n = 1)
    while (!(input %in% c("1", "2", "3"))) {
      cat("Error: should be number 1-3\nWhich row?\n")
      input <- readLines(con = con, n = 1)
    }
    row <- as.numeric(input)

    cat("Which column?\n")
    input <- readLines(con = con, n = 1)
    while (!(input %in% c("1", "2", "3"))) {
      cat("Error: should be number 1-3\nWhich column?\n")
      input <- readLines(con = con, n = 1)
    }
    column <- as.numeric(input)

    if (is.na(board[row, column])) {
      break
    } else {
      cat("Error: This spot is taken! Repeating...\n")
    }
  }
  return(c(row, column))
}

computer_generate_position <- function() {
  while (TRUE) {
    row <- c(sample(1:3, 1))
    column <- c(sample(1:3, 1))
    if (is.na(board[row, column])) {
      break
    }
  }
  return(c(row, column))
}


### move
make_move <- function(position, sign) {
  Sys.sleep(1)
  board[position[1], position[2]] <<- sign
  cat("Move placed at ", position, "\n")
  print(board)
}

### judgement of wins
check_game_over <- function() {
  winner <- NA
  # stalemate (if someone wins at last move, winner will be overridden later)
  if (any(is.na(board)) == FALSE) {
    winner <- "Stalemate"
  }

  # horizontal
  for (i in 1:3) {
    if (identical(board[i, 1:3], c("O", "O", "O"))) {
      winner <- "O"
    } else if (identical(board[i, 1:3], c("X", "X", "X"))) {
      winner <- "X"
    }
  }

  # longitudinal
  for (i in 1:3) {
    if (identical(board[1:3, i], c("O", "O", "O"))) {
      winner <- "O"
    } else if (identical(board[1:3, i], c("X", "X", "X"))) {
      winner <- "X"
    }
  }

  # diagonal
  if ((identical(c(board[1], board[5], board[9]), c("O", "O", "O"))) |
    (identical(c(board[3], board[5], board[7]), c("O", "O", "O")))) {
    winner <- "O"
  } else if ((identical(c(board[1], board[5], board[9]), c("X", "X", "X"))) |
    (identical(c(board[3], board[5], board[7]), c("X", "X", "X")))) {
    winner <- "X"
  }

  # return
  if (is.na(winner)) {
    return(c(gameOver = FALSE, winner = NA))
  } else {
    return(c(gameOver = TRUE, winner = winner))
  }
}

### end game
end_game <- function() {
  if (gameStatus["winner"] == "Stalemate") {
    cat("Stalemate!\n")
  } else {
    cat(paste("Game over, winner is", gameStatus["winner"], "\nPlayer:", player_sign, "; Computer:", computer_sign, "\n"))
  }
}



## Main
### Determine player and computer's sign
cat("Welcome to this game! Select your player (X goes first): \n")
player_sign <- input_player()
if (player_sign == "X") {
  computer_sign <- "O"
} else {
  computer_sign <- "X"
}

### initialize board
board <- matrix(NA, nrow = 3, ncol = 3)

### player move first? and make first move if so
if (player_sign == "X") {
  cat("Player goes first\n")
  cat("Player's turn: holding ", player_sign, "\n")
  position <- input_position()
  make_move(position, player_sign)
} else {
  cat("Computer goes first\n")
}

### continue until game ends
while (TRUE) {
  # computer's move
  cat("Computer's turn: holding ", computer_sign, "\n")
  Sys.sleep(1)
  position <- computer_generate_position()
  make_move(position, computer_sign)
  gameStatus <- check_game_over()
  if (gameStatus["gameOver"] == TRUE) {
    end_game()
    break
  }

  # player's move
  cat("Player's turn: ", player_sign, "\n")
  position <- input_position()
  make_move(position, player_sign)
  gameStatus <- check_game_over()
  if (gameStatus["gameOver"] == TRUE) {
    end_game()
    break
  }
}
