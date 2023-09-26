import Foundation
import CoreData
import SwiftUI

struct TaskEntityJSONRepresentation: Codable {
    var estimatedTime: Double
    var taskId: Int32
    var isCompleted: Bool
    var isLink: Bool
    var link: String
    var taskDescription: String
    var taskTitle: String
    var taskType: String
    var dayScheduled: Int32
}

func fetchAllTasks(container: NSPersistentContainer) -> [TaskEntity] {
    let context = container.viewContext
    let fetchRequest: NSFetchRequest<TaskEntity> = TaskEntity.fetchRequest()
    
    // Execute the fetch request
    do {
        let tasks = try context.fetch(fetchRequest)
        return tasks
    } catch {
        print("Error fetching tasks on fetchAllTasks(): \(error)")
        return []
    }
}

func fetchTasksScheduledForDay(container: NSPersistentContainer, day: Int32) -> [TaskEntity] {
    let context = container.viewContext
    let fetchRequest: NSFetchRequest<TaskEntity> = TaskEntity.fetchRequest()
    
    // Set the predicate
    fetchRequest.predicate = NSPredicate(format: "dayScheduled == %d OR (isCompleted == %d AND dayScheduled < %d)", day, false, day)
    
    // Execute the fetch request
    do {
        let tasks = try context.fetch(fetchRequest)
        return tasks
    } catch {
        print("Error fetching tasks on fetchTasksScheduledForDay(): \(error)")
        return []
    }
}

func getIncompleteTasksForToday(container: NSPersistentContainer, day: Int32) -> Int {
    let context = container.viewContext
    let fetchRequest: NSFetchRequest<TaskEntity> = TaskEntity.fetchRequest()
    
    // Set the predicate
    fetchRequest.predicate = NSPredicate(format: "isCompleted == %d AND dayScheduled <= %d", false, day)
    
    // Execute the fetch request
    do {
        let tasks = try context.fetch(fetchRequest)
        return tasks.count
    } catch {
        print("Error fetching tasks on getIncompleteTasksForToday(): \(error)")
        return 0
    }
}

func PrepareTodaysTasks(container: NSPersistentContainer) -> Void{
    let context = container.viewContext
    let fetchRequest: NSFetchRequest<ProgressEntity> = ProgressEntity.fetchRequest()
    
    let calendar = Calendar.current
    let today = calendar.startOfDay(for: Date())
    
    do {
        let fetchedItems = try context.fetch(fetchRequest)
        guard let userProfile = fetchedItems.first else {
            print("No Item found in the datastore")
            return
        }
        
        let startDate = userProfile.startDate
        let components = calendar.dateComponents([.day], from: startDate, to: today)
        let day = Int32(components.day ?? 0) + 1
        
        userProfile.currentDay = day
        let todaysTasks = fetchTasksScheduledForDay(container: container, day: day)
        userProfile.todaysItems = NSSet(array: todaysTasks)
        
        let remainingTasks = getIncompleteTasksForToday(container: container, day: day)
        userProfile.remainingTasks = Int32(remainingTasks)
        setBadgeCount(count: remainingTasks)
        print("Todays Items \(remainingTasks)")
        
        let allTasks = fetchAllTasks(container: container)
        userProfile.allItems = NSSet(array: allTasks)
        
        try context.save()
    } catch {
        print("Error in PrepareTodaysTasks: \(error)")
    }
    
}

func PrepareTodaysActivities(container: NSPersistentContainer) -> Void{
    let context = container.viewContext
    let fetchRequest: NSFetchRequest<ProgressEntity> = ProgressEntity.fetchRequest()
    
    let calendar = Calendar.current
    let today = calendar.startOfDay(for: Date())
    
    do {
        let fetchedItems = try context.fetch(fetchRequest)
        guard let userProfile = fetchedItems.first else {
            print("No Item found in the datastore")
            return
        }
        
        let activitiesArray = userProfile.activitiesArray
        let mostRecentActivity = activitiesArray.first
        if mostRecentActivity?.date == today{
            // Today was already prepared, prepare streak
            print("Today was already prepared, nothing to do here")
            return
        }
        
        // If today is a monday, or if the last activity date is > 7 days ago, clear the streak
        prepareStreak(container: container)
        
        userProfile.addNewActivity(date: today, activityCount: 0, context: context)
        
        try context.save()
    } catch {
        print("Error in PrepareTodaysActivities: \(error)")
    }
    
}

func prepareStreak(container: NSPersistentContainer) -> Void{
    let context = container.viewContext
    let fetchRequestStreak: NSFetchRequest<StreakTrackerEntity> = StreakTrackerEntity.fetchRequest()
    let fetchRequestItem: NSFetchRequest<ProgressEntity> = ProgressEntity.fetchRequest()
    
    let calendar = Calendar.current
    let today = calendar.startOfDay(for: Date())
    var clearStreak = false
    
    do {
        let fetchedStreaks = try context.fetch(fetchRequestStreak)
        guard let streakTracker = fetchedStreaks.first else {
            print("No StreakTracker found in the datastore")
            return
        }
        
        let fetchedItems = try context.fetch(fetchRequestItem)
        guard let userProfile = fetchedItems.first else {
            print("No Item found in the datastore")
            return
        }
        let activitiesArray = userProfile.activitiesArray
        guard let mostRecentActivity = activitiesArray.first else {
            print("No mostRecentActivity found in the datastore")
            return
        }
        
        // If today is Mon, and last activity date is not today, clear streak
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EE"
        let dayOfTheWeekAbbreviation = dateFormatter.string(from: today)
        if (dayOfTheWeekAbbreviation == "Mon" && mostRecentActivity.date! < today){
            clearStreak = true
        }
        
        // If the most recent activity was > 7 days ago, clear streak
        let sevenDaysAgo = Calendar.current.date(byAdding: .day, value: -7, to: today)!
        if mostRecentActivity.date! < sevenDaysAgo {
            clearStreak = true
        }
        
        
        if (clearStreak){
            streakTracker.tasksCompleteMon = 0
            streakTracker.tasksCompleteTue = 0
            streakTracker.tasksCompleteWed = 0
            streakTracker.tasksCompleteThu = 0
            streakTracker.tasksCompleteFri = 0
            streakTracker.tasksCompleteSat = 0
            streakTracker.tasksCompleteSun = 0
        }
        
        
        try context.save()
    } catch {
        print("Error in PrepareStreak: \(error)")
    }
    
}

