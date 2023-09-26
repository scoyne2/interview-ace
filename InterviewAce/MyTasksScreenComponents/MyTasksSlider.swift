import SwiftUI
import CoreData

struct Card {
    let color: Color
    let order: CGFloat
    let isCompleted: Bool
}

struct MyTasksSlider: View {
    var heightMultiplier: CGFloat
    var widthMultiplier: CGFloat
    @ObservedObject var currentProgress: ProgressEntity
    @ObservedObject var streakTrackerEntity : StreakTrackerEntity
    @Environment(\.managedObjectContext) private var viewContext
    
    
    
    func toggleTaskCompletion(task: TaskEntity, currentProgress: ProgressEntity, streakTrackerEntity: StreakTrackerEntity) {
        var activityCountIncrement = 0
        if task.isCompleted {
            currentProgress.completedTasks -= 1
            currentProgress.remainingTasks += 1
            currentProgress.totalTimeInvested -= Int32(task.estimatedTime)
            activityCountIncrement = -1
            
            
            
        } else {
            currentProgress.completedTasks += 1
            currentProgress.remainingTasks -= 1
            currentProgress.totalTimeInvested += Int32(task.estimatedTime)
            activityCountIncrement = 1
        }
        
        calculateStreak(task: task, currentProgress: currentProgress, streakTrackerEntity: streakTrackerEntity)
        
        currentProgress.overallProgress = (Double(currentProgress.completedTasks) / Double(currentProgress.totalTasks))
        
        task.isCompleted.toggle()
        
        updateActivities(currentProgress: currentProgress, activityCountIncrement: Int32(activityCountIncrement))
        
        do {
            try viewContext.save()
        } catch {
            print("Failed to save context during toggleTaskCompletion(): \(error)")
        }
        
        setBadgeCount(count: Int(currentProgress.remainingTasks))
    }
    
    func calculateStreak(task: TaskEntity, currentProgress: ProgressEntity, streakTrackerEntity: StreakTrackerEntity) {
        let components = DateComponents(year: 1900, month: 1, day: 1)
        let defaultDate = Calendar.current.date(from: components)
        
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EE"
        let dayOfTheWeekAbbreviation = dateFormatter.string(from: today)
        
        // if task.isCompleted is false, that means we are about to flip it to true
        var streakIncrement = 0
        if task.isCompleted == false{
            streakIncrement = 1
        } else {
            streakIncrement = -1
        }
        
        switch dayOfTheWeekAbbreviation {
        case "Mon":
            streakTrackerEntity.tasksCompleteMon += Int32(streakIncrement)
        case "Tue":
            streakTrackerEntity.tasksCompleteTue += Int32(streakIncrement)
        case "Wed":
            streakTrackerEntity.tasksCompleteWed += Int32(streakIncrement)
        case "Thu":
            streakTrackerEntity.tasksCompleteThu += Int32(streakIncrement)
        case "Fri":
            streakTrackerEntity.tasksCompleteFri += Int32(streakIncrement)
        case "Sat":
            streakTrackerEntity.tasksCompleteSat += Int32(streakIncrement)
        case "Sun":
            streakTrackerEntity.tasksCompleteSun += Int32(streakIncrement)
        default:
            print("day of week unknown \(dayOfTheWeekAbbreviation)")
        }
        
        
        let dayBeforeToday = calendar.date(byAdding: .day, value: -1, to: today)
        
        let lastCompletionDate = currentProgress.lastTaskCompletionDate ?? defaultDate
        
        if currentProgress.lastTaskCompletionDate == defaultDate {
            currentProgress.daysOfStreak = 1
        } else {
            if lastCompletionDate == dayBeforeToday {
                currentProgress.daysOfStreak += 1
            } else {
                currentProgress.daysOfStreak = 1
            }
        }
        
        // if task.isCompleted is false, that means we are about to flip it to true
        if task.isCompleted == false{
            currentProgress.lastTaskCompletionDate = today
        }
        
        do {
            try viewContext.save()
        } catch {
            
            print("Failed to save context during calculateStreak(): \(error)")
        }
    }
    
    func updateActivities(currentProgress: ProgressEntity, activityCountIncrement: Int32){
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        
        var activityCt = Int32(0)
        let mostRecentActivity = currentProgress.activitiesArray.first
        
        // Check if there is already activity for today in currentProgress.
        if (mostRecentActivity!.date! == today){
            activityCt = mostRecentActivity!.activityCount
            let activityId = mostRecentActivity!.id
            updateActivityCount(id: activityId, withCount: activityCt + activityCountIncrement)
        }
        
        
    }
    
