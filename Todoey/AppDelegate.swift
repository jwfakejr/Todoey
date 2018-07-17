
//
//  AppDelegate.swift
//  Todoey
//
//  Created by John Fake on 7/11/18.
//  Copyright © 2018 John Fake. All rights reserved.
//

import UIKit
import RealmSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {

       
        //print(Realm.Configuration.defaultConfiguration.fileURL)
        
       
        do {
            _ = try Realm()
           
        } catch {
            // just used to catch any errors initializing realm
            print("Error initializing or storing realm data")
        }
        
        
        
        return true
    }

    

   
   

}


