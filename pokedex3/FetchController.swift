//
//  FetchController.swift
//  pokedex3
//
//  Created by Manolo on 16/02/24.
//

import Foundation
import CoreData

struct FetchController{
    // Creates the differents error responses
    enum NetworkError: Error {
        case badUrl, badResponse, badData
    }
    
    // Sets the value for the base URL to get the values of pokemons
    private let baseURL = URL(string: "https://pokeapi.co/api/v2/pokemon/")!
    
    // Get all the pokemons (TempPokemon) in an array. Only the first 386 pokemons using the "limit" parameter
    func fetchAllPokemon() async throws -> [TempPokemon]? {
        if havePokemon() {
            return nil
        }
        
        var allPokemon: [TempPokemon] = []
        
        // Add the parameter "limit" to the url query
        var fetchComponents = URLComponents(url: baseURL, resolvingAgainstBaseURL: true)
        fetchComponents?.queryItems = [URLQueryItem(name:"limit", value: "386")]
        
        guard let fetchURL = fetchComponents?.url else {
            throw NetworkError.badUrl
        }
        
        let (data, response) = try await URLSession.shared.data(from: fetchURL)
        
        guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
            throw  NetworkError.badResponse
        }
        
        guard let pokeDictionary = try JSONSerialization.jsonObject(with: data) as? [String: Any],
              let pokedex = pokeDictionary["results"] as? [[String:String]] else {
            throw NetworkError.badData
        }
        
        for pokemon in pokedex{
            if let url = pokemon["url"]{
                allPokemon.append(try await fetchPokemon(from: URL(string:url)!))
            }
        }
        
        return allPokemon
    }
    
    private func fetchPokemon(from url: URL) async throws -> TempPokemon {
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
            throw NetworkError.badResponse
        }
        let tempPokemon = try JSONDecoder().decode(TempPokemon.self, from: data)
        
        print("Fetched \(tempPokemon.id): \(tempPokemon.name)")
        
        return tempPokemon
    }
    
    private func havePokemon() -> Bool{
        let context = PersistenceController.shared.container.newBackgroundContext()
        
        let fetchRequest: NSFetchRequest<Pokemon> = Pokemon.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id IN %@", [1, 386])
        
        do{
            let checkPokemon = try context.fetch(fetchRequest)
            
            if checkPokemon.count == 2 {
                return true
            }
        } catch{
            print("Fetch failed: \(error)")
        }
        
        return false
    }
}
