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
        VStack(spacing: 24) {
            if let user = clerk.user {
                UserProfileView(user: user)
                Button("Sign out") {
                    Task { await signOut()}
                }
            } else {
                Image("app-icon")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 100, height: 100)
                
                Text("Welcome")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                
                Text("Log in to your Coinbase account so that the widget has access to your account data")
                    .font(.subheadline)
                    .multilineTextAlignment(.center)
                    .foregroundColor(.secondary)
                    .padding(.horizontal)
                
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
        return "https://top-lion-7.clerk.accounts.dev/v1/oauth_callback/ios/fb.CoinbaseDaily/callback"
    }
    func signIn() async {
        do {
            let signIn = try await SignIn.create(strategy: .oauth(provider: .coinbase, redirectUrl: Self.redirectUrl))
            let result = try await signIn.authenticateWithRedirect()
            print("reuslt from signup: \(result)")
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
