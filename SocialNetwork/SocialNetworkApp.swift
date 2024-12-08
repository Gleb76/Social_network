import SwiftUI
import FirebaseCore

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        FirebaseApp.configure()
        return true
    }
}

@main
struct SocialNetworkApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    @ObservedObject var monitor = NetworkMonitor()
    @StateObject var viewModel = SignInEmailViewModel()
    
    var body: some Scene {
        WindowGroup {
            SignInPageView(viewModel: viewModel)
                .environmentObject(monitor)
        }
    }
}
