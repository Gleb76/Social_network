
import SwiftUI

struct SearchBar: View {
    @Binding var searchText: String
    
    var body: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundColor(.gray)
                .padding(10)
                .font(.system(size: 16))
            
            TextField("Поиск", text: $searchText)
                .foregroundColor(.black)
                .padding(.vertical, 10)
            
            Button(action: {}) {
            }
            .foregroundColor(.blue)
            .padding(.trailing, 10)
        }
        .background(Color.gray.opacity(0.1))
        .cornerRadius(8)
        .padding(.horizontal, 30)
    }
}
