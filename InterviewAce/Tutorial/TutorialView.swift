import Foundation
import SwiftUI

struct TutorialView: View {
    @Binding var isShowing: Bool
    
    @State private var selectedTab: Int = 0
    
    var body: some View {
        ZStack {
            Color(red: 0.13, green: 0.15, blue: 0.22).edgesIgnoringSafeArea(.all)
            TabView(selection: $selectedTab) {
                VStack{
                    ZStack{
                        Image("tutorial1")
                            .resizable()
                            .scaledToFit()
                            .frame(width: UIScreen.main.bounds.width*0.9)
                            .padding(.top, -UIScreen.main.bounds.height/12)
                        Text("Stay on track with your preparation in order\nto ace the data engineering interview!")
                            .multilineTextAlignment(.center)
                            .font(Font.custom("Poppins", size: 20).weight(.bold))
                            .foregroundColor(.white)
                            .padding(.top, UIScreen.main.bounds.height/2.5)
                    }
                    Button(action: {
                        selectedTab = 1
                    }){
                        Text("Next")
                            .frame(minWidth: 150, minHeight: 40)
                            .foregroundColor(Color.white)
                    }
                    .background(Color.customGreenLight)
                    .cornerRadius(10)
                }.tag(0)
                
                VStack{
                    ZStack{
                        Image("tutorial2")
                            .resizable()
                            .scaledToFit()
                            .frame(width: UIScreen.main.bounds.width*0.9)
                            .padding(.top, -UIScreen.main.bounds.height/12)
                        Text("Daily tasks help you build the right\nskills, and keep the right pace.")
                            .multilineTextAlignment(.center)
                            .font(Font.custom("Poppins", size: 20).weight(.bold))
                            .foregroundColor(.white)
                            .padding(.top, UIScreen.main.bounds.height/2.5)
                    }
                    Button(action: {
                        selectedTab = 2
                    }){
                        Text("Next")
                            .frame(minWidth: 150, minHeight: 40)
                            .foregroundColor(Color.white)
                    }
                    .background(Color.customGreenLight)
                    .cornerRadius(10)
                    
                }.tag(1)
                
                VStack{
                    ZStack{
                        Image("tutorial3")
                            .resizable()
                            .scaledToFit()
                            .frame(width: UIScreen.main.bounds.width*0.9)
                            .padding(.top, -UIScreen.main.bounds.height/12)
                        Text("Watch your progress through daily\nstreaks and time invested.")
                            .multilineTextAlignment(.center)
                            .font(Font.custom("Poppins", size: 20).weight(.bold))
                            .foregroundColor(.white)
                            .padding(.top, UIScreen.main.bounds.height/2.5)
                    }
                    Button(action: {
                        isShowing = false
                        UserDefaultsHelper.hasShownTutorial = true
                    }){
                        Text("Get Started")
                            .frame(minWidth: 150, minHeight: 40)
                            .foregroundColor(Color.white)
                    }
                    .background(Color.customGreenLight)
                    .cornerRadius(10)
                }.tag(2)
                
            }
            .tabViewStyle(PageTabViewStyle())
            .indexViewStyle(PageIndexViewStyle(backgroundDisplayMode: .always))
        }
    }
}
