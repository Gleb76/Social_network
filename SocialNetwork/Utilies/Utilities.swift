
import UIKit

final class Utilities {
    static let shared = Utilities()
    private init() {}

    @MainActor
    func topViewController(controller: UIViewController? = nil) -> UIViewController? {
        let controller = controller ?? UIApplication.shared
            .connectedScenes
            .compactMap { $0 as? UIWindowScene }
            .first?
            .windows
            .first { $0.isKeyWindow }?
            .rootViewController
        
        guard let viewController = controller else { return nil }
        
        if let navigationController = viewController as? UINavigationController {
            return topViewController(controller: navigationController.viewControllers.last)
        }
        if let tabBarController = viewController as? UITabBarController {
            if let selectedViewController = tabBarController.selectedViewController {
                return topViewController(controller: selectedViewController)
            }
        }
        if let presentedViewController = viewController.presentedViewController {
            return topViewController(controller: presentedViewController)
        }
        return viewController
    }
}
