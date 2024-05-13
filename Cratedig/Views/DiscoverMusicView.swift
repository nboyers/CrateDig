//
//  DiscoverMusicView.swift
//  Cratedig
//
//  Created by Noah Boyers on 4/10/24.
//

import SwiftUI

struct DiscoverMusicView: View {
    @State private var selectedSegment = 0
    @State private var rotationDegrees = 0.0
    @State private var timer: Timer? = nil
    @State private var showOverlay = false
    @State private var popularityValue: Float = 50
    @State private var bpmValue: Float = 100
    @State private var selectedGenre = "Rock"
    @State private var isPlaying = false
    @State private var currentIndex = 0
    
    let CRATE_COLOR = Color(hex: "#fbb01a")
    let CRATE_FONT = "TruenoRg"
    let segments = ["GENRE", "POPULARITY", "BPM"]
    let genres = ["Rock", "Jazz", "Hip Hop", "Electronic", "Classical"]
    
    let songDetails = [
        ("Da Funk (feat. Joni)", "Mochakk, Joni", "Single", "July 2022"),
        ("Song Title 2", "Artist Name 2", "Album Name 2", "Release Date 2"),
        ("Song Title 3", "Artist Name 3", "Album Name 3", "Release Date 3")
    ]
    
    var body: some View {
        VStack(spacing: 10) {
            LogoView()

            HStack(spacing: 10) {
                ForEach(0..<segments.count, id: \.self) { index in
                    Button(action: {
                        if self.selectedSegment == index && self.showOverlay {
                            self.showOverlay = false
                        } else {
                            self.selectedSegment = index
                            self.showOverlay = true
                        }
                    }) {
                        Text(self.segments[index])
                            .frame(minWidth: 0, maxWidth: .infinity)
                            .font(Font.custom(CRATE_FONT, size: 15))
                            .padding(.vertical, 8)
                            .background(selectedSegment == index && showOverlay ? Color.gray : CRATE_COLOR)
                            .foregroundColor(.black)
                            .cornerRadius(10)
                    }
                }
            }
            .padding()
            
            if currentIndex < songDetails.count {
                CardView(
                    content: ZStack {
                        VStack {
                            Image(systemName: "waveform.circle.fill")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 300, height: 200)
                                .padding()
                                .rotationEffect(Angle(degrees: rotationDegrees))
                            
                            Spacer()
                            
                            HStack(alignment: .top) {
                                VStack(alignment: .leading, spacing: 4) {
                                    Text(songDetails[currentIndex].0)
                                        .font(Font.custom("TruenoBlk", size: 24))
                                    Text(songDetails[currentIndex].1)
                                        .font(Font.custom(CRATE_FONT, size: 18))
                                    Text(songDetails[currentIndex].2)
                                        .font(Font.custom(CRATE_FONT, size: 18))
                                    Text(songDetails[currentIndex].3)
                                        .font(Font.custom(CRATE_FONT, size: 18))
                                }
                                
                                Spacer()
                                    .frame(width: 50)
                                Button(action: {
                                    self.showOverlay = false
                                    self.isPlaying.toggle()
                                    if self.isPlaying {
                                        self.timer = Timer.scheduledTimer(withTimeInterval: 0.03, repeats: true) { _ in
                                            self.rotationDegrees = (self.rotationDegrees + 1).truncatingRemainder(dividingBy: 360)
                                        }
                                    } else {
                                        self.timer?.invalidate()
                                        self.timer = nil
                                    }
                                }) {
                                    Image(systemName: isPlaying ? "pause.circle.fill" : "play.circle.fill")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 50, height: 50)
                                }
                                .accentColor(CRATE_COLOR)
                                .padding(.trailing)
                            }
                            .padding(.horizontal)
                            
                            Spacer()
                        }
                        
                        if showOverlay {
                            Color.black.opacity(0.5)
                                .edgesIgnoringSafeArea(.all)
                                .onTapGesture {
                                    showOverlay = false
                                }
                            
                            VStack {
                                if selectedSegment == 0 {
                                    Picker("Select Genre", selection: $selectedGenre) {
                                        ForEach(genres, id: \.self) {
                                            Text($0)
                                        }
                                    }
                                } else if selectedSegment == 1 {
                                    Slider(value: $popularityValue, in: 0...100, step: 1) {
                                        Text("Popularity")
                                    }
                                    .padding()
                                } else if selectedSegment == 2 {
                                    Slider(value: $bpmValue, in: 0...200, step: 1) {
                                        Text("BPM")
                                    }
                                    .padding()
                                }
                            }
                            .frame(width: 300, height: 200)
                            .background(CRATE_COLOR)
                            .cornerRadius(12)
                            .shadow(radius: 10)
                            
                            Spacer()
                        }
                    },
                    onSwipeLeft: {
                        if currentIndex < songDetails.count {
                            currentIndex += 1
                        }
                    },
                    onSwipeRight: {
                        if currentIndex > 0 {
                            currentIndex -= 1
                        }
                    }
                )
            } else {
                Text("No more recommendations, come back later.")
                    .font(.headline)
                    .padding()
            }
            
            Spacer()
                .padding(.horizontal)
            
            Spacer()
        }
    }
}

#Preview {
    DiscoverMusicView()
}
