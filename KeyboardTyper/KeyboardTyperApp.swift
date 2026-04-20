//
//  KeyboardTyperApp.swift
//  KeyboardTyper
//
//  Created by LiYanDong on 2026-04-17.
//

import SwiftUI

@main
struct KeyboardTyperApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .frame(minWidth: 800, idealWidth: 800, maxWidth: .infinity,
                       minHeight: 600, idealHeight: 600, maxHeight: .infinity)
        }
        .windowStyle(DefaultWindowStyle())
    }
}
