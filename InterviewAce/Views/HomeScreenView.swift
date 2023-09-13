import SwiftUI
import CoreData

struct HomeScreenView: View {
    @Environment(\.managedObjectContext) private var viewContext
    
    @FetchRequest(
        sortDescriptors: [],
        animation: .default)
    private var items: FetchedResults<ProgressEntity>
    
    @FetchRequest(
        sortDescriptors: [],
        animation: .default)
    private var streakTrackers: FetchedResults<StreakTrackerEntity>
    
    let screenHeight = UIScreen.main.bounds.height
    let screenWidth = UIScreen.main.bounds.width
    
    var heightMultiplier: CGFloat {
        switch screenHeight {
        case ..<680:
            return 0.65
        case ..<850:
            return 0.8
        default:
            return 1
        }
    }
    
    var widthMultiplier: CGFloat {
        switch screenWidth {
        case ..<376:
            return 0.87
        case ..<391:
            return 0.91
        default:
            return 1
        }
    }
    
    
    var body: some View {
        if let progress = items.first {
            ZStack {
                Color(red: 0.13, green: 0.15, blue: 0.22).edgesIgnoringSafeArea(.all)
                VStack(alignment: .leading) {
                    // Title and subtitle
                    AppBanner(heightMultiplier: heightMultiplier)
                        .padding(.leading, 30)
                        .padding(.trailing, 30)
                        .padding(.top, 50)
                    
                    // Today's Tasks + progress + card preview
                    TodaysTasksSection(heightMultiplier: heightMultiplier, widthMultiplier: widthMultiplier, currentProgress:progress, streakTrackerEntity: streakTrackers.first!).environment(\.managedObjectContext, viewContext)
                        .padding(.leading, 30)
                        .padding(.trailing, 30)
                        .padding(.top, 20)
                    
                    // Streak
                    Streak(heightMultiplier: heightMultiplier, currentProgress: progress, streakTrackerEntity: streakTrackers.first!).environment(\.managedObjectContext, viewContext)
                        .padding(.leading, 30)
                        .padding(.trailing, 30)
                        .padding(.top, 90*heightMultiplier)
                    
                    // Progress chart + Time Spent
                    HStack{
                        ProgressChart(heightMultiplier: heightMultiplier, currentProgress: progress, streakTrackerEntity: streakTrackers.first!).environment(\.managedObjectContext, viewContext)
                        
                        TimeSpent(heightMultiplier: heightMultiplier, timeSpent: Int(progress.totalTimeInvested))
                    }
                    .padding(.leading, 30)
                    .padding(.trailing, 30)
                    .padding(.top, heightMultiplier == 1 ? -30 : -40*heightMultiplier)
                }
            }
        }
    }
}

struct HomeScreenView_Previews: PreviewProvider {
    static var previews: some View {
        HomeScreenView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
