//
//  ContentView.swift
//  Cratedig
//
//  Created by Noah Boyers on 4/4/24.
//

import SwiftUI

struct ContentView: View {
    
    var body: some View {
        TabView {
   DiscoverMusicView()
                .tabItem {
                    Label("Discover", systemImage: "pause.circle.fill")
                }
            AccountView()
                .tabItem {
                    Label("Favorites", systemImage: "heart.fill")
                }
            AccountView()
                .tabItem {
                    Label("Rewind", systemImage: "repeat")
                }
            AccountView()
                .tabItem {
                    Label("Acount", systemImage: "person.fill")
                }
        }
    }
}



#Preview {
    ContentView()
}
