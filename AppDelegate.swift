//
//  AppDelegate.swift
//  Doc99
//
//  Created by Pritesh Pethani on 30/03/17.
//  Copyright © 2017 Pritesh Pethani. All rights reserved.
//

import UIKit
import SVProgressHUD
import Fabric
import Crashlytics


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate,CLLocationManagerDelegate {

    var window: UIWindow?
    var navigationC: UINavigationController?
//    var loginVC:LoginVC!
    var welcomeVC:WelcomeVC!
    var homeVC:TabBarVC!

    var menuVC:MVYMenuViewController?
    var sideMenuController:MVYSideMenuController?
    var myTabBarController :UITabBarController?
    var bundle:Bundle!

    // **** FOR LOCATION PROPERTY ****
    var GLOBAL_latitude :String!
    var GLOBAL_longtitude :String!
    var GLOBAL_ADDRESS :String?
    var venderLatitude :String?
    var venderLongtitude :String?
    var locationAction :String?
    var locationmanager :CLLocationManager?
    //var locationUpdateTimer :Timer?
    
    var prescriptionData = NSMutableDictionary()
    var healthIndexData = NSMutableDictionary()
    var weightReductionData = NSMutableDictionary()


    var deviceTokenForPushNotification :String?
    var badgeNumber:String?

    
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        Fabric.with([Crashlytics.self])

        
        SVProgressHUD.setDefaultMaskType(.black)
        SVProgressHUD.setForegroundColor(UIColor.white)
        SVProgressHUD.setBackgroundColor(UIColor.black)
        
        self.window = UIWindow(frame: UIScreen.main.bounds)

        if USERDEFAULT.value(forKey: "token") != nil{
            homeVC = TabBarVC(nibName: "TabBarVC", bundle: nil)
            homeVC.selectedIndexOfMyTabbarController = 0
            self.navigationC  = UINavigationController(rootViewController: homeVC!)
            
//            let  weightReductionVC = WeightReductionVC(nibName: "WeightReductionVC", bundle: nil)
//            self.navigationC  = UINavigationController(rootViewController: weightReductionVC)

        }
        else{
//            loginVC = LoginVC(nibName: "LoginVC", bundle: nil)
//            self.navigationC  = UINavigationController(rootViewController: loginVC!)
            
            welcomeVC = WelcomeVC(nibName: "WelcomeVC", bundle: nil)
            self.navigationC  = UINavigationController(rootViewController: welcomeVC!)
        }
        

        self.window?.rootViewController = navigationC
        self.navigationC!.setNavigationBarHidden(true, animated: true)
        self.window?.backgroundColor = UIColor.white
        self.window?.makeKeyAndVisible()
        
     //   UIApplication.shared.statusBarStyle = .lightContent

        if application.responds(to: #selector(application.registerUserNotificationSettings(_:))){
            
            if #available(iOS 8.0, *){
                let settings:UIUserNotificationSettings = UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
                application.registerUserNotificationSettings(settings)
                
            }
            else{
                
                let settings = UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
                application.registerUserNotificationSettings(settings)
                
            }
            
            
        }

        
        //TODO: - Enter your credentials
        PayPalMobile .initializeWithClientIds(forEnvironments: [PayPalEnvironmentProduction: "Af3k5QDDYI2ig_U7N-gFzSx3z6ucpKMEsMDRBgrsoGHClUCYPlW3gCCfxtRCuoSlO8qFk_y3einId-gc",
                                                                PayPalEnvironmentSandbox: "AYrzEQhOgzl7q-AEdpD4FcdmU-tqgP0tLAebtAwNn6t2Daw8wEmKZzuFEmr9-yWAvOfLHoJ8iKd6BPqe"])
       // EHrQIua1Fa5zZRItWXWSRHaFwwyYr1LHV5cKJSRy25K9jvmGMXlZ4ZZfFWCF3iCvuy2eWjtMGjtZhQvK
        
       //Meet Account //AfhvC8qtR9nCGLxj_HyokNuEo6GldPh_p0jpfHQIoVhQ3BrDq9Lexzdy5W9EYg8ijvN5K-hcOwh3zcuz
        
        self.setLanguage(languageCode: "zh-Hant")
        self.settingCurrentLocation()

        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        
     //   self.Location(Result: false)

        USERDEFAULT.set(true, forKey: "isbackgroundMode")
        USERDEFAULT.synchronize()

        
        
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        USERDEFAULT.set(false, forKey: "isbackgroundMode")
        USERDEFAULT.synchronize()

        FBSDKAppEvents.activateApp()
       // self.Location(Result: true)


    }
    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool{
        
        print(url)
        
        //        return FBSDKApplicationDelegate.sharedInstance().application(application, open: url, sourceApplication: sourceApplication, annotation: annotation)
        
        if FBSDKApplicationDelegate.sharedInstance().application(application, open: url, sourceApplication: sourceApplication, annotation: annotation)
        {
            return true
        }
        
        return true
    }

    

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
         self.Location(Result: false)

    }
    
    // TODO: - DELEGATE METHODS
    
    //NOTIFICATION
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        
        var token: String = ""
        for i in 0..<deviceToken.count {
            token += String(format: "%02.2hhx", deviceToken[i] as CVarArg)
        }
        
        print("Device Token : ", token)
        
        if token.characters.count > 0 {
            APPDELEGATE.deviceTokenForPushNotification = token
        }
        else{
            APPDELEGATE.deviceTokenForPushNotification = "123456789iOS"
        }
    }
    
    
    func application(_ application: UIApplication, didRegister notificationSettings: UIUserNotificationSettings) {
        application.registerForRemoteNotifications()
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("Error Is :-> \(error))")
    }
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any]) {
        
        //        let alert:UIAlertView = UIAlertView(title: "Notification", message: "\(userInfo)", delegate: nil, cancelButtonTitle: "OK", otherButtonTitles: "CANCEL")
        //        alert.show()
        print("userinfo in notification :-> \(userInfo)")
        
        if let aps = userInfo["aps"] as? NSDictionary {
            if let alert = aps["alert"] as? String {
                print(alert)
            }
        }
        
        let isbackground:Bool = USERDEFAULT.value(forKey: "isbackgroundMode") as! Bool
        print("Background Mode",isbackground)
        
        if isbackground == true{
            
            if USERDEFAULT.value(forKey: "userID") != nil{
                let notificationVC = NotificationVC(nibName: "NotificationVC", bundle: nil)
                self.navigationC?.pushViewController(notificationVC, animated: true)
               // self.menuSettingMethod()
                
                self.notificationBadgeCount()
                
                
            }
            else{
                
                let loginVC = LoginVC(nibName: "LoginVC", bundle: nil)
                self.navigationC?.pushViewController(loginVC, animated: true)
                
            }
            USERDEFAULT.setValue(false, forKey: "isbackgroundMode")
            USERDEFAULT.synchronize()
            
        }
        else{
            let title = (userInfo["aps"] as? NSDictionary)?.value(forKey: "alert") as! String
            
            
            TWMessageBarManager.sharedInstance().showMessage(withTitle: title, description: "", type: .success, duration: 3.0, callback: {
                
                if USERDEFAULT.value(forKey: "userID") != nil{
                    
                    let notificationVC = NotificationVC(nibName: "NotificationVC", bundle: nil)
                    self.navigationC?.pushViewController(notificationVC, animated: true)
                  //  self.menuSettingMethod()
                    
                    self.notificationBadgeCount()
                }
                else{
                    
                    let loginVC = LoginVC(nibName: "LoginVC", bundle: nil)
                    self.navigationC?.pushViewController(loginVC, animated: true)
                    
                }
                
            })
        }
        
        
        
        let applicationState: UIApplicationState = UIApplication.shared.applicationState
        print("Application State",applicationState)
        
        
    }
    
    func receiveTestNotification(notification:NSNotification){
        
    }
    
    
    
    // LOCATION
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("didFailWithError \(error)")
        
    }
    
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        let longtitude:String = "\((manager.location?.coordinate.longitude)!)"
        GLOBAL_longtitude = longtitude
        
        let latitude:String = "\((manager.location?.coordinate.latitude)!)"
        GLOBAL_latitude = latitude
        
        USERDEFAULT.set(GLOBAL_latitude, forKey: "currentLatitude")
        USERDEFAULT.synchronize()
        
        USERDEFAULT.set(GLOBAL_longtitude, forKey: "currentLongtitude")
        USERDEFAULT.synchronize()
        
        
        print("didUpdateLocations \(GLOBAL_longtitude!)")
        print("didUpdateLocations \(GLOBAL_latitude!)")
        
        self.updateLocation()
        
        //        Print("GLOBAL LATITUDE ::::>>>>> %@"GLOBAL_latitude);
        //        Print("GLOBAL LONGTITUDE ::::>>>>> %@",GLOBAL_longtitude);
        
    }
    
    
    func settingCurrentLocation(){
        
        GLOBAL_longtitude = "0.000000"
        GLOBAL_latitude = "0.000000"
        
        self.locationmanager = CLLocationManager.init()
        self.locationmanager?.delegate = self
        
        
        if #available(iOS 8.0, *){
            
            let code = CLLocationManager.authorizationStatus()
            
            //   if code == .notDetermined && self.responds(to: #selector(self.locationmanager?.requestAlwaysAuthorization)) || (self.locationmanager?.responds(to: #selector(self.locationmanager?.requestWhenInUseAuthorization)))!{
            
            //                if (Bundle.main.object(forInfoDictionaryKey: "NSLocationAlwaysUsageDescription") != nil){
            //                    self.locationmanager?.requestAlwaysAuthorization()
            //                }
            //                else if (Bundle.main.object(forInfoDictionaryKey: "NSLocationWhenInUseUsageDescription") != nil){
            //
            //                }
            //                else{
            //                    print("Info.plist does not contain NSLocationAlwaysUsageDescription or NSLocationWhenInUseUsageDescription")
            //                }
            
            if CLLocationManager.authorizationStatus() == .notDetermined {
                self.locationmanager?.requestAlwaysAuthorization()
            }
            
            if CLLocationManager.authorizationStatus() == .notDetermined {
                self.locationmanager?.requestWhenInUseAuthorization()
            }
            
            
            // }
            //    if([self.locationmanager respondsToSelector:@selector(allowsBackgroundLocationUpdates)]){
            //        [self.locationmanager setAllowsBackgroundLocationUpdates:YES];
            //    }
            
            self.Location(Result: true)
            
          //  let time =  150.0
            //  self.updateLocation()
          //  self.locationUpdateTimer = Timer.scheduledTimer(timeInterval: time, target: self, selector: #selector(self.updateLocation), userInfo: nil, repeats: true)
        }
        
    }
    
    func updateLocation(){
        
        print("UpdateLocations with 15 Seconds of time interval")
        
        if GLOBAL_latitude == "0.000000" && GLOBAL_longtitude == "0.000000"{
        }
        else{
            
            print("GLOBAL_latitude :-> \(GLOBAL_latitude!)")
            print("GLOBAL_longtitude :-> \(GLOBAL_longtitude!)")
        }
        
        
    }
    
    func Location(Result:Bool) {
        if (Result == true) {
            self.locationmanager?.startUpdatingLocation()
            print("Location Update Start")
        }else
        {
            self.locationmanager?.stopUpdatingLocation()
            print("Location Update Stop")
        }
    }
    
    func checkApplicationHasLocationServicesPermission() -> String  {
        
        if CLLocationManager.locationServicesEnabled(){
            print("Location Services Enabled")
            
            if CLLocationManager.authorizationStatus() == .denied {
                return "To re-enable, please go to Settings and turn on Location Service for this app."
            }
            else{
                return ""
            }
        }
        else{
            return "Location Services' need to be on"
        }
        //return ""
    }
    
    
    
    
    func menuSettingMethod(){
        
        menuVC = MVYMenuViewController(nibName: "MVYMenuViewController", bundle: nil)
        let options:MVYSideMenuOptions  = MVYSideMenuOptions()
        options.contentViewScale = 1.0
        options.contentViewOpacity = 0.05
        options.shadowOpacity = 0.0
        
        sideMenuController = MVYSideMenuController(menuViewController: menuVC, contentViewController: navigationC, options: options)
        self.sideMenuController?.menuFrame = CGRect(x: 0, y: 0.0, width: 250.0, height: self.window!.bounds.size.height)
        window?.rootViewController = self.sideMenuController
    }
    
    
    func logOutUser(){
        if Reachability.isConnectedToNetwork() == true {
            self.performSelector(inBackground: #selector(self.postDataOnWebserviceForLogout), with: nil);
        } else {
//            showAlert(CheckConnection, title: InternetError)
            
            UIApplication.shared.applicationIconBadgeNumber = 0

            
            USERDEFAULT.removeObject(forKey: "userID")
            USERDEFAULT.synchronize()
            
            USERDEFAULT.removeObject(forKey: "token")
            USERDEFAULT.synchronize()
            
            USERDEFAULT.removeObject(forKey: "emailID")
            USERDEFAULT.synchronize()
            
            USERDEFAULT.removeObject(forKey: "fullName")
            USERDEFAULT.synchronize()
            
//            self.Location(Result: false)
//            self.locationUpdateTimer?.invalidate()

        }
    }
    
    func logOutUserWithoutToken(){
        
        UIApplication.shared.applicationIconBadgeNumber = 0

        
        USERDEFAULT.removeObject(forKey: "userID")
        USERDEFAULT.synchronize()
        
        USERDEFAULT.removeObject(forKey: "token")
        USERDEFAULT.synchronize()
        
        USERDEFAULT.removeObject(forKey: "emailID")
        USERDEFAULT.synchronize()
        
        USERDEFAULT.removeObject(forKey: "fullName")
        USERDEFAULT.synchronize()

    }
    
    func notificationBadgeCount(){
        
        if Reachability.isConnectedToNetwork() == true {
            self.performSelector(inBackground: #selector(self.postDataOnWebserviceForUNReadNotificationCount), with: nil)
        } else {
        }
    }
    
    
    
    // TODO: - POST DATA METHODS
    func postDataOnWebserviceForLogout(){
        let completeURL = NSString(format:"%@%@", MainURL,logoutURL) as String
        
        let params:NSDictionary = [
            "user_id" : USERDEFAULT.value(forKey: "userID") as! String,
            "token" : USERDEFAULT.value(forKey: "token") as! String,
            "lang_type":Language_Type
        ]
        
        let finalParams:NSDictionary = [
            "data" : params
        ]
        
        print("Logout API Parameter :",finalParams)
        print("Logout API URL :",completeURL)
        
        let sampleProtocol = SyncManager()
        sampleProtocol.delegate = self
        sampleProtocol.webServiceCall(completeURL, withParams: finalParams as! [AnyHashable : Any], withTag: logoutURLTag)
        
    }
    
    func postDataOnWebserviceForUNReadNotificationCount(){
        let completeURL = NSString(format:"%@%@", MainURL,unReadCountNotificationURL) as String
        
        let params:NSDictionary = [
            "user_id" : USERDEFAULT.value(forKey: "userID") as! String,
            "token" : USERDEFAULT.value(forKey: "token") as! String,
            "lang_type":Language_Type
        ]
        
        let finalParams:NSDictionary = [
            "data" : params
        ]
        
        print("Logout API Parameter :",finalParams)
        print("Logout API URL :",completeURL)
        
        let sampleProtocol = SyncManager()
        sampleProtocol.delegate = self
        sampleProtocol.webServiceCall(completeURL, withParams: finalParams as! [AnyHashable : Any], withTag: unReadCountNotificationURLTag)
        
    }

    
    
    func syncSuccess(_ responseObject: Any!, withTag tag: Int) {
        switch tag {
        case logoutURLTag:
            let resultDict = responseObject as! NSDictionary;
            print("Logout Response  : \(resultDict)")

            if resultDict.value(forKey: "status") as! String == "1"{
                
                UIApplication.shared.applicationIconBadgeNumber = 0

                
                USERDEFAULT.removeObject(forKey: "userID")
                USERDEFAULT.synchronize()
                
                USERDEFAULT.removeObject(forKey: "token")
                USERDEFAULT.synchronize()
                
                USERDEFAULT.removeObject(forKey: "emailID")
                USERDEFAULT.synchronize()
                
                USERDEFAULT.removeObject(forKey: "fullName")
                USERDEFAULT.synchronize()
                
            }
            else if resultDict.value(forKey: "status") as! String == "0"{
                showAlert(NSLocalizedString(Appname, tableName: nil, bundle: APPDELEGATE.bundle, value: "", comment: ""), title: resultDict.value(forKey: "message") as! String)
            }
            break
            
        case unReadCountNotificationURLTag:
            let resultDict = responseObject as! NSDictionary;
            print("Logout Response  : \(resultDict)")
            
            if resultDict.value(forKey: "status") as! String == "1"{
                
                if let notificationCount = resultDict.value(forKey: "totalunread") as? NSNumber{
                    let notCount = "\(notificationCount)"
                    
                    APPDELEGATE.badgeNumber = notCount
                    UIApplication.shared.applicationIconBadgeNumber = Int(notCount)!
                    
                    
//                    // Define identifier
//                    let notificationName = Notification.Name("refreshingNotificationCount")
//                    // Post notification
//                    // NotificationCenter.default.post(name: notificationName, object: nil)
//                    NotificationCenter.default.post(name: notificationName, object: notCount, userInfo: nil)
                    
                    
                    print("Notification Unread Count :->", notCount)
                    
                }
                
            }
            break

            
            
        default:
            break
            
        }
        
    }
    func syncFailure(_ error: Error!, withTag tag: Int) {
        switch tag {
        case logoutURLTag:
            break
        case unReadCountNotificationURLTag:
            break
            
        default:
            break
            
        }
        print("syncFailure Error : ",error.localizedDescription)
        showAlert(NSLocalizedString(Appname, tableName: nil, bundle: APPDELEGATE.bundle, value: "", comment: ""), title: NSLocalizedString(FailureAlert, tableName: nil, bundle: APPDELEGATE.bundle, value: "", comment: ""))
    }
    
    
    
    // TODO: - Localization METHODS
    func setLanguage(languageCode:String){
        
        //    English - en
        //    chinese traditional language code :  zh-Hant
        //    japanese language code - ja
        
        //        let languageCode = "ja"
        let bundlePath:NSString = Bundle.main.path(forResource: "Localizable", ofType: "strings", inDirectory: nil, forLocalization: languageCode)! as NSString
                APPDELEGATE.bundle = Bundle.init(path: bundlePath.deletingLastPathComponent)
                //APPDELEGATE.bundle = Bundle.init(path: bundlePath.stringByDeletingLastPathComponent)
        
        //   APPDELEGATE.bundle = Bundle.main
        //        NSLocalizedString("login", tableName: nil, bundle: APPDELEGATE.bundle, value: "", comment: "")
        print(NSLocalizedString("name", comment: ""))
        print("Localization :: ",NSLocalizedString("name", tableName: nil, bundle: APPDELEGATE.bundle, value: "", comment: ""))
    }

    
    

}

