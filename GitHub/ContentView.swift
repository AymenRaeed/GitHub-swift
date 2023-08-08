//
//  ContentView.swift
//  GitHub
//
//  Created by Aymen Razaq on 7/10/23.
//

import SwiftUI

struct ContentView: View {
    @State private var user: GitHubUser?
    
    var body: some View {
        VStack(spacing: 20) {
            
            AsyncImage(url: URL(string: user?.avatarUrl ?? "")) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .clipShape(Circle())
            } placeholder: {
                Circle()
                    .foregroundColor(.gray)
            }
            .frame(width: 120, height: 120)
            
            Text(user?.login ?? "Nill")
                .bold()
                .font(.title3)
            Text(user?.bio ?? "Nill")
                .padding()
            Spacer()
        }
        .padding()
        .task {
            do {
                user = try await getUser()
            } catch GHError.invalidURL {
                print("invalid URL")
            } catch GHError.invalidRes {
                print("invalid 1")
            } catch GHError.invalidData {
                print("invalid 2")
            } catch {
                print("invalid 3")
            }
        }
    }
    
    
    func getUser() async throws -> GitHubUser {
        let endpoint = "https://api.github.com/users/twostraws"
        guard let url = URL(string: endpoint) else { throw GHError.invalidURL}
        let (data, response) = try await URLSession.shared.data(from: url)
        guard let resonse = response as? HTTPURLResponse, resonse.statusCode == 200 else {
            throw GHError.invalidRes
        }
        do {
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            return try decoder.decode(GitHubUser.self, from: data)
        } catch {
            throw GHError.invalidData
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}


struct GitHubUser: Codable {
    let login: String
    let avatarUrl: String
    let bio: String
}

enum GHError: Error {
    case invalidURL
    case invalidRes
    case invalidData
}
