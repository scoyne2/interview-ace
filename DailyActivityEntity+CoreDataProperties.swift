import Foundation
import CoreData


extension DailyActivityEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<DailyActivityEntity> {
        return NSFetchRequest<DailyActivityEntity>(entityName: "DailyActivityEntity")
    }

    @NSManaged public var date: Date?
    @NSManaged public var activityCount: Int32
    @NSManaged public var id: UUID

}

extension DailyActivityEntity : Identifiable {

}
