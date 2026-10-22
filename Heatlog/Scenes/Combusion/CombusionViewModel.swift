//
//  CombusionViewModel.swift
//  Heatlog
//
//  Created by Emil Piórkowski on 20/10/2026.
//

import CoreData
import Foundation

@Observable
final class CombusionViewModel {
    var pricePerBag = ""
    var date = Date.now
    var bagsCount = 0

    private(set) var combusionCoal: [CoalUsage] = []
    private(set) var error: String?

    let context = PersistenceController.shared.container.viewContext
    let request = CoalUsage.fetchRequest()

    func fetchAllRecords() {
        request.sortDescriptors = [
            NSSortDescriptor(key: "date", ascending: false)
        ]
        do {
            combusionCoal = try context.fetch(request)
        } catch {
            self.error = error.localizedDescription
        }
    }

    func addRecord() {
        guard let price = Double(pricePerBag), price >= 0 else {
            return
        }
        
        guard bagsCount > 0, bagsCount <= Int(Int16.max) else {
            return
        }
        
        do {
            let newCombusion = CoalUsage(context: context)
            newCombusion.id = UUID()
            newCombusion.pricePerBag = Double(pricePerBag) ?? 0.00
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
            coalUsage.pricePerBag = Double(pricePerBag) ?? 0.00
            coalUsage.date = date
            coalUsage.bagsCount = Int16(bagsCount)

            try context.save()
            fetchAllRecords()
        } catch {
            self.error = error.localizedDescription
        }
    }

    func returnRelativeDate(_ coalUsage: CoalUsage) -> String {
        guard let date = coalUsage.date else {
            return ""
        }

        return date.formatted(.relative(presentation: .named))
    }

    func kilogramsOfCoalAdded(_ coalUsage: CoalUsage, kilograms: Int) -> Int {
        return Int(coalUsage.bagsCount) * kilograms
    }

    func costOfCoalAdded(_ coalUsage: CoalUsage) -> Double {
        return Double(coalUsage.bagsCount) * coalUsage.pricePerBag
    }

    func pricePerBag(totalCost: Double, bagsCount: Int) -> Double? {
        guard bagsCount > 0 else {
            return nil
        }
        
        return totalCost / Double(bagsCount)
    }
    
}
