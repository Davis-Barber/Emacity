//
//  AppDelegate.swift
//  Emacity
//
//  Created by Davis Barber on 8/08/2017.
//  Copyright © 2017 Davis Barber. All rights reserved.
//

import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    private func loadStartingCategories() {
        let categories = ["Food", "Other", "Groceries", "Transport", "Drinks",
                        "Entertainment", "Fuel", "Clothing", "Education", "Pet",
                        "Health", "Sport", "Hobby", "Beauty", "Home"]
        let foodSubCats = ["Restaurant", "Takeaway", "Uber-Eats", "Fast Food", "Snacks"]
        let otherSubCats = ["Other"]
        let groceriesSubCats = ["General", "Fruit & Veg", "Butcher", "Bakery", "Dairy"]
        let transportSubCats = ["Bus", "Car", "Uber", "Plane", "Train", "Taxi", "Other"]
        let drinksSubCats = ["Beer & Cider", "Soft", "Spirits",  "Whisky", "Wine", "Other"]
        let entertainmentSubCats = ["Cinema", "Music", "Sports", "Technology", "Video Games", "Other"]
        let fuelSubCats = ["Primary", "Secondary", "Boat/Jetski", "Other"]
        let clothingSubCats = ["Dress", "Formal", "Jacket", "Jumper", "Pants", "Top", "Shorts", "Skirt", "Shoes", "Work",  "Underwear"]
        let educationSubCats = ["Books", "Stationary", "Fees"]
        let petSubCats = ["Food", "Toys", "Medical", "Grooming", "Other"]
        let healthSubCats = ["GP", "Dentist", "Physio", "Medicine", "Scans",
                             "Surgery", "Specialist", "Other"]
        let sportSubCats = ["Fees", "Clothing", "Equipment"]
        let hobbySubCats = ["Fishing", "Music", "Collections", "Art", "Gaming", "Camping"]
        let beautySubCats = ["Makeup", "Hair", "Body", "Tattoo"]
        let homeSubCats = ["Furniture", "Decor", "Technology", "Maintenance", "Renovations", "Appliances"]
        
        let subCategories = [foodSubCats, otherSubCats, groceriesSubCats, transportSubCats, drinksSubCats, entertainmentSubCats, fuelSubCats, clothingSubCats, educationSubCats, petSubCats, healthSubCats, sportSubCats, hobbySubCats, beautySubCats, homeSubCats]
        
        var count = 0
        
        for name in categories {
            let category:Category = NSEntityDescription.insertNewObject(forEntityName: "Category", into: Database.getContext()) as! Category
            category.name = name
            
            for subName in subCategories[count] {
                let subCategory: SubCategory = NSEntityDescription.insertNewObject(forEntityName: "SubCategory", into: Database.getContext()) as! SubCategory
                subCategory.name = subName
                category.addToSubCategories(subCategory)
                subCategory.category = category
            }
            count += 1
        }
    }
    
    private func setDefaultSettings() {
        let defaultSettings = ["salaryType" : "Hourly",
                               "payDay" : "Monday",
                               "payPeriod" : "Weekly"]
        for (key, value) in defaultSettings {
            UserDefaults.standard.set(value, forKey: key)
        }
        UserDefaults.standard.set(0.0, forKey: "salary")
    }
    


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        let fetchRequest: NSFetchRequest<Category> = Category.fetchRequest()
        
        do {
            let searchResults = try Database.getContext().fetch(fetchRequest)
            print(searchResults.count)
            if searchResults.count == 0 {
                loadStartingCategories()
                Database.saveContext()
                setDefaultSettings()
                UserDefaults.standard.set(false, forKey: "NewUpdate")
            }
            print(searchResults.count)
        } catch  {
            print("Error: \(error)")
        }
        
        // Override point for customization after application launch.
        return true
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
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // Saves changes in the application's managed object context before the application terminates.
        Database.saveContext()
    }
    

    
}

