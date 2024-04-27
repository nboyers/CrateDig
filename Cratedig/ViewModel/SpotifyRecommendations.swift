//
//  SpotifyRecommendations.swift
//  Cratedig
//
//  Created by Noah Boyers on 4/4/24.
//

import Foundation

final class SpotifyRecommendations: ObservableObject {
    
    @Published var songs: [Song] = []
    
    // Function to get song recommendations with all available parameters
    func getSongRecommendations(limit: Int? = nil,
                                market: String? = nil,
                                seedArtists: String? = nil,
                                seedGenres: String? = nil,
                                seedTracks: String? = nil,
                                targetPopularity: Int? = nil,
                                targetTempo: Float? = nil,
                                targetEnergy: Float? = nil,
                                completion: @escaping ([Song]) -> Void) {
        // Construct the URL with query parameters
        var components = URLComponents(string: "https://api.spotify.com/v1/recommendations")
        
        let queryItems: [URLQueryItem] = []
        components?.queryItems = queryItems
        
        guard let url = components?.url else {
            print("Invalid URL")
            return
        }
        
        // Create the request
        var request = URLRequest(url: url)
        request.addValue("Bearer YOUR_ACCESS_TOKEN", forHTTPHeaderField: "Authorization")
        
        // Create the URLSession task
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                print("Error fetching data: \(error?.localizedDescription ?? "Unknown error")")
                return
            }
            
            do {
                // Parse the JSON response
                if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                   let tracks = json["tracks"] as? [[String: Any]] {
                    var songs = [Song]()
                    
                    // Extract song information
                    for track in tracks {
                        if let name = track["name"] as? String,
                           let artists = track["artists"] as? [[String: Any]],
                           let artistName = artists.first?["name"] as? String,
                           let album = track["album"] as? [String: Any],
                           let albumName = album["name"] as? String,
                           let images = album["images"] as? [[String: Any]],
                           let imageUrl = images.first?["url"] as? String,
                           let uri = track["uri"] as? String,
                           let popularity = track["popularity"] as? Int {
                            let previewUrl = track["preview_url"] as? String
                            let song = Song(id: UUID(), name: name, artist: artistName, uri: uri, albumName: albumName, albumImage: imageUrl, previewUrl: previewUrl, popularity: popularity)
                            songs.append(song)
                        }
                    }
                    
                    // Update the @Published songs property
                    DispatchQueue.main.async {
                        self.songs = songs
                    }
                }
            } catch {
                print("Error parsing JSON: \(error.localizedDescription)")
            }
        }
        
        // Start the task
        task.resume()
    }
    
}