    func updateActivityCount(id: UUID, withCount count: Int32) {
        // Fetch request to get the DailyActivity with the specified id
        let fetchRequest: NSFetchRequest<DailyActivityEntity> = DailyActivityEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %@", id as CVarArg)
        fetchRequest.fetchLimit = 1
        
        do {
            let results = try viewContext.fetch(fetchRequest)
            
            // Check if we got the DailyActivity with the specified id
            if let dailyActivity = results.first {
                dailyActivity.activityCount = count
                
                // Save the changes
                try viewContext.save()
            } else {
                print("No DailyActivity found with the specified id.")
            }
        } catch let error as NSError {
            print("Error updating DailyActivity: \(error), \(error.userInfo)")
        }
    }
    
    var body: some View {
        GeometryReader { geometry in
            ScrollView(.vertical) {
                VStack(spacing: 20) {
                    ForEach(currentProgress.todaysItemsArray, id: \.taskId) { card in
                        ZStack{
                            // Color Card underlay
                            VStack{
                            }
                            .frame(width: geometry.size.width*0.85, height: geometry.size.height/3.1)
                            .background(card.isCompleted ? Color.gray : getColor(taskType: card.taskType))
                            .cornerRadius(20)
                            .shadow(color: Color(red: 0.13, green: 0.15, blue: 0.22, opacity: 0.60), radius: 9, x: 12)
                            
                            //Grey card with content
                            VStack(alignment: .leading){
                                Image(systemName: getIcon(taskType: card.taskType))
                                    .foregroundColor(card.isCompleted ? Color.gray : getColor(taskType: card.taskType))
                                    .font(.system(size: 38*heightMultiplier))
                                    .padding(.bottom, 5*heightMultiplier)
                                
                                Text("\(card.taskTitle)")
                                    .font(Font.custom("Poppins", size: 20*heightMultiplier).weight(.medium))
                                    .foregroundColor(.white)
                                    .padding(.bottom, 7*heightMultiplier)
                                
                                Text("Due today: \(Int(card.estimatedTime)) minutes")
                                    .font(Font.custom("Poppins", size: 15*heightMultiplier).weight(.semibold))
                                    .foregroundColor(Color.subtitle)
                                    .padding(.bottom, 5*heightMultiplier)
                                if(card.isLink){
                                    Link(destination: URL(string: card.link)!) {
                                        HStack {
                                            Image(systemName: "link")
                                                .foregroundColor(card.isCompleted ? Color.gray : Color.blue)
                                                .font(.system(size: 15 * heightMultiplier))
                                            Text("\(card.taskDescription)")
                                                .font(Font.custom("Poppins", size: 15 * heightMultiplier).weight(.semibold))
                                                .foregroundColor(card.isCompleted ? Color.gray : Color.blue)
                                                .multilineTextAlignment(.leading) // Left-aligned text
                                                .fixedSize(horizontal: false, vertical: true) // Allows text to wrap to multiple lines
                                        }
                                    }
                                    .padding(.bottom, 9 * heightMultiplier)
                                }else{
                                    Text("\(card.taskDescription)")
                                        .font(Font.custom("Poppins", size: 15*heightMultiplier).weight(.semibold))
                                        .foregroundColor(Color.subtitle)
                                        .padding(.bottom, 9*heightMultiplier)
                                }
                                
                                Button(action: {toggleTaskCompletion(task: card, currentProgress: currentProgress, streakTrackerEntity: streakTrackerEntity) } ) {
                                    Text(card.isCompleted ? "Completed" : "Mark as Complete")
                                        .frame(minWidth: geometry.size.width*0.6, minHeight: 40)
                                        .foregroundColor(Color.white)
                                }
                                .background(card.isCompleted ? Color.gray.opacity(0.5) : Color(red: 0.13, green: 0.15, blue: 0.22))
                                .cornerRadius(10)
                                
                            }.padding(.leading, -15)
                                .frame(width: geometry.size.width*0.85, height: geometry.size.height/3.1)
                                .background(Color.customMediumGrey)
                                .cornerRadius(20)
                                .offset(x: 5, y: 0)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 15)
                                        .inset(by: 2.50)
                                        .stroke(getColor(taskType: card.taskType), lineWidth: 0)
                                )
                        }.padding(.leading, (geometry.size.width*0.15)/2)
                    }
                }.padding(.top, 20)
            }
        }
    }
}
