//
//  AppDelegate.swift
//  FightHunger Donatur
//
//  Created by Antonius George on 25/01/19.
//  Copyright © 2019 Fantastic7. All rights reserved.
//

import UIKit
import CoreData
import Firebase
import FirebaseMessaging
import FirebaseAuth
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate {

	var window: UIWindow?
    //let gcmMessageIDKey = "gcm.message_id"

	
	func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void)
	{
		completionHandler([.alert, .badge, .sound])
	}

	func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
		// Override point for customization after application launch.
		
		if let _ = UserDefaults.standard.string(forKey: "isAppAlreadyLaunchedOnce"){
			print("Has opened app before\n\n\n\n\n")
		}else{
			UserDefaults.standard.set(true, forKey: "isAppAlreadyLaunchedOnce")
			UserDefaults.standard.set(false, forKey: "willShowReviewHasbeenShown")
			UserDefaults.standard.set(false, forKey: "willAcceptedHasbeenShown")
			
			UserDefaults.standard.set(false, forKey: "neverOpenedApp")
			
			print("Never opened app before\n\n\n\n\n")
		}
        
        DispatchQueue.main.async {
            FirebaseApp.configure()
            
            UNUserNotificationCenter.current().delegate = self
            
            //        if #available(iOS 10.0, *) {
            //            // For iOS 10 display notification (sent via APNS)
            //            UNUserNotificationCenter.current().delegate = self
            //
            //            let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
            //            UNUserNotificationCenter.current().requestAuthorization(
            //                options: authOptions,
            //                completionHandler: {_, _ in })
            //        } else {
            //            let settings: UIUserNotificationSettings =
            //                UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            //            application.registerUserNotificationSettings(settings)
            //        }
            //        Messaging.messaging().delegate = self
            //        application.registerForRemoteNotifications()
            
            
            
			_ = Auth.auth().addStateDidChangeListener { auth, user in
                //let storyboard = UIStoryboard(name: "NewHome", bundle: nil)
                
                if user != nil{
                    
                    self.loadUserProfile(id: user!.uid, completion: { (result) in
                        if result{
							
                        }else{
                            
                        }
                    })
                    
                    let pushManager = PushNotificationManager(userID: user!.uid )
                    pushManager.registerForPushNotifications()
                    
                    
                    //                let sender = PushNotificationSender()
                    //                sender.sendPushNotification(to: "token", title: "Notification title", body: "Notification body")
                    
                    
                    
                    //                let postRef = Database.database().reference().child("Post/\(user!.uid)")
                    //                postRef.observe(.childChanged, with: { (snapshot) -> Void in
                    //                    self.postLocalNotification(identifier: "data changed", title: "data changed", subtitle: "your order is changed", body: "hai", duration: 1)
                    //                    print("database is changed")
                    //                })
                    //auto login
                    //                let controller = storyboard.instantiateViewController(withIdentifier: "HomeDonatur") as! UINavigationController
                    //                self.window?.rootViewController = controller
                    //                self.window?.makeKeyAndVisible()
                    
                } else {
                    
                    UserService.currentUserProfile = nil
                    //                let controller = storyboard.instantiateViewController(withIdentifier: "HomeDonatur") as! UINavigationController
                    //                self.window?.rootViewController = controller
                    //                self.window?.makeKeyAndVisible()
                }
                
                
            }
        }
        
        //Thread.sleep(forTimeInterval: 3.0)
        return true
	}
    
    func loadUserProfile(id:String,completion: @escaping (Bool) -> Void){
        UserService.observeUserProfile(id) { userProfile,result  in
            if result{
                UserService.currentUserProfile = userProfile
                
                print(UserService.currentUserProfile?.uid ?? "")
				print(UserService.currentUserProfile?.phonenumber ?? "")
                print(UserService.currentUserProfile?.email ?? "")
                
                completion(true)
            }else{
                print("gagal load userprofile")
                completion(false)
            }
            
        }
    }
    
    
    func postLocalNotification(identifier: String, title: String, subtitle: String, body: String, duration: Double){
        let content = UNMutableNotificationContent()
        content.title = title
        content.subtitle = subtitle
        content.body = body
        content.badge = 1
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: duration, repeats: false)
        let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
        
    }

	func applicationWillResignActive(_ application: UIApplication) {
		// Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
		// Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
	}

	func applicationDidEnterBackground(_ application: UIApplication) {
		// Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
		// If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
	}

	func applicationWillEnterForeground(_ application: UIApplication) {
		// Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
	}

	func applicationDidBecomeActive(_ application: UIApplication) {
		// Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        //fetch sync data
        //masalah user profile add target trus panggil function fetch data pake completion baru segue
	}

	func applicationWillTerminate(_ application: UIApplication) {
		// Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
		// Saves changes in the application's managed object context before the application terminates.
        UserDefaults.standard.removePersistentDomain(forName: Bundle.main.bundleIdentifier!)
        UserDefaults.standard.synchronize()
		self.saveContext()
	}
    
    //tambahan push notif
