//
//  Networking.swift
//  CoinbaseDaily
//
//  Created by Felix Bose on 22.02.25.
//

import Foundation

func fetchPortfolioData(completion: @escaping (Double, [Double]) -> Void) {
    guard let sharedDefaults = UserDefaults(suiteName: "group.com.coinbasedaily.widget"),
              let userID = sharedDefaults.string(forKey: "userID") else {
            print("userID not found in shared defaults")
            completion(0.0, [])
            return
        }
        
        // Construct the URL using the userID as the account_id.
        let urlString = "https://api.coinbase.com/v2/accounts/\(userID)"
        guard let url = URL(string: urlString) else {
            completion(0.0, [])
            return
        }
        
        var request = URLRequest(url: url)
    if let sharedDefaults = UserDefaults(suiteName: "group.com.coinbasedaily.widget"),
           let jwt = sharedDefaults.string(forKey: "JWT") {
            request.addValue("Bearer \(jwt)", forHTTPHeaderField: "Authorization")
        } else {
            print("JWT not found in shared defaults")
            completion(0.0, [])
            return
        }
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                completion(0.0, [])
                return
            }
            
            do {
                let accountsResponse = try JSONDecoder().decode(AccountsResponse.self, from: data)
                print(accountsResponse.data)
                // Compute the total native balance (assuming USD)
                let totalNativeBalance = accountsResponse.data.compactMap { Double($0.balance.amount) }.reduce(0, +)
                
                // --- Simulate historical data for the chart ---
                // For demonstration, we'll create an array of 10 data points.
                // In a production app, you might fetch this history from your own server or record it locally over time.
                let simulatedChartData = (0..<10).map { index -> Double in
                    // For example, simulate small fluctuations around the current total:
                    // Variation between -10 and +10 USD for each simulated point.
                    let variation = Double.random(in: -10...10)
                    return totalNativeBalance - variation
                }
                
                DispatchQueue.main.async {
                    completion(totalNativeBalance, simulatedChartData)
                }
            } catch {
                DispatchQueue.main.async {
                    completion(0.0, [])
                }
            }
        }.resume()
}

struct CoinbaseAccount: Decodable {
    let id: String
    let name: String
    let balance: Balance
    let primary: Bool
    let updated_at: String
    let created_at: String
    let currency: Currency
}

struct Currency: Decodable {
    let address_regex: String
    let asset_id: String
    let code: String
    let color: String
    let exponent: Int
    let name: String
    let slug: String
    let sort_index: Int
    let type: String
    
}

struct Balance: Decodable {
    let amount: String
    let currency: String
}

struct AccountsResponse: Decodable {
    let data: [CoinbaseAccount]
}

struct PortfolioResponse: Decodable {
    let totalGains: Double
    let chartData: [Double]
}
