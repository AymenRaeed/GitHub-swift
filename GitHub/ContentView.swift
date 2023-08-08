//
//  ContentView.swift
//  GitHub
//
//  Created by Aymen Razaq on 7/10/23.
//

import SwiftUI

struct ContentView: View {
    @State private var user: GitHubUser?
    @StateObject var viewModel = ViewModel()
    
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
                user = try await viewModel.getUser()
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
}
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
