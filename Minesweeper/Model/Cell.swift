//
//  Cell.swift
//  Minesweeper
//
//  Created by Brandon Baars on 10/12/20.
//

import Foundation
import SwiftUI // Add this for being able to use Image

class Cell: ObservableObject {
    /// The row of the cell on the board
    var row: Int

    /// The column of the cell on the board
    var column: Int

    /// Current state of the cell
    @Published var status: Status

    /// Whether or not the cell has been opened/touched
    @Published var isOpened: Bool

    /// Whether or not the cell has been flagged
    @Published var isFlagged: Bool

    /// Get the image associated to the status of the cell
    var image: Image {
        if !isOpened && isFlagged {
            return Image("flag")
        }

        switch status {
        case .bomb:
            if isOpened {
                return Image("bomb")
            }

            return Image("normal")
        case .normal:
            return Image("normal")
        case .exposed(let total):
            if !isOpened {
                return Image("normal")
            }

            if total == 0 {
                return Image("empty")
            }

            return Image("\(total)")
        }
    }

    init(row: Int, column: Int) {
        self.row = row
        self.column = column
        self.status = .normal
        self.isOpened = false
        self.isFlagged = false
    }
}
