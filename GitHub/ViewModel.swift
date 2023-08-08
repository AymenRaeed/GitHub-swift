//
//  ViewModel.swift
//  GitHub
//
//  Created by Aymen Razaq on 8/9/23.
//

import Foundation


class ViewModel: ObservableObject {
    
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
