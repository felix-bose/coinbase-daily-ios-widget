//
//  SignInView.swift
//  CoinbaseDaily
//
//  Created by Felix Schaipp on 22.03.25.
//

import SwiftUI
import Clerk

struct SignInWithCoinbaseView: View {
    @Environment(Clerk.self) private var clerk
    var body: some View {
        VStack {
            if let user = clerk.user {
                UserProfileView(user: user)
                Button("Sign out") {
                    Task { await signOut()}
                }
            } else {
                Button {
                    Task { await signIn() }
                } label: {
                    HStack {
                        Image("CoinbaseLogo").resizable()
                            .scaledToFit()
                            .frame(width: 20, height: 20)
                        Text("Sign in with coinbase")
                    }
                }
                .padding(.horizontal, 24)
                .padding(.vertical, 12)
                .background(Color(hex: "#0052FF"))
                .foregroundColor(.white)
                .font(.headline)
                .cornerRadius(24)
            }
        }
        .padding()
    }
}

extension SignInWithCoinbaseView {
    private static var redirectUrl: String {
        return "https://top-lion-7.clerk.accounts.dev/v1/oauth_callback"
    }
    func signIn() async {
        do {
            try await SignIn.authenticateWithRedirect(strategy: .oauth(provider: .coinbase, redirectUrl: SignInWithCoinbaseView.redirectUrl))
            if let jwt = try await getJWT() {
                print("JWT for syncing \(jwt)")
                saveToSharedDefaults(key: "JWT",value: jwt)
            } else {
                print("JWT does not exist for session")
            }
            if let user = clerk.user {
                saveToSharedDefaults(key: "userID", value: user.id)
            }
        } catch {
            dump(error)
        }
    }
    
    func getJWT() async throws -> String? {
        guard let session = Clerk.shared.session else { return nil }
        
        let tokenResponse = try await session.getToken()
        
        return tokenResponse?.jwt

    }
    
    func signOut() async {
        do {
            try await clerk.signOut()
        } catch {
            dump(error)
        }
    }
    
    func saveToSharedDefaults<T>(key: String, value: T) {
        if let sharedDefaults = UserDefaults(suiteName: "group.com.coinbasedaily.widget") {
            sharedDefaults.set(value, forKey: key)
            sharedDefaults.synchronize()
        }
    }

}
