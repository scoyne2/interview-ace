import SwiftUI

struct SideMenu: View {
    @Binding var showMenu: Bool
    let heightMultiplier: CGFloat
    let widthMultiplier: CGFloat
    @ObservedObject var currentProgress: ProgressEntity
    @ObservedObject var streakTrackerEntity : StreakTrackerEntity
    
    var body: some View {
        HStack() {
            Spacer()
            
            Button(action: {
                withAnimation {
                    showMenu.toggle()
                }
            }) {
                HStack(spacing: 8) {
                    Spacer()
                    Image(systemName: "list.dash")
                        .foregroundColor(.white)
                        .font(.system(size: 15))
                        .padding(15)
                        .frame(width: 38, height: 38)
                        .background(Color.customMediumGrey)
                        .cornerRadius(5)
                }
            }
        }
        
        if showMenu {
            SideMenuView(showMenu: $showMenu, heightMultiplier: heightMultiplier, widthMultiplier:widthMultiplier, currentProgress:currentProgress, streakTrackerEntity:streakTrackerEntity)
                .transition(.move(edge: .trailing))
                .zIndex(99)
        }
    }
    
}
