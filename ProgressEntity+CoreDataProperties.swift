import Foundation
import CoreData


extension ProgressEntity {
    
    @nonobjc public class func fetchRequest() -> NSFetchRequest<ProgressEntity> {
        return NSFetchRequest<ProgressEntity>(entityName: "ProgressEntity")
    }
    
    @NSManaged public var daysOfStreak: Int32
    @NSManaged public var currentDay: Int32
    @NSManaged public var startDate: Date
    @NSManaged public var id: UUID
    @NSManaged public var overallProgress: Double
    @NSManaged public var totalTimeInvested: Int32
    @NSManaged public var allItems: NSSet
    @NSManaged public var todaysItems: NSSet
    @NSManaged public var activities: NSSet
    @NSManaged public var totalTasks: Int32
    @NSManaged public var completedTasks: Int32
    @NSManaged public var lastTaskCompletionDate: Date?
    @NSManaged public var allowNotifications: Bool
    @NSManaged public var hasSeenNotificationsPrompt: Bool
    @NSManaged public var remainingTasks: Int32
    
    public var todaysItemsArray: [TaskEntity] {
        let set = todaysItems as? Set<TaskEntity> ?? []
        
        return set.sorted { (task1, task2) in
            return task1.taskId < task2.taskId
        }
    }
    
    public var allItemsArray: [TaskEntity] {
        let set = allItems as? Set<TaskEntity> ?? []
        
        return set.sorted { (task1, task2) in
            return task1.taskId < task2.taskId
        }
    }
    
    public var activitiesArray: [DailyActivityEntity] {
        let set = activities as? Set<DailyActivityEntity> ?? []
        return set.sorted(by: { (activity1, activity2) -> Bool in
            guard let date1 = activity1.date, let date2 = activity2.date else { return false }
            return date1 > date2
        })
    }
    
    
}

extension ProgressEntity {
    
    @objc(addTodaysItemsObject:)
    @NSManaged public func addToTodaysItems(_ value: TaskEntity)
    
    @objc(removeTodaysItemsObject:)
    @NSManaged public func removeFromTodaysItems(_ value: TaskEntity)
    
    @objc(addTodaysItems:)
    @NSManaged public func addToTodaysItems(_ values: NSSet)
    
    @objc(removeTodaysItems:)
    @NSManaged public func removeFromTodaysItems(_ values: NSSet)
    
    
    func addNewActivity(date: Date, activityCount: Int32, context: NSManagedObjectContext) {
        let newActivity = DailyActivityEntity(context: context)
        newActivity.date = date
        newActivity.activityCount = activityCount
        newActivity.id = UUID()
        self.addToActivities(newActivity)
    }
    
    @objc(addActivitiesObject:)
    @NSManaged public func addToActivities(_ value: DailyActivityEntity)
    
    @objc(removeActivitiesObject:)
    @NSManaged public func removeFromActivities(_ value: DailyActivityEntity)
    
    @objc(addActivities:)
    @NSManaged public func addToActivities(_ values: NSSet)
    
    @objc(removeActivities:)
    @NSManaged public func removeFromActivities(_ values: NSSet)
    
}

extension ProgressEntity : Identifiable {
    
}
