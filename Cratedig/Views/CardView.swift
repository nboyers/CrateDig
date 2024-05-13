//
//  CardView.swift
//  Cratedig
//
//  Created by Noah Boyers on 5/13/24.
//

import SwiftUI

struct CardView<Content: View>: View {
    let content: Content
    let onSwipeLeft: () -> Void
    let onSwipeRight: () -> Void
    @State private var offset = CGSize.zero
    @State private var isSwiping = false

    var body: some View {
        content
            .frame(width: 300, height: 400)
            .background(Color.white)
            .cornerRadius(12)
            .shadow(radius: 10)
            .padding()
            .offset(offset)
            .gesture(
                DragGesture()
                    .onChanged { value in
                        guard !isSwiping else { return }
                        self.offset = value.translation
                    }
                    .onEnded { value in
                        guard !isSwiping else { return }
                        if value.translation.width < -50 {
                            isSwiping = true
                            withAnimation(.spring()) {
                                self.offset = CGSize(width: -600, height: 0)
                            }
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                                self.onSwipeLeft()
                                self.offset = .zero
                                isSwiping = false
                            }
                        } else if value.translation.width > 50 {
                            isSwiping = true
                            withAnimation(.spring()) {
                                self.offset = CGSize(width: 600, height: 0)
                            }
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                                self.onSwipeRight()
                                self.offset = .zero
                                isSwiping = false
                            }
                        } else {
                            withAnimation(.spring()) {
                                self.offset = .zero
                            }
                        }
                    }
            )
    }
}

#Preview {
    CardView(
           content: VStack {
               Image(systemName: "waveform.circle.fill")
                   .resizable()
                   .scaledToFit()
               
               Text("Song Title")
                   .font(.headline)
               
               Text("Artist Name")
                   .font(.subheadline)
               
               Text("Album Name")
                   .font(.subheadline)
               
               Text("Release Date")
                   .font(.subheadline)
           },
           onSwipeLeft: {
               // Handle swipe left
           },
           onSwipeRight: {
               // Handle swipe right
           }
       )
       .padding()
       .previewLayout(.device)
}

