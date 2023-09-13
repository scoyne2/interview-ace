import SwiftUI
import CoreData

struct TimeSpent: View {
    let heightMultiplier: CGFloat
    let timeSpent: Int
    
    var body: some View {
        GeometryReader { geometry in
            VStack(alignment: .leading) {
                Text("Time Spent")
                    .font(Font.custom("Poppins", size: 18).weight(.bold))
                    .foregroundColor(.white)
                
                ZStack{
                    RoundedRectangle(cornerRadius: 15)
                        .stroke(Color(red: 0.21, green: 0.24, blue: 0.32), lineWidth: 2)
                        .background(
                            LinearGradient(gradient: Gradient(colors: [Color(red: 0.17, green: 0.20, blue: 0.27), Color(red: 0.17, green: 0.20, blue: 0.27).opacity(0)]), startPoint: .topLeading, endPoint: .bottomTrailing)
                        ).cornerRadius(15)
                    Text("\(timeSpent/60)")
                        .font(Font.custom("Poppins", size: 60*heightMultiplier).weight(.semibold))
                        .foregroundColor(.white)
                        .offset(x: 0, y: -20)
                    Text("Hours")
                        .font(Font.custom("Poppins", size: 11).weight(.medium))
                        .foregroundColor(Color(red: 0.47, green: 0.53, blue: 0.67))
                        .offset(x: -10, y: 25)
                }.frame(width: geometry.size.width*0.60, height:  geometry.size.height*0.65)
            }.offset(x:80, y:5)
        }
    }
}
