//
//  CombusionViewModel.swift
//  Heatlog
//
//  Created by Emil Piórkowski on 20/10/2026.
//

import Foundation
import CoreData

@Observable
final class CombusionViewModel {
    var amount = ""
    var date = Date.now
    var bagsCount = 0
    
    private(set) var combusionCoal: [CoalUsage] = []
    private(set) var error: String?
    
    let context = PersistenceController.shared.container.viewContext
    let request = CoalUsage.fetchRequest()
    
    
    func fetchAllRecords() {
        request.sortDescriptors = [NSSortDescriptor(key: "date", ascending: false)]
        do {
            combusionCoal = try context.fetch(request)
        } catch {
            self.error = error.localizedDescription
        }
    }
    
    func addRecord() {
        do {
            let newCombusion = CoalUsage(context: context)
            newCombusion.id = UUID()
            newCombusion.amount = Double(amount) ?? 0.00
            newCombusion.date = date
            newCombusion.bagsCount = Int16(bagsCount)
            try context.save()
            
        } catch {
            self.error = error.localizedDescription
        }
    }
    
    func delete(_ coalUsage: CoalUsage?) {
        do {
            guard let coalUsage else {
                return
            }
            
            context.delete(coalUsage)
            try context.save()
            fetchAllRecords()
        } catch {
            self.error = error.localizedDescription
        }
    }
    
    func update(_ coalUsage: CoalUsage) {
        do {
            coalUsage.amount = Double(amount) ?? 0.00
            coalUsage.date = date
            coalUsage.bagsCount = Int16(bagsCount)
            
            
            try context.save()
        } catch {
            self.error = error.localizedDescription
        }
    }
}
