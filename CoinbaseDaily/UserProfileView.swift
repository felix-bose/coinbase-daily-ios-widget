//
//  UserProfileView.swift
//  CoinbaseDaily
//
//  Created by Felix Bose on 22.03.25.
//

import SwiftUI
import Clerk

struct UserProfileView: View {
    let user: User

    var body: some View {
        HStack(spacing: 12) {
            if user.hasImage, let url = URL(string: user.imageUrl), !user.imageUrl.isEmpty {
                AsyncImage(url: url) { phase in
                    switch phase {
                    case .empty:
                        // Placeholder while loading
                        ProgressView()
                            .frame(width: 40, height: 40)
                    case .success(let image):
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 40, height: 40)
                            .clipShape(Circle())
                    case .failure:
                        // If the image fails to load, fallback to a system image
                        Image(systemName: "person.crop.circle.badge.exclam")
                            .resizable()
                            .frame(width: 40, height: 40)
                            .foregroundColor(.gray)
                    @unknown default:
                        EmptyView()
                    }
                }
            } else {
                // Fallback if no user image is available
                Image(systemName: "person.crop.circle")
                    .resizable()
                    .frame(width: 40, height: 40)
                    .foregroundColor(.gray)
            }

            VStack(alignment: .leading) {
                Text("\(String(describing: user.firstName)) \(String(describing: user.lastName))")
                    .font(.headline)
                Text(user.emailAddresses[0].emailAddress)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
        }
        .padding()
    }
}
