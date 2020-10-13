//
//  MinesweeperApp.swift
//  Minesweeper
//
//  Created by Brandon Baars on 10/11/20.
//

import SwiftUI

@main
struct MinesweeperApp: App {
    var gameSettings = GameSettings()

    var body: some Scene {
        WindowGroup {
            BoardView()
                .environmentObject(Game(from: gameSettings))
        }
    }
}
