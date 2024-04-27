//
//  DiscoverMusicView.swift
//  Cratedig
//
//  Created by Noah Boyers on 4/10/24.
//

import SwiftUI

struct DiscoverMusicView: View {
    @State private var selectedSegment = 0
    @State private var selectedTab = 0
    @State private var rotationDegrees = 0.0
    @State private var timer: Timer? = nil
    @State private var showOverlay = false
    @State private var popularityValue: Float = 50
    @State private var bpmValue: Float = 100
    @State private var selectedGenre = "Rock"
    @State private var isPlaying = false // State to manage play/pause
    let CRATE_COLOR = Color.init(hex: "#fbb01a")
    let CRATE_FONT = "TruenoRg"
    let segments = ["GENRE", "POPULARITY", "BPM"]
    let genres = ["Rock", "Jazz", "Hip Hop", "Electronic", "Classical"]
    
    
    
    var body: some View {
        // Navigation Bar
        VStack(spacing: 10){
            HStack {
                Spacer()
                Image("CrateDig_Logo")
                    .resizable()
                    .shadow(color: .white, radius: 2)
                Spacer()
            }
            .padding()
            
            // Segment Buttons
            HStack(spacing: 10) {
                ForEach(0..<segments.count, id: \.self) { index in
                    Button(action: {
                        // Check if the same segment is already selected and the overlay is showing
                        if self.selectedSegment == index && self.showOverlay {
                            self.showOverlay = false
                        } else {
                            self.selectedSegment = index // Set the new segment
                            self.showOverlay = true // Always show the overlay when a segment button is pressed
                        }
                    }) {
                        Text(self.segments[index])
                            .frame(minWidth: 0, maxWidth: .infinity) // Ensure each button takes up equal space
                            .font(Font.custom(CRATE_FONT, size: 15))
                            .padding(.vertical, 8)
                            .background(selectedSegment == index && showOverlay ? Color.gray : CRATE_COLOR) // Highlight the selected segment
                            .foregroundColor(.black) // Set your desired text color here
                            .cornerRadius(10)
                    }
                }
            }
            .padding()

            
            ZStack {
                // Record Image with custom spinning modifier
                Image(systemName: "waveform.circle.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 300, height: 300)
                    .padding()
                    .rotationEffect(Angle(degrees: rotationDegrees))
                if showOverlay {
                    Color.black.opacity(0.5)
                        .edgesIgnoringSafeArea(.all)
                        .onTapGesture {
                            showOverlay = false
                        }
                    
                    VStack {
                        if selectedSegment == 0 {
                            // Genre selection
                            Picker("Select Genre", selection: $selectedGenre) {
                                ForEach(genres, id: \.self) {
                                    Text($0)
                                }
                            }
                        } else if selectedSegment == 1 {
                            // Popularity slider
                            Slider(value: $popularityValue, in: 0...100, step: 1) {
                                Text("Popularity")
                                
                            }
                            .padding()
                        } else if selectedSegment == 2 {
                            // BPM slider
                            Slider(value: $bpmValue, in: 0...200, step: 1) {
                                Text("BPM")
                                    .background(CRATE_COLOR)
                                    .foregroundColor(.black)
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
                
            }
            
            
            // Song Details with Play/Pause Button
            HStack(alignment: .top) { // Use .top for alignment with the title
                // Song Details
                VStack(alignment: .leading, spacing: 4) {
                    Text("Da Funk (feat. Joni)")
                        .font(Font.custom("TruenoBlk", size: 24))
                    Text("Mochakk, Joni")
                        .font(Font.custom(CRATE_FONT, size: 18))
                    
                    Text("Single")
                        .font(Font.custom(CRATE_FONT, size: 18))
                    Text("July 2022")
                        .font(Font.custom(CRATE_FONT, size: 18))
                }
    
                Spacer() // This pushes the play button to the right
                
                // Play/Pause Button
                Button(action: {
                    self.showOverlay = false
                    self.isPlaying.toggle()
                    if self.isPlaying {
                        
                        // Start the timer to update the rotation degree
                        self.timer = Timer.scheduledTimer(withTimeInterval: 0.03, repeats: true) { _ in
                            self.rotationDegrees = (self.rotationDegrees + 1).truncatingRemainder(dividingBy: 360)
                        }
                    } else {
                        // Invalidate and stop the timer
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
                .padding(.horizontal)
            
            Spacer()
        }
    }
}

#Preview {
    DiscoverMusicView()
}
