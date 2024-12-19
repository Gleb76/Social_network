
import SwiftUI

struct CircularProfileImageView: View {
    var imageUrl: String?
    
    var body: some View {
        if let imageUrl = imageUrl, let url = URL(string: imageUrl) {
            AsyncImage(url: url) { image in
                image
                    .resizable()
                    .scaledToFill()
                    .frame(width: 40, height: 40)
                    .clipShape(Circle())
            } placeholder: {
                Image("placeholder")
                    .resizable()
                    .scaledToFill()
                    .frame(width: 40, height: 40)
                    .clipShape(Circle())
            }
        } else {
            Image("placeholder")
                .resizable()
                .scaledToFill()
                .frame(width: 40, height: 40)
                .clipShape(Circle())
        }
    }
}

#Preview {
    CircularProfileImageView(imageUrl: "https://example.com/image.jpg") 
}
