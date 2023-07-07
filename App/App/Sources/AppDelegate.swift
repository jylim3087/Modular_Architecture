import UIKit
import Share

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil
    ) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        let viewController = SplashViewController()
        viewController.view.backgroundColor = .pink501
        window?.rootViewController = viewController
        window?.makeKeyAndVisible()

        let t = DoubleTextInputView { config in
            config.title = "Test"
        }
        
        return true
    }

}
