import Foundation
import Combine
import CryptoKit
import SwiftUI

class HomeViewModel: ObservableObject {
    @Published var searchQuery = ""
    @Published var fetchedCharacter: [CharactersModel]? = nil
    @Published var fetchedComics: [ComicModel]? = nil
    @Published var offset = 0

    var searchCancellable: Cancellable? = nil
    let publicKey = "3773b138cb195f95103cf45b0417cc95"
    let privateKey = "53313da5e0e761de4f3d5ee0f4b2bdb16834033d"

    init() {
        searchCancellable = $searchQuery
            .removeDuplicates()
            .debounce(for: 0.6, scheduler: RunLoop.main)
            .sink(receiveValue: { str in
                if str.isEmpty {
                    self.fetchedCharacter = nil
                } else {
                    self.searchCharacter()
                }
            })
    }

    // Search character
    func searchCharacter() {
        let ts = String(Date().timeIntervalSince1970)
        let hash = MD5(data: "\(ts)\(privateKey)\(publicKey)")
        let originalQuery = searchQuery.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""

        let url = "https://gateway.marvel.com:443/v1/public/characters?nameStartsWith=\(originalQuery)&ts=\(ts)&apikey=\(publicKey)&hash=\(hash)"
        print("Character URL---",url)

        let session = URLSession(configuration: .default)

        session.dataTask(with: URL(string: url)!) { data, _, error in
            if let error = error {
                print(error.localizedDescription)
                return
            }

            guard let APIData = data else {
                print("No data")
                return
            }

            do {
                let jsonObject = try JSONSerialization.jsonObject(with: APIData, options: [])
               
                let characters = try JSONDecoder().decode(APICharacterResult.self, from: APIData)

                DispatchQueue.main.async {
                    self.fetchedCharacter = characters.data.results
                }

            } catch {
                print("Error decoding JSON:", error)
            }
        }
        .resume()
    }

    // Fetch Comics
    func fetchComics() {
        let ts = String(Date().timeIntervalSince1970)
        let hash = MD5(data: "\(ts)\(privateKey)\(publicKey)")

        let url = "https://gateway.marvel.com:443/v1/public/comics?limit=20&offset=\(offset)&ts=\(ts)&apikey=\(publicKey)&hash=\(hash)"
        
        print("Comic URl------",url)

        let session = URLSession(configuration: .default)

        session.dataTask(with: URL(string: url)!) { data, _, error in
            if let error = error {
                print(error.localizedDescription)
                return
            }

            guard let APIData = data else {
                print("No data")
                return
            }

            do {
                let jsonObject = try JSONSerialization.jsonObject(with: APIData, options: [])
               

                let comics = try JSONDecoder().decode(APIComicResult.self, from: APIData)

                DispatchQueue.main.async {
                    self.fetchedComics = comics.data.results
                    
                }

            } catch {
                print("Comic Error is---", error.localizedDescription)
                print("Error decoding JSON:", error)
            }
        }
        .resume()
    }

    // Get Hash Value
    func MD5(data: String) -> String {
        let hash = Insecure.MD5.hash(data: data.data(using: .utf8) ?? Data())
        return hash.map { String(format: "%02hhx", $0) }.joined()
    }
}
