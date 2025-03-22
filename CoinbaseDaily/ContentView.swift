//
//  ContentView.swift
//  CoinbaseDaily
//
//  Created by Felix Schaipp on 22.02.25.
//

import SwiftUI
import Clerk

struct ContentView: View {
    @Environment(Clerk.self) private var clerk
    var body: some View {
        VStack {
                SignInWithCoinbaseView()
           }
        .padding()
    }
}

#Preview {
    ContentView()
}
