import SwiftUI
import CoreData

struct AppBanner: View {
    let heightMultiplier: CGFloat
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text("Achievements")
                .font(Font.custom("Poppins", size: 35).weight(.bold))
                .foregroundColor(.white)
                .padding(.bottom, 5*heightMultiplier)
            Text("Complete all tasks 7 days in a row\nto achieve a streak!")
                .font(Font.custom("Poppins", size: 14).weight(.medium))
                .lineSpacing(4*heightMultiplier)
                .foregroundColor(Color(red: 0.47, green: 0.53, blue: 0.67))
        }
    }
}
