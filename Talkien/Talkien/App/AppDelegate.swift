

import UIKit
import Firebase
import WebRTC

@UIApplicationMain
final class AppDelegate: UIResponder, UIApplicationDelegate {



    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        //init firebase here:
        FirebaseApp.configure()
        RTCInitializeSSL()

        
        //navigating here: 
        app.router.start()
        return true
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        RTCCleanupSSL() //arastir
    }

}
