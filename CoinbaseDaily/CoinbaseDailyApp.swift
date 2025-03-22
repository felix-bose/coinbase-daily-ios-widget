//
//  CoinbaseDailyApp.swift
//  CoinbaseDaily
//
//  Created by Felix Bose on 22.02.25.
//

import SwiftUI
import Clerk

@main
struct CoinbaseDailyApp: App {
    @State private var clerk = Clerk.shared
    var body: some Scene {
        WindowGroup {
            ZStack {
                    if clerk.isLoaded {
                      ContentView()
                    } else {
                      ProgressView()
                    }
                  }
                  .environment(clerk)
                  .task {
                    clerk.configure(publishableKey: "pk_test_dG9wLWxpb24tNy5jbGVyay5hY2NvdW50cy5kZXYk")
                    try? await clerk.load()
                  }
        }
    }
}
