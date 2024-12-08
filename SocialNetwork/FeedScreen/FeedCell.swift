import SwiftUI

struct FeedCell: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack(alignment: .top, spacing: 12) {
                CircularProfileImageView()
                VStack(alignment: .leading, spacing: 4) {
                    Text("Nastya")
                        .font(.footnote)
                        .fontWeight(.semibold)
                    
                    Text("Belarus")
                        .font(.footnote)
                        .foregroundColor(.gray)
                }
                
                Spacer()
                
                HStack {
                    Text("10m")
                        .font(.caption)
                        .foregroundColor(Color(.systemGray3))
                    
                    Button {
                        // Действие кнопки меню
                    } label: {
                        Image(systemName: "ellipsis")
                            .foregroundColor(Color(.darkGray))
                    }
                }
            }
            HStack(spacing: 20) {
                Button(action: {
                    // Лайк
                }) {
                    Image(systemName: "heart")
                        .font(.headline)
                }
                
                Button(action: {
                    // Комментарий
                }) {
                    Image(systemName: "bubble.right")
                        .font(.headline)
                }
                
                Button(action: {
                    // Репост
                }) {
                    Image(systemName: "arrow.rectanglepath")
                        .font(.headline)
                }
                
                Button(action: {
                    // Поделиться
                }) {
                    Image(systemName: "paperplane")
                        .font(.headline)
                }
            }
            .foregroundColor(Color.black)
            .padding(.top, 4)
            .padding(.bottom, 8)
            
            Divider()
        }
        .padding(.horizontal)
    }
}

#Preview {
    FeedCell()
}
