//
//  CircularProfileImageView.swift
//  SocialNetwork
//
//  Created by Глеб Клыга on 8.12.24.
//

import SwiftUI

struct CircularProfileImageView: View {
    var body: some View {
        Image("anastasia")
            .resizable()
            .scaledToFill()
            .frame(width: 40, height: 40)
            .clipShape(Circle())
    }
}

#Preview {
    CircularProfileImageView()
}
