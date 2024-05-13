//
//  LogoView.swift
//  Cratedig
//
//  Created by Noah Boyers on 5/13/24.
//

import SwiftUI

struct LogoView: View {
    var body: some View {
        Image("CrateDig_Logo")
            .resizable()
            .frame(width: 300, height: 75)
            .shadow(color: .white, radius: 2)
            .padding(.horizontal)
    }
}

#Preview {
    LogoView()
}
