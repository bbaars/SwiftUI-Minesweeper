//
//  Cell+Extension.swift
//  Minesweeper
//
//  Created by Brandon Baars on 10/12/20.
//

import Foundation

extension Cell {
    /// Denoting the different states a square can be in
    enum Status: Equatable {
        /// The square is untouched
        case normal

        /// The square has been opened and nothing is in it
        /// value 1: - The number of bombs the square is touching. 0 for none.
        case exposed(Int)

        /// There is a bomb in the square
        case bomb
    }
}
