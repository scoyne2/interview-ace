import SwiftUI
import CoreData

struct ProgressChart: View {
    let heightMultiplier: CGFloat
    @ObservedObject var currentProgress: ProgressEntity
    @ObservedObject var streakTrackerEntity : StreakTrackerEntity
    
    var body: some View {
        
        let currentWeekday = Calendar.current.component(.weekday, from: Date()) // Sunday is 1, Monday is 2, etc.
        
        let daysData: [(day: String, offset: CGFloat, taskCount: CGFloat, isToday: Bool)] = [
            ("Mo", 0, CGFloat(streakTrackerEntity.tasksCompleteMon), currentWeekday == 2),
            ("Tu", 1, CGFloat(streakTrackerEntity.tasksCompleteTue), currentWeekday == 3),
            ("We", 2, CGFloat(streakTrackerEntity.tasksCompleteWed), currentWeekday == 4),
            ("Th", 3, CGFloat(streakTrackerEntity.tasksCompleteThu), currentWeekday == 5),
            ("Fr", 4, CGFloat(streakTrackerEntity.tasksCompleteFri), currentWeekday == 6),
            ("Sa", 5, CGFloat(streakTrackerEntity.tasksCompleteSat), currentWeekday == 7),
            ("Su", 6, CGFloat(streakTrackerEntity.tasksCompleteSun), currentWeekday == 1)
        ]
        
        let currentDay = CGFloat(daysData.first(where: { $0.isToday })?.offset ?? 0)
        
        GeometryReader { geometry in
            VStack(alignment: .leading) {
                Text("Progress")
                    .font(Font.custom("Poppins", size: 18).weight(.bold))
                    .foregroundColor(.white)
                
                ZStack() {
                    ForEach(daysData, id: \.day) { data in
                        let lineSpacing = 32.00*data.offset
                        
                        if(data.isToday){
                            // Green highlight bar on today
                            Rectangle()
                                .foregroundColor(.clear)
                                .frame(width: 30,
                                       height: (geometry.size.height*0.65)+10
                                )
                                .background(
                                    LinearGradient(gradient: Gradient(colors: [Color.customGreenLight, Color.customGreenDark]), startPoint: .top, endPoint: .bottom)
                                )
                                .cornerRadius(20)
                                .offset(x: 16+(32*currentDay), y: 0)
                                .opacity(0.80)
                            // Small white vertical indicator on today
                            Rectangle()
                                .foregroundColor(Color.white)
                                .frame(width: 1, height: 7)
                                .offset(x: 16+(32*currentDay), y: 45*heightMultiplier)
                        }
                        
                        // Vertical lines on chart
                        Rectangle()
                            .foregroundColor(Color.customMediumGrey)
                            .frame(width: 1.5, height:
                                    geometry.size.height*0.65
                            )
                            .offset(x: lineSpacing)
                        
                        // Indicator of days tasks on chart
                        Circle()
                            .foregroundColor(Color.customGreenLight)
                            .frame(width: 15, height: 15)
                            .foregroundColor(Color(red: 0.15, green: 0.18, blue: 0.25))
                            .offset(x: 16+(lineSpacing), y: data.taskCount == 0 ? 45*heightMultiplier : -25 * data.taskCount)
                        
                        // Day label at bottom of chart
                        Text(data.day)
                            .font(Font.custom("Poppins", size: 12).weight(data.isToday ? .bold : .medium))
                            .foregroundColor(data.isToday ? .white : Color(red: 0.47, green: 0.53, blue: 0.67))
                            .offset(x: lineSpacing+16, y: geometry.size.height*0.30)
                            .opacity(data.isToday ? 1 : 0.50)
                        
                        if(data.offset==6){
                            // Vertical line on chart for Sunday
                            Rectangle()
                                .foregroundColor(Color.customMediumGrey)
                                .frame(width: 1.5, height: geometry.size.height*0.6*heightMultiplier)
                                .offset(x: lineSpacing+32)
                        }
                        
                    }.offset(x:-8)
                }
                
            }
            
        }
        
    }
}
