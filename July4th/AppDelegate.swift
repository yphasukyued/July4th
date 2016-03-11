import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        window = UIWindow(frame: UIScreen.mainScreen().bounds)
        window?.makeKeyAndVisible()
        
        let vc = ViewController()
        window?.rootViewController = vc
        
        UITabBar.appearance().translucent = false
        UITabBar.appearance().barTintColor = UIColor(red: 32/255, green: 32/255, blue: 64/255, alpha: 1)
        UITabBar.appearance().tintColor = UIColor(red: 0/255, green: 64/255, blue: 128/255, alpha: 1)
        
        return true
    }

    func applicationWillResignActive(application: UIApplication) {
    }

    func applicationDidEnterBackground(application: UIApplication) {
    }

    func applicationWillEnterForeground(application: UIApplication) {
    }

    func applicationDidBecomeActive(application: UIApplication) {
    }

    func applicationWillTerminate(application: UIApplication) {
    }


}

