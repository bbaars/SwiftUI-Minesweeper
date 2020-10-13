//
//  Game.swift
//  Minesweeper
//
//  Created by Brandon Baars on 10/11/20.
//

import Foundation

class Game: ObservableObject {
    /// The game settings
    @Published var settings: GameSettings

    /// The game board
    @Published var board: [[Cell]]

    @Published var didLose: Bool = false

    init(from settings: GameSettings) {
        self.settings = settings
        board = Self.generateBoard(from: settings)
    }

    func click(on cell: Cell) {
        // Check we didn't click on a bomb
        if cell.status == .bomb {
            cell.isOpened = true
            didLose = true
        } else {
            reveal(for: cell)
        }

        self.objectWillChange.send()
    }

    func toggleFlag(on cell: Cell) {
        guard !cell.isOpened else {
            return
        }

        cell.isFlagged = !cell.isFlagged

        self.objectWillChange.send()
    }

    func reset() {
        board = Self.generateBoard(from: settings)
        didLose = false
    }

    // MARK: - Private Functions
    private func reveal(for cell: Cell) {
        guard !cell.isOpened else {
            return
        }

        guard !cell.isFlagged else {
            return
        }

        guard cell.status != .bomb else {
            return
        }

        let exposedCount = getExposedCount(for: cell)

        if cell.status != .bomb {
            cell.status = .exposed(exposedCount)
            cell.isOpened = true
        }

        if (exposedCount == 0) {
            // get the neighboring cells (top, bottom, left and right)
            // make sure they aren't passed the size of our board
            let topCell = board[max(0, cell.row - 1)][cell.column]
            let bottomCell = board[min(cell.row + 1, board.count - 1)][cell.column]
            let leftCell = board[cell.row][max(0, cell.column - 1)]
            let rightCell = board[cell.row][min(cell.column + 1, board[0].count - 1)]

            reveal(for: topCell)
            reveal(for: bottomCell)
            reveal(for: leftCell)
            reveal(for: rightCell)
        }
    }

    /// Get the number of bombs that are neighboring the cell
    /// - Parameters:
    ///   - cell: The cell to get the exposed count for
    /// - Returns: The number of bombs that neighbor the cell
    private func getExposedCount(for cell: Cell) -> Int {
        let row = cell.row
        let col = cell.column

        let minRow = max(row - 1, 0)
        let minCol = max(col - 1, 0)
        let maxRow = min(row + 1, board.count - 1)
        let maxCol = min(col + 1, board[0].count - 1)

        var totalBombCount = 0
        for row in minRow...maxRow {
            for col in minCol...maxCol {
                if board[row][col].status == .bomb {
                    totalBombCount += 1
                }
            }
        }

        return totalBombCount
    }

    /// Generate the board with the given number of boms
    /// - Parameter settings: The game settings to create the board from
    /// - Returns: 2D array of cells from which the starting game will be played
    private static func generateBoard(from settings: GameSettings) -> [[Cell]] {
        var newBoard = [[Cell]]()

        for row in 0..<settings.numberOfRows {
            var column = [Cell]()

            for col in 0..<settings.numberOfColumns {
                column.append(Cell(row: row, column: col))
            }

            newBoard.append(column)
        }

        var numberOfBombsPlaced = 0
        while numberOfBombsPlaced < settings.numberOfBombs {
            // Generate a random number that will fall somewhere in our board
            let randomRow = Int.random(in: 0..<settings.numberOfRows)
            let randomCol = Int.random(in: 0..<settings.numberOfColumns)

            let currentRandomCellStatus = newBoard[randomRow][randomCol].status
            if currentRandomCellStatus != .bomb {
                newBoard[randomRow][randomCol].status = .bomb
                numberOfBombsPlaced += 1
            }
        }

        return newBoard
    }
}
