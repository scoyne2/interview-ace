import Foundation
import CoreData


extension TaskEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<TaskEntity> {
        return NSFetchRequest<TaskEntity>(entityName: "TaskEntity")
    }

    @NSManaged public var estimatedTime: Double
    @NSManaged public var taskId: Int32
    @NSManaged public var isCompleted: Bool
    @NSManaged public var isLink: Bool
    @NSManaged public var link: String
    @NSManaged public var taskDescription: String
    @NSManaged public var taskTitle: String
    @NSManaged public var taskType: String
    @NSManaged public var dayScheduled: Int32
    
    override public var description: String {
        return "TaskEntity(estimatedTime: \(self.estimatedTime), isCompleted: \(self.isCompleted), isLink: \(self.isLink), link: \(self.link), taskDescription: \(self.taskDescription), taskTitle: \(self.taskTitle), taskId: \(self.taskId), taskType: \(self.taskType), dayScheduled: \(self.dayScheduled))"
    }
}

extension TaskEntity : Identifiable {

}