//    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any]) {
//        // If you are receiving a notification message while your app is in the background,
//        // this callback will not be fired till the user taps on the notification launching the application.
//        // TODO: Handle data of notification
//
//        // With swizzling disabled you must let Messaging know about the message, for Analytics
//        // Messaging.messaging().appDidReceiveMessage(userInfo)
//
//        // Print message ID.
//        if let messageID = userInfo[gcmMessageIDKey] {
//            print("Message ID: \(messageID)")
//        }
//
//        // Print full message.
//        print(userInfo)
//    }
//
//    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any],
//                     fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
//        // If you are receiving a notification message while your app is in the background,
//        // this callback will not be fired till the user taps on the notification launching the application.
//        // TODO: Handle data of notification
//
//        // With swizzling disabled you must let Messaging know about the message, for Analytics
//        // Messaging.messaging().appDidReceiveMessage(userInfo)
//
//        // Print message ID.
//        if let messageID = userInfo[gcmMessageIDKey] {
//            print("Message ID: \(messageID)")
//        }
//
//        // Print full message.
//        print(userInfo)
//
//        completionHandler(UIBackgroundFetchResult.newData)
//    }

	// MARK: - Core Data stack

	lazy var persistentContainer: NSPersistentContainer = {
	    /*
	     The persistent container for the application. This implementation
	     creates and returns a container, having loaded the store for the
	     application to it. This property is optional since there are legitimate
	     error conditions that could cause the creation of the store to fail.
	    */
	    let container = NSPersistentContainer(name: "FightHunger_Donatur")
	    container.loadPersistentStores(completionHandler: { (storeDescription, error) in
	        if let error = error as NSError? {
	            // Replace this implementation with code to handle the error appropriately.
	            // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
	             
	            /*
	             Typical reasons for an error here include:
	             * The parent directory does not exist, cannot be created, or disallows writing.
	             * The persistent store is not accessible, due to permissions or data protection when the device is locked.
	             * The device is out of space.
	             * The store could not be migrated to the current model version.
	             Check the error message to determine what the actual problem was.
	             */
	            fatalError("Unresolved error \(error), \(error.userInfo)")
	        }
	    })
	    return container
	}()

	// MARK: - Core Data Saving support

	func saveContext () {
	    let context = persistentContainer.viewContext
	    if context.hasChanges {
	        do {
	            try context.save()
	        } catch {
	            // Replace this implementation with code to handle the error appropriately.
	            // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
	            let nserror = error as NSError
	            fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
	        }
	    }
	}

}

//@available(iOS 10, *)
//extension AppDelegate : UNUserNotificationCenterDelegate {
//
//    // Receive displayed notifications for iOS 10 devices.
//    func userNotificationCenter(_ center: UNUserNotificationCenter,
//                                willPresent notification: UNNotification,
//                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
//        let userInfo = notification.request.content.userInfo
//
//        // With swizzling disabled you must let Messaging know about the message, for Analytics
//        // Messaging.messaging().appDidReceiveMessage(userInfo)
//
//        // Print message ID.
//        if let messageID = userInfo[gcmMessageIDKey] {
//            print("Message ID: \(messageID)")
//        }
//
//        // Print full message.
//        print(userInfo)
//
//        // Change this to your preferred presentation option
//        completionHandler([.alert])
//
//    }
//
//    func userNotificationCenter(_ center: UNUserNotificationCenter,
//                                didReceive response: UNNotificationResponse,
//                                withCompletionHandler completionHandler: @escaping () -> Void) {
//        let userInfo = response.notification.request.content.userInfo
//        // Print message ID.
//        if let messageID = userInfo[gcmMessageIDKey] {
//            print("Message ID: \(messageID)")
//        }
//
//        // Print full message.
//        print(userInfo)
//
//        completionHandler()
//    }
//}
//
//extension AppDelegate: MessagingDelegate {
//    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String) {
//        print("Firebase registration token: \(fcmToken)")
//
//        let dataDict:[String: String] = ["token": fcmToken]
//        NotificationCenter.default.post(name: Notification.Name("FCMToken"), object: nil, userInfo: dataDict)
//        // TODO: If necessary send token to application server.
//        // Note: This callback is fired at each app startup and whenever a new token is generated.
//    }
//
//    func messaging(_ messaging: Messaging, didReceive remoteMessage: MessagingRemoteMessage) {
//        print("Message Data", remoteMessage.appData)
//    }
//}
