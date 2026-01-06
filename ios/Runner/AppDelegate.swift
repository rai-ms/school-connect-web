import Flutter
import UIKit
import Firebase
import FirebaseMessaging
import awesome_notifications
// import awesome_notifications_fcm

@main
@objc class AppDelegate: FlutterAppDelegate, MessagingDelegate {
    
    override func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        // Configure Firebase
        FirebaseApp.configure()
        
        // Register for remote notifications
        if #available(iOS 10.0, *) {
            // For iOS 10 display notification (sent via APNS)
            UNUserNotificationCenter.current().delegate = self
            
            let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
            UNUserNotificationCenter.current().requestAuthorization(
                options: authOptions,
                completionHandler: { _, _ in }
            )
        } else {
            let settings: UIUserNotificationSettings =
                UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            application.registerUserNotificationSettings(settings)
        }
        
        application.registerForRemoteNotifications()
        
        // Set Firebase Messaging delegate
        Messaging.messaging().delegate = self
        
        // This will handle all the automatic notifications in foreground
        if #available(iOS 10.0, *) {
            UNUserNotificationCenter.current().delegate = self
        }
        
        // Register with the Flutter app
        GeneratedPluginRegistrant.register(with: self)
        
        // Initialize Awesome Notifications
        // SwiftAwesomeNotificationsFcmPlugin.setPluginRegistrantCallback { (registry) in
        //     SwiftAwesomeNotificationsPlugin.setPluginRegistrantCallback { registry in
        //         GeneratedPluginRegistrant.register(with: registry)
        //     }
        //     SwiftAwesomeNotificationsFcmPlugin.register(with: registry.registrar(forPlugin: "io.flutter.plugins.firebase.messaging.FlutterFirebaseMessagingPlugin")!)
        // }
        
        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }
    
    // Handle notification tap when app is in background or terminated
    override func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        didReceive response: UNNotificationResponse,
        withCompletionHandler completionHandler: @escaping () -> Void
    ) {
        let userInfo = response.notification.request.content.userInfo
        
        // Print full message.
        print(userInfo)
        
        // Let Firebase handle the notification
        Messaging.messaging().appDidReceiveMessage(userInfo)
        
        completionHandler()
    }
    
    // Handle notification when app is in foreground
    @available(iOS 10.0, *)
    override func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        willPresent notification: UNNotification,
        withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void
    ) {
        let userInfo = notification.request.content.userInfo
        
        // Print full message.
        print(userInfo)
        
        // Let Firebase handle the notification
        Messaging.messaging().appDidReceiveMessage(userInfo)
        
        // Show the notification even when the app is in foreground
        completionHandler([[.banner, .sound, .badge]])
    }
    
    // Handle FCM token refresh
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        print("Firebase registration token: \(String(describing: fcmToken))")
        
        let dataDict: [String: String] = ["token": fcmToken ?? ""]
        NotificationCenter.default.post(
            name: Notification.Name("FCMToken"),
            object: nil,
            userInfo: dataDict
        )
    }
}
