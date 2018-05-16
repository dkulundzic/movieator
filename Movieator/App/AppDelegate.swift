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
        let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!.appendingPathComponent("Movies.realm").path
        let isDatabaseInitialised = FileManager.default.fileExists(atPath: (documentsURL))
        let rootViewController = isDatabaseInitialised ?
            UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MovieListViewController") :
            UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "PreparationViewController")
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = UINavigationController(rootViewController: rootViewController)
        window?.makeKeyAndVisible()
        
        return true
    }


}

