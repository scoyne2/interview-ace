import SwiftUI


struct MyTasksView: View {
    let heightMultiplier: CGFloat
    let widthMultiplier: CGFloat
    @ObservedObject var currentProgress: ProgressEntity
    @ObservedObject var streakTrackerEntity : StreakTrackerEntity
    @Environment(\.managedObjectContext) private var viewContext
    
    var body: some View {
        ZStack {
            Color(red: 0.13, green: 0.15, blue: 0.22).edgesIgnoringSafeArea(.all)
            VStack(alignment: .leading) {
                
                // Header
                MyTasksHeader(heightMultiplier: heightMultiplier)
                
                Spacer()
                
                // Cards Slider
                MyTasksSlider(heightMultiplier: heightMultiplier, widthMultiplier:widthMultiplier, currentProgress: currentProgress, streakTrackerEntity: streakTrackerEntity).environment(\.managedObjectContext, viewContext)
            }
        } .navigationBarBackButtonHidden(true)
    }
}
