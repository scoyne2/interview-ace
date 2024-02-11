import SwiftUI

struct AllTasksView: View {
    @State private var showMenu = false
    let heightMultiplier: CGFloat
    let widthMultiplier: CGFloat
    @ObservedObject var currentProgress: ProgressEntity
    @ObservedObject var streakTrackerEntity : StreakTrackerEntity
    @Environment(\.managedObjectContext) private var viewContext
    
    var body: some View {
        ZStack {
            Color(red: 0.13, green: 0.15, blue: 0.22).edgesIgnoringSafeArea(.all)
            
            // Menu
            VStack{
                SideMenu(showMenu: $showMenu, heightMultiplier: heightMultiplier, widthMultiplier: widthMultiplier, currentProgress: currentProgress, streakTrackerEntity: streakTrackerEntity)
                Spacer()
            }.zIndex(99)
            
            VStack(alignment: .leading) {
                // Header
                HStack() {
                    
                    Spacer()
                    
                    Text("All Tasks")
                        .font(Font.custom("Poppins", size: 20).weight(.bold))
                        .foregroundColor(.white)
                    
                    Spacer()
                }.padding(.bottom)
                    .padding(.top)
                
                Spacer()
                
                // Cards Slider
                AllTasksSlider(heightMultiplier: heightMultiplier, widthMultiplier:widthMultiplier, currentProgress: currentProgress, streakTrackerEntity: streakTrackerEntity).environment(\.managedObjectContext, viewContext)
            }
        } .navigationBarBackButtonHidden(true)
    }
}
