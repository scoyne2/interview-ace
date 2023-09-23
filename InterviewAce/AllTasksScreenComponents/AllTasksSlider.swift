import SwiftUI
import CoreData

struct AllTasksSlider: View {
    var heightMultiplier: CGFloat
    var widthMultiplier: CGFloat
    @ObservedObject var currentProgress: ProgressEntity
    @ObservedObject var streakTrackerEntity : StreakTrackerEntity
    @Environment(\.managedObjectContext) private var viewContext
    
    
    var body: some View {
        GeometryReader { geometry in
            ScrollView(.vertical) {
                VStack(spacing: 20) {
                    ForEach(currentProgress.allItemsArray, id: \.taskId) { card in
                        ZStack{
                            // Day indicator
                            RoundedRectangle(cornerRadius: 10)
                                .foregroundColor(Color.customMediumGrey)
                                .frame(width: 100, height: 25)
                                .overlay(
                                    Text("Day: \(card.dayScheduled)")
                                        .font(Font.custom("Poppins", size: 15*heightMultiplier).weight(.semibold))
                                        .foregroundColor(Color.subtitle)
                                )
                                .offset(x: -100*heightMultiplier, y: -100*heightMultiplier)
                                .zIndex(99)
                            
                            // Completed indicator
                            if (card.isCompleted ){
                                Circle()
                                    .foregroundColor(Color.customGreenDark)
                                    .frame(width: 25, height: 25)
                                    .overlay(
                                        Image(systemName: "checkmark")
                                            .foregroundColor(.white)
                                            .font(.system(size: 15))
                                    )
                                    .offset(x: 140*heightMultiplier, y: -100*heightMultiplier)
                                    .zIndex(99)
                            }
                            
                            // Color Card underlay
                            VStack{
                            }
                            .frame(width: geometry.size.width*0.85, height: geometry.size.height/3.1)
                            .background(getColor(taskType: card.taskType))
                            .cornerRadius(20)
                            .shadow(color: Color(red: 0.13, green: 0.15, blue: 0.22, opacity: 0.60), radius: 9, x: 12)
                            
                            //Grey card with content
                            VStack(alignment: .leading){
                                Image(systemName: getIcon(taskType: card.taskType))
                                    .foregroundColor(getColor(taskType: card.taskType))
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
                                                .foregroundColor(Color.blue)
                                                .font(.system(size: 15 * heightMultiplier))
                                            Text("\(card.taskDescription)")
                                                .font(Font.custom("Poppins", size: 15 * heightMultiplier).weight(.semibold))
                                                .foregroundColor( Color.blue)
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
