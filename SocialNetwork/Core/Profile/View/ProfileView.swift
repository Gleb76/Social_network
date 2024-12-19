
import SwiftUI

struct ProfileView: View {
    @StateObject var viewModel = ProfileViewModel()
    @State private var selectedFilter: ProfileFilter = .threads
    @Namespace var animation

    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 20) {
                HeaderView(user: viewModel.user)
                
                Button(action: {
                    // Follow action
                }) {
                    Text("Follow")
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                        .frame(width: 352, height: 32)
                        .background(.black)
                        .cornerRadius(8)
                }
                
                FilterBar(selectedFilter: $selectedFilter, animation: animation)
                
                LazyVStack {
                    ForEach(0 ... 10, id: \.self) { _ in
                        FeedCell()
                    }
                }
            }
            .padding(.horizontal)
            .onAppear {
                Task {
                    try await viewModel.loadCurrentUserProfile()
                }
            }
        }
    }
}

struct HeaderView: View {
    var user: DBUser?
    
    var body: some View {
        HStack(alignment: .top) {
            VStack(alignment: .leading, spacing: 12) {
                if let user = user {
                    VStack(alignment: .leading, spacing: 4) {
                        Text(user.displayName ?? "Don't have username")
                            .font(.title2)
                            .fontWeight(.semibold)
                        
                        Text(user.photoUrl ?? "No photo URL")
                            .font(.subheadline)
                    }
                    Text("Some information")
                        .font(.footnote)
                    
                    Text("2 followers")
                        .font(.footnote)
                        .foregroundColor(.gray)
                } else {
                    Text("Loading...")
                }
            }
            Spacer()
            CircularProfileImageView(imageUrl: user?.photoUrl)
        }
    }
}

struct FilterBar: View {
    @Binding var selectedFilter: ProfileFilter
    var animation: Namespace.ID
    
    var body: some View {
        GeometryReader { geometry in
            let filterBarWidth = geometry.size.width / CGFloat(ProfileFilter.allCases.count) - 20
            
            HStack {
                ForEach(ProfileFilter.allCases) { filter in
                    VStack {
                        Text(filter.title)
                            .font(.subheadline)
                            .fontWeight(selectedFilter == filter ? .semibold : .regular)
                        
                        if selectedFilter == filter {
                            Rectangle()
                                .foregroundColor(.black)
                                .frame(width: filterBarWidth, height: 1)
                                .matchedGeometryEffect(id: "item", in: animation)
                        } else {
                            Rectangle()
                                .foregroundColor(.clear)
                                .frame(width: filterBarWidth, height: 1)
                        }
                    }
                    .onTapGesture {
                        withAnimation(.spring()) {
                            selectedFilter = filter
                        }
                    }
                }
            }
        }
        .frame(height: 20) 
    }
}

#Preview {
    ProfileView()
}
