//
//  CoreDataStack.swift
//  PuntersWeather
//
//  Created by Noble Mathew on 26/6/17.
//  Copyright © 2017 NTech. All rights reserved.
//

import Foundation
import CoreData

final class CoreDataStack {
  
  //Creating singleton class to use the persistent Container in all classes
  static let shared = CoreDataStack()
  
  /*
   The persistent container for the application. This property is optional since 
   there are legitimate error conditions that could cause the creation of the store 
   to fail.
   */
  lazy var persistentContainer: NSPersistentContainer = {
    let container = NSPersistentContainer(name: "WeatherModel")
    container.loadPersistentStores(completionHandler: { (description, error) in
      container.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
      if let error = error {
        print("Unresolved error \(error)")
      }
    })
    return container
  }()
  
  //MARK: - Core Data saving support
  func saveContext() {
    let context = persistentContainer.viewContext
    if context.hasChanges {
      do {
        try context.save()
      } catch let error {
        print("Unresolved Error \(error)")
      }
    }
  }
}
