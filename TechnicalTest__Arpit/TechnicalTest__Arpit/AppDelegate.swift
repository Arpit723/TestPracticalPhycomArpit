//
//  AppDelegate.swift
//  TechnicalTest__Arpit
//
//  Created by Ravi Chokshi on 27/04/24.
//

import UIKit
//import ProggressHUD
import FirebaseCore
import UserNotifications
import FirebaseAuth
import CoreLocation

protocol LocationUpdateDelegate {
    func locationUpdated()
}

let appDelegate = UIApplication.shared.delegate as? AppDelegate ?? AppDelegate()

@main
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate {


    var window: UIWindow?
    
    var locationManager: CLLocationManager?
    var currentLocation: CLLocation?
    var locationUpdateDelegate: LocationUpdateDelegate?
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        setUpPushNotification()
        FirebaseApp.configure()
        setUpLocationManager()
        
        let isUserLoggedIn =  UserDefaults.standard.bool(forKey: UserDefaultKeys.isUserLoggedIn.rawValue)
        if isUserLoggedIn {
            let tabBarController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "TabBarController") as! UITabBarController
            window = UIWindow()
            window?.rootViewController = tabBarController
            window?.makeKeyAndVisible()
        }
        return true
    }

//    func setUpProgressHUD() {
//        ProgressHUD.animationType = .circleStrokeSpin
//
//    }
    func setUpPushNotification() {
        
        if #available(iOS 10.0, *) {
                    // For iOS 10 display notification (sent via APNS)
                    UNUserNotificationCenter.current().delegate = self
                    let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
                    UNUserNotificationCenter.current().requestAuthorization(
                        options: authOptions,
                        completionHandler: {_, _ in })
                } else {
                    let settings: UIUserNotificationSettings =
                        UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
                    UIApplication.shared.registerUserNotificationSettings(settings)
                }

        UIApplication.shared.registerForRemoteNotifications()
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        // Pass device token to auth.
        let firebaseAuth = Auth.auth()

        //At development time we use .sandbox
        firebaseAuth.setAPNSToken(deviceToken, type: AuthAPNSTokenType.sandbox)

        //At time of production it will be set to .prod
    }

    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        let firebaseAuth = Auth.auth()

        if (firebaseAuth.canHandleNotification(userInfo)){
            print(userInfo)
            return
        }
    }

}

