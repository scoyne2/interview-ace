import SwiftUI
import CoreData

struct Streak: View {
    let heightMultiplier: CGFloat
    @ObservedObject var currentProgress: ProgressEntity
    @ObservedObject var streakTrackerEntity : StreakTrackerEntity
    
    let daysOfWeek = ["Mo", "Tu", "We", "Th", "Fr", "Sa", "Su"]
    
    
    var body: some View {
        
        let daysData: [(day: String, isComplete: Bool)] = [
            ("Mo", streakTrackerEntity.tasksCompleteMon > 0),
            ("Tu", streakTrackerEntity.tasksCompleteTue > 0),
            ("We", streakTrackerEntity.tasksCompleteWed > 0),
            ("Th", streakTrackerEntity.tasksCompleteThu > 0),
            ("Fr", streakTrackerEntity.tasksCompleteFri > 0),
            ("Sa", streakTrackerEntity.tasksCompleteSat > 0),
            ("Su", streakTrackerEntity.tasksCompleteSun > 0)
        ]
        
        GeometryReader { geometry in
            VStack(alignment: .leading, spacing: 12) {
                Text("Streak")
                    .font(Font.custom("Poppins", size: 18).weight(.bold))
                    .foregroundColor(.white)
                
                HStack(spacing: 10) {
                    ForEach(daysData, id: \.day) { d in
                        DayView(day: d.day, checked: d.isComplete, circleSize: geometry.size.width/8.5, heightMultiplier: heightMultiplier)
                    }
                }
            }
        }
    }
}

struct DayView: View {
    var day: String
    var checked: Bool
    var circleSize: CGFloat
    let heightMultiplier: CGFloat
    
    
    var body: some View {
        
        ZStack {
            Circle()
                .foregroundColor(Color.customMediumGrey)
                .frame(width: circleSize, height: circleSize)
                .overlay(
                    Text(day)
                        .font(Font.custom("Poppins", size: 12))
                        .foregroundColor(.white)
                )
            if (checked ){
                Circle()
                    .foregroundColor(Color.customYellow)
                    .frame(width: circleSize/2.5, height: circleSize/2.5)
                    .overlay(
                        Image(systemName: "checkmark")
                            .foregroundColor(.black)
                            .font(.system(size: 10))
                    )
                    .offset(x: 15, y: -15)
            }
            
        }
    }
}
