import Foundation
import CoreData


extension StreakTrackerEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<StreakTrackerEntity> {
        return NSFetchRequest<StreakTrackerEntity>(entityName: "StreakTrackerEntity")
    }

    @NSManaged public var tasksCompleteFri: Int32
    @NSManaged public var tasksCompleteMon: Int32
    @NSManaged public var tasksCompleteSat: Int32
    @NSManaged public var tasksCompleteSun: Int32
    @NSManaged public var tasksCompleteThu: Int32
    @NSManaged public var tasksCompleteTue: Int32
    @NSManaged public var tasksCompleteWed: Int32

}

extension StreakTrackerEntity : Identifiable {

}
