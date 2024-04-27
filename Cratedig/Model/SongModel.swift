//
//  SongModel.swift
//  Cratedig
//
//  Created by Noah Boyers on 4/4/24.
//

import Foundation

// Define a struct to hold the song information
struct Song : Identifiable {
    var id: UUID
    let name: String
    let artist: String
    let uri: String
    let albumName: String
    let albumImage: String
    let previewUrl: String?
    let popularity: Int
}
