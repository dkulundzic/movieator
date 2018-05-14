//
//  AppDelegate.swift
//  Movieator
//
//  Created by Domagoj Kulundzic on 10/05/2018.
//  Copyright © 2018 Codeopolius. All rights reserved.
//

import UIKit
import RealmSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
//        let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as String
//        let url = NSURL(fileURLWithPath: path)
//        if let pathComponent = url.appendingPathComponent("default.realm") {
//            let filePath = pathComponent.path
//            let fileManager = FileManager.default
//            if fileManager.fileExists(atPath: filePath) {
//                print("FILE AVAILABLE")
//            } else {
//                print("FILE NOT AVAILABLE")
//            }
//        } else {
//            print("FILE PATH NOT AVAILABLE")
//        }
        
        if FileManager.default.fileExists(atPath: (Realm.Configuration.defaultConfiguration.fileURL?.path)!) {
            print("Found")
            //Go to Main view
        } else {
            print("Not found!")
            //Go to Preparation view
        }
        
        application.keyWindow?.rootViewController = PreparationViewController()
        print(Realm.Configuration.defaultConfiguration.fileURL?.path)
        
        do {
            _ = try Realm()
        }
        catch  {
            print("Error initialising new realm, \(error)")
        }
        
        return true
    }


}

