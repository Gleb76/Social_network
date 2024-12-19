import SwiftUI

struct RootView: View {
    @State private var showSignInPageView: Bool = false
    var body: some View {
        
        ZStack {
            NavigationStack {
//                SettingsView(viewModel: nil, userData: nil, showSignInView: $showSignInPageView)
            }
        }
        .onAppear {
            let authUser = try? AuthenticationManager.shared.getAuthenticatedUser()
            self.showSignInPageView = authUser == nil
        }
        .fullScreenCover(isPresented: $showSignInPageView) {
            NavigationStack {
//                SignInPageView(showSignInView: $showSignInPageView)
            }
        }
    }
}

#Preview {
    RootView()
}
