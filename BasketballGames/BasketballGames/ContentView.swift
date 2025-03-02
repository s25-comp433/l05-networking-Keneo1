//
//  ContentView.swift
//  BasketballGames
//
//  Created by Samuel Shi on 2/27/25.
//

import SwiftUI


struct Result: Codable {
    var date: String
    var id: Int
    var opponent: String
    var isHomeGame: Bool
    var score: Score
    var team: String
}

struct Score: Codable {
    var unc: Int
    var opponent: Int
}


struct ContentView: View {
    @State private var results = [Result]()
    
    var body: some View {
        Text("UNC Basketball")
        
        List(results, id: \.id) { item in
            VStack(alignment: .leading) {
                HStack(){
                    Text("\(item.team) vs. \(item.opponent)")
                    Spacer()
                    Text("\(item.score.unc) - \(item.score.opponent)")
                }
                
                HStack() {
                    Text(item.date)
                    Spacer()
                    if item.isHomeGame {
                        Text("Home")
                    } else {
                        Text("Away")
                    }
                }
            }
            .padding()
        }
        .task{
            await loadData()
        }
    }
    
    func loadData() async {
        guard let url = URL(string: "https://api.samuelshi.com/uncbasketball") else {
            print("Invalid URL")
            return
        }
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            
            if let decodedResponse = try? JSONDecoder().decode([Result].self, from:data) {
                results = decodedResponse
            }
        } catch {
            print("Invalid data")
        }
    }
}

#Preview {
    ContentView()
}
