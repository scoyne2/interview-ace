import SwiftUI
import CoreData

let persistenceController = PersistenceController.shared

struct SideMenuView: View {
    @Binding var showMenu: Bool
    
    let heightMultiplier: CGFloat
    let widthMultiplier: CGFloat
    @ObservedObject var currentProgress: ProgressEntity
    @ObservedObject var streakTrackerEntity : StreakTrackerEntity
    
    @Environment(\.managedObjectContext) private var viewContext
    
    var body: some View {
        HStack {
            Spacer()
            ZStack{
                Rectangle()
                    .fill(Color(red: 0.13, green: 0.15, blue: 0.22).opacity(0.8))
                    .frame(width: 200)
                    .shadow(color: .black.opacity(0.1), radius: 5, x: 0, y: 3)
                
                VStack(alignment: .leading, spacing: 0) {
                    TitleView()
                        .frame(height: 140)
                        .padding(.bottom, 30)
                    
                    
                    // Home
                    NavigationLink(destination: HomeScreenView().environment(\.managedObjectContext, persistenceController.container.viewContext)) {
                        HStack(spacing: 20){
                            Image(systemName: "house")
                                .resizable()
                                .renderingMode(.template)
                                .foregroundColor(.white)
                                .frame(width: 22, height: 22)
                                .padding(.leading)
                            
                            Text("Home")
                                .font(Font.custom("Poppins", size: 14).weight(.regular))
                                .foregroundColor(.white)
                            
                            Spacer()
                            
                            Rectangle()
                                .fill(.white)
                                .frame(width: 5)
                        }.frame(height: 50)
                    }
                    .buttonStyle(PlainButtonStyle())
                    
                    // Today's Tasks
                    NavigationLink(destination: MyTasksView(heightMultiplier: heightMultiplier, widthMultiplier: widthMultiplier, currentProgress: currentProgress, streakTrackerEntity: streakTrackerEntity).environment(\.managedObjectContext, viewContext)) {
                        HStack(spacing: 20){
                            
                            Image(systemName: "checklist")
                                .resizable()
                                .renderingMode(.template)
                                .foregroundColor(.white)
                                .frame(width: 22, height: 22)
                                .padding(.leading)
                            
                            Text("Today's Tasks")
                                .font(Font.custom("Poppins", size: 14).weight(.regular))
                                .foregroundColor(.white)
                            
                            Spacer()
                            
                            Rectangle()
                                .fill(.white)
                                .frame(width: 5)
                            
                        }.frame(height: 50)
                    }
                    .buttonStyle(PlainButtonStyle())
                    
                    
                    // Resources
                    NavigationLink(destination: ResourcesView(heightMultiplier: heightMultiplier, widthMultiplier: widthMultiplier, currentProgress: currentProgress, streakTrackerEntity: streakTrackerEntity).environment(\.managedObjectContext, viewContext)) {
                        HStack(spacing: 20){
                            Image(systemName: "book.closed")
                                .resizable()
                                .renderingMode(.template)
                                .foregroundColor(.white)
                                .frame(width: 22, height: 22)
                                .padding(.leading)
                            Text("Resources")
                                .font(Font.custom("Poppins", size: 14).weight(.regular))
                                .foregroundColor(.white)
                            
                            Spacer()
                            
                            Rectangle()
                                .fill(.white)
                                .frame(width: 5)
                            
                        }.frame(height: 50)
                    }
                    .buttonStyle(PlainButtonStyle())
                    
                    // All Tasks
                    NavigationLink(destination: AllTasksView(heightMultiplier: heightMultiplier, widthMultiplier: widthMultiplier, currentProgress: currentProgress, streakTrackerEntity: streakTrackerEntity).environment(\.managedObjectContext, viewContext)) {
                        HStack(spacing: 20){
                            
                            Image(systemName: "checklist.unchecked")
                                .resizable()
                                .renderingMode(.template)
                                .foregroundColor(.white)
                                .frame(width: 22, height: 22)
                                .padding(.leading)
                            
                            Text("All Tasks")
                                .font(Font.custom("Poppins", size: 14).weight(.regular))
                                .foregroundColor(.white)
                            
                            Spacer()
                            
                            Rectangle()
                                .fill(.white)
                                .frame(width: 5)
                            
                        }.frame(height: 50)
                    }
                    .buttonStyle(PlainButtonStyle())
                    
                    
                    
                    Spacer()
                }
                .padding(.top, 20)
                .frame(width: 200)
                .background(Color(red: 0.13, green: 0.15, blue: 0.22))
            }
        }
        .background(.clear)
    }
    
    func TitleView() -> some View{
        VStack(alignment: .center){
            HStack{
                Spacer()
                Image("logo")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 100, height: 100)
                    .cornerRadius(50)
                Spacer()
            }
            
            Text("Menu")
                .font(Font.custom("Poppins", size: 18).weight(.bold))
                .foregroundColor(.white)
        }
    }
    
}
