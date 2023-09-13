import SwiftUI
import CoreData

struct TodaysTasksSection:  View {
    let heightMultiplier: CGFloat
    let widthMultiplier: CGFloat
    @ObservedObject var currentProgress: ProgressEntity
    @ObservedObject var streakTrackerEntity : StreakTrackerEntity
    
    @Environment(\.managedObjectContext) private var viewContext
    
    var body: some View {
        
        VStack(alignment: .leading) {
            NavigationLink(destination: MyTasksView(heightMultiplier: heightMultiplier, widthMultiplier: widthMultiplier, currentProgress: currentProgress, streakTrackerEntity: streakTrackerEntity).environment(\.managedObjectContext, viewContext)) {
                HStack() {
                    Text("Tasks for today")
                        .font(Font.custom("Poppins", size: 18).weight(.bold))
                        .foregroundColor(.white)
                    
                    Text("(\(currentProgress.todaysItemsArray.filter { $0.isCompleted }.count)/\(currentProgress.todaysItemsArray.count))")
                        .font(Font.custom("Poppins", size: 12).weight(.medium))
                        .foregroundColor(Color(red: 0.47, green: 0.53, blue: 0.67))
                    
                    Spacer()
                    
                    Image(systemName: "arrow.right")
                        .foregroundColor(.white)
                        .font(.system(size: 15))
                }
            }
            
            ProgressBar(currentProgress: currentProgress, heightMultiplier: heightMultiplier)
                .padding(.top, 10*heightMultiplier)
            
            
            TodaysCards(heightMultiplier: heightMultiplier, widthMultiplier: widthMultiplier, currentProgress: currentProgress, streakTrackerEntity: streakTrackerEntity)
            
        }
    }
}

struct ProgressBar: View {
    @ObservedObject var currentProgress: ProgressEntity
    let heightMultiplier: CGFloat
    
    var body: some View {
        ZStack(alignment: .leading) {
            GeometryReader { geometry in
                Rectangle()
                    .foregroundColor(.clear)
                    .frame(width: geometry.size.width, height: 16)
                    .background(Color(red: 0.17, green: 0.20, blue: 0.27))
                    .cornerRadius(30)
                
                Rectangle()
                    .foregroundColor(.clear)
                    .frame(width: (currentProgress.overallProgress > 0 && currentProgress.overallProgress < 0.1) ? 10 : geometry.size.width*currentProgress.overallProgress, height: 16)
                    .background(
                        LinearGradient(gradient:
                                        Gradient(colors: [
                                            Color.customGreenLight,
                                            Color.customGreenDark]),
                                       startPoint: .top, endPoint: .bottom)
                    )
                    .cornerRadius(30)
                
                if (currentProgress.overallProgress > 0) {
                    Rectangle()
                        .foregroundColor(.clear)
                        .frame(width: 2, height: 8)
                        .background(.white)
                        .cornerRadius(20)
                        .offset(x:
                                    (currentProgress.overallProgress > 0 && currentProgress.overallProgress < 0.1) ? 6 :
                                    (geometry.size.width * currentProgress.overallProgress)-10, y: 4)
                }
            }
        }
    }
}

struct Card2 {
    let color: Color
    let order: CGFloat
    
}


struct TodaysCards: View {
    let heightMultiplier: CGFloat
    let widthMultiplier: CGFloat
    @ObservedObject var currentProgress: ProgressEntity
    @ObservedObject var streakTrackerEntity : StreakTrackerEntity
    @Environment(\.managedObjectContext) private var viewContext
    
    
    var body: some View {
        let staticCards = [
            Card2(color: Color.customOrange, order: 3),
            Card2(color: Color.customPurple, order: 2),
            Card2(color: Color.customYellow, order: 1),
            Card2(color: Color.customBlue, order: 0)
        ]
        
        let firstIncompleteTask = currentProgress.todaysItemsArray.first(where: { !$0.isCompleted })
        let itemsRemaining = firstIncompleteTask != nil
        NavigationLink(destination: MyTasksView(heightMultiplier: heightMultiplier, widthMultiplier: widthMultiplier, currentProgress: currentProgress, streakTrackerEntity: streakTrackerEntity).environment(\.managedObjectContext, viewContext)) {
            GeometryReader { geometry in
                ZStack{
                    ForEach(staticCards, id: \.order) { card in
                        VStack(alignment: .leading, spacing: 0) {
                        }
                        .frame(width: geometry.size.width*widthMultiplier*0.75, height: geometry.size.height*2.2)
                        .background(card.color)
                        .cornerRadius(15)
                        .offset(x: card.order*30, y: 0)
                        .shadow(color: Color(red: 0.13, green: 0.15, blue: 0.22, opacity: 0.60), radius: 9, x: 12)
                        
                        VStack(alignment: .leading) {
                            if (card.order == 0) {
                                VStack(alignment: .leading){
                                    Image(systemName: getIcon(taskType: (itemsRemaining ? firstIncompleteTask!.taskType : "book")))
                                        .foregroundColor(itemsRemaining ? card.color : Color.gray)
                                        .font(.system(size: 45*heightMultiplier))
                                        .padding(.bottom, 10*heightMultiplier)
                                    
                                    Text("\(itemsRemaining ? firstIncompleteTask!.taskTitle : "No remaining items")")
                                        .font(Font.custom("Poppins", size: 16*heightMultiplier).weight(.medium))
                                        .foregroundColor(itemsRemaining ? Color.white : Color.gray)
                                        .padding(.bottom, 7*heightMultiplier)
                                    
                                    if (itemsRemaining){
                                        Text("Due today: \(Int(firstIncompleteTask!.estimatedTime)) minutes")
                                            .font(Font.custom("Poppins", size: 13*heightMultiplier).weight(.semibold))
                                            .foregroundColor(Color.subtitle)
                                            .padding(.bottom, 5*heightMultiplier)
                                    }
                                    
                                }.padding(.leading, -20)
                            }
                        }
                        .frame(width: geometry.size.width*widthMultiplier*0.75, height:geometry.size.height*2.2)
                        .background(Color.customMediumGrey)
                        .cornerRadius(15)
                        .offset(x: card.order*30 - 4, y: 0)
                        .overlay(
                            RoundedRectangle(cornerRadius: 15)
                                .inset(by: 2.50)
                                .stroke(card.color, lineWidth: 0)
                        )
                    }
                }
                .padding(.top, -35*(heightMultiplier))
            }
        }
        
    }
}
