//
//  CoreDataManager.swift
//  Transport
//
//  Created by Алена on 27.02.2022.
//

import UIKit
import CoreData

// Менеджер для работы с CoreData
final class CoreDataManager {
    
    private func makeContextCoreData() -> NSManagedObjectContext? {
        let delegate = UIApplication.shared.delegate as? AppDelegate
        let context = delegate?.persistentContainer.viewContext
        return context ?? nil
    }
    
    private func deleteAllData() {
        guard let context = makeContextCoreData() else { return }

        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "UserLastChoiceModel")
        fetchRequest.returnsObjectsAsFaults = false
        do {
            let results = try context.fetch(fetchRequest)
            for object in results {
                guard let objectData = object as? NSManagedObject else {continue}
                context.delete(objectData)
            }
        } catch let error as NSError {
            print(error.localizedDescription)
        }
    }
    
    func saveLastChoice(stopoverModel: StopoverModel) {
        deleteAllData()
        guard let context = makeContextCoreData() else { return }
        
        guard let entity = NSEntityDescription.entity(forEntityName: "UserLastChoiceModel", in: context) else { return }
        
        let model = UserLastChoiceModel(entity: entity, insertInto: context)
        model.id = stopoverModel.id
        model.lat = stopoverModel.lat ?? 0.0
        model.lon = stopoverModel.lon ?? 0.0
        model.stopoverName = stopoverModel.stopoverName
                
        do {
            try context.save()
        } catch let error as NSError {
            print(error.localizedDescription)
        }
    }
    
    func getUserLastChoiceModel() -> UserLastChoiceModel? {
        guard let context = makeContextCoreData() else { return nil }
        
        let fetchRequest: NSFetchRequest<UserLastChoiceModel> = UserLastChoiceModel.fetchRequest()
        
        do {
            let model = try context.fetch(fetchRequest)
            return model.last
        } catch let error {
            print(error.localizedDescription)
            return nil
        }
    }
}