func SeedInitialData(container: NSPersistentContainer) -> Void{
    let context = container.viewContext
    let fetchRequest: NSFetchRequest<ProgressEntity> = ProgressEntity.fetchRequest()
    
    let calendar = Calendar.current
    let today = calendar.startOfDay(for: Date())
    
    do {
        let count = try context.count(for: fetchRequest)
        if count == 0 { // No data seeded yet
            let newStreak = StreakTrackerEntity(context: context)
            newStreak.tasksCompleteMon = 0
            newStreak.tasksCompleteTue = 0
            newStreak.tasksCompleteWed = 0
            newStreak.tasksCompleteThu = 0
            newStreak.tasksCompleteFri = 0
            newStreak.tasksCompleteSat = 0
            newStreak.tasksCompleteSun = 0
            
            let newDailyActivity = DailyActivityEntity(context: context)
            newDailyActivity.date = today
            newDailyActivity.activityCount = 0
            newDailyActivity.id = UUID()
            
            let newItem = ProgressEntity(context: context)
            newItem.overallProgress = 0.0
            newItem.daysOfStreak = 0
            newItem.totalTimeInvested = 0
            newItem.id =  UUID()
            newItem.completedTasks = 0
            newItem.currentDay = 1
            newItem.startDate = today
            newItem.hasSeenNotificationsPrompt = false
            newItem.allowNotifications = false
            newItem.remainingTasks = 0
            
            if let url = Bundle.main.url(forResource: "tasks", withExtension: "json") {
                do {
                    let data = try Data(contentsOf: url)
                    do {
                        let taskArray = try JSONDecoder().decode([TaskEntityJSONRepresentation].self, from: data)
                        newItem.totalTasks = Int32(taskArray.count)
                        for task in taskArray {
                            let newTask = TaskEntity(context: context)
                            newTask.estimatedTime = task.estimatedTime
                            newTask.taskId = task.taskId
                            newTask.isCompleted = task.isCompleted
                            newTask.isLink = task.isLink
                            newTask.link = task.link
                            newTask.taskDescription = task.taskDescription
                            newTask.taskTitle = task.taskTitle
                            newTask.taskType = task.taskType
                            newTask.dayScheduled = task.dayScheduled
                        }
                    } catch let decodeError {
                        print("JSON Decoding failed: \(decodeError)")
                    }
                } catch let dataError {
                    print("Reading data failed: \(dataError)")
                }
            } else {
                print("URL for tasks.json not found.")
            }
            
            
            do {
                try context.save()
            } catch {
                print("Error saving seeded data: \(error)")
            }
        } else {
        }
    } catch {
        print("Error fetching items: \(error)")
    }
    
}

func SeedPreviewData(context: NSManagedObjectContext) -> Void{
    let calendar = Calendar.current
    let today = calendar.startOfDay(for: Date())
    
    let newStreak = StreakTrackerEntity(context: context)
    newStreak.tasksCompleteMon = 0
    newStreak.tasksCompleteTue = 0
    newStreak.tasksCompleteWed = 0
    newStreak.tasksCompleteThu = 0
    newStreak.tasksCompleteFri = 0
    newStreak.tasksCompleteSat = 0
    newStreak.tasksCompleteSun = 0
    
    let newDailyActivity = DailyActivityEntity(context: context)
    newDailyActivity.date = today
    newDailyActivity.activityCount = 0
    newDailyActivity.id = UUID()
    
    let newItem = ProgressEntity(context: context)
    newItem.overallProgress = 0.0
    newItem.daysOfStreak = 0
    newItem.totalTimeInvested = 0
    newItem.totalTasks = 20
    newItem.completedTasks = 0
    newItem.currentDay = 1
    newItem.startDate = today
    
    let newTask = TaskEntity(context: context)
    newTask.estimatedTime = 15
    newTask.isCompleted = false
    newTask.isLink = true
    newTask.link = "http://www.google.com"
    newTask.taskDescription = "This is a test"
    newTask.taskTitle = "Test Item"
    newTask.taskId = 1
    newTask.taskType = "Reading"
    newTask.dayScheduled = 1
    
    let newTask2 = TaskEntity(context: context)
    newTask2.estimatedTime = 45
    newTask2.isCompleted = false
    newTask2.isLink = false
    newTask2.link = ""
    newTask2.taskDescription = "This is a test 2"
    newTask2.taskTitle = "Test Item 2"
    newTask2.taskId = 2
    newTask2.taskType = "Reading"
    newTask2.dayScheduled = 1
    
    let newTask3 = TaskEntity(context: context)
    newTask3.estimatedTime = 45
    newTask3.isCompleted = false
    newTask3.isLink = false
    newTask3.link = ""
    newTask3.taskDescription = "This is a test 3"
    newTask3.taskTitle = "Test Item 3"
    newTask3.taskId = 3
    newTask3.taskType = "Watch Video"
    newTask3.dayScheduled = 2
    
    do {
        try context.save()
    } catch {
        print("Error seeding data: \(error)")
    }
}
