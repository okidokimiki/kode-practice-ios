import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.makeKeyAndVisible()
        configureWindow()
        
        return true
    }
}

// MARK: - Private Methods

private extension AppDelegate {
    
    func configureWindow() {
        let rootViewController = ViewController()
        
        window?.rootViewController = UINavigationController(rootViewController: rootViewController)
        window?.overrideUserInterfaceStyle = .light
    }
}
