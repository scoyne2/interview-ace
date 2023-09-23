import SwiftUI


struct ResourcesView: View {
    
    @State private var showMenu = false
    let heightMultiplier: CGFloat
    let widthMultiplier: CGFloat
    @ObservedObject var currentProgress: ProgressEntity
    @ObservedObject var streakTrackerEntity : StreakTrackerEntity
    
    var body: some View {
        ZStack {
            Color(red: 0.13, green: 0.15, blue: 0.22).edgesIgnoringSafeArea(.all)
            // Menu
            VStack{
                SideMenu(showMenu: $showMenu, heightMultiplier: heightMultiplier, widthMultiplier: widthMultiplier, currentProgress: currentProgress, streakTrackerEntity: streakTrackerEntity)
                Spacer()
            }.zIndex(99)
            
            VStack(alignment: .leading, spacing: 20) {
                
                HStack() {
                    
                    Spacer()
                    
                    Text("Resources")
                        .font(Font.custom("Poppins", size: 20).weight(.bold))
                        .foregroundColor(.white)
                    
                    Spacer()
                }.padding(.bottom)
                    .padding(.top)
                
                Link(destination: URL(string: "https://medium.com/@seancoyne/cracking-the-data-engineering-resume-8afa9ec101b8")!) {
                    HStack(spacing: 20){
                        Image(systemName: "doc")
                            .resizable()
                            .renderingMode(.template)
                            .foregroundColor(.white)
                            .frame(width: 20, height: 20)
                            .padding(.leading)
                        
                        Text("Resume Optimization")
                            .font(Font.custom("Poppins", size: 15).weight(.bold))
                            .foregroundColor(.white)
                    }
                }
                
                Link(destination: URL(string: "https://medium.com/@seancoyne/linkedin-profile-tips-for-data-engineers-part-2-886467ba4b2d")!) {
                    HStack(spacing: 20){
                        Image(systemName: "doc")
                            .resizable()
                            .renderingMode(.template)
                            .foregroundColor(.white)
                            .frame(width: 20, height: 20)
                            .padding(.leading)
                        Text("LinkedIn Keyword Optimization")
                            .font(Font.custom("Poppins", size: 15).weight(.bold))
                            .foregroundColor(.white)
                    }
                }
                
                Link(destination: URL(string: "https://codingbat.com/python")!) {
                    HStack(spacing: 20){
                        Image(systemName: "gear")
                            .resizable()
                            .renderingMode(.template)
                            .foregroundColor(.white)
                            .frame(width: 20, height: 20)
                            .padding(.leading)
                        Text("Easy Python Practice")
                            .font(Font.custom("Poppins", size: 15).weight(.bold))
                            .foregroundColor(.white)
                    }
                }
                
                Link(destination: URL(string: "https://medium.com/@seancoyne/what-leetcode-questions-should-a-data-engineer-practice-9ef7cbf0fc11")!) {
                    HStack(spacing: 20){
                        Image(systemName: "gear")
                            .resizable()
                            .renderingMode(.template)
                            .foregroundColor(.white)
                            .frame(width: 20, height: 20)
                            .padding(.leading)
                        Text("Medium Python Practice")
                            .font(Font.custom("Poppins", size: 15).weight(.bold))
                            .foregroundColor(.white)
                    }
                }
                
                Link(destination: URL(string: "https://medium.com/@seancoyne/what-is-big-o-notation-o-n-time-and-space-complexity-841367face05")!) {
                    HStack(spacing: 20){
                        Image(systemName: "book.closed")
                            .resizable()
                            .renderingMode(.template)
                            .foregroundColor(.white)
                            .frame(width: 20, height: 20)
                            .padding(.leading)
                        Text("Big O Notation")
                            .font(Font.custom("Poppins", size: 15).weight(.bold))
                            .foregroundColor(.white)
                    }
                }
                
                Link(destination: URL(string: "https://www.udemy.com/course/sql-101-a-beginners-guide-to-sql/learn/practice/1146630#overview")!) {
                    HStack(spacing: 20){
                        Image(systemName: "display")
                            .resizable()
                            .renderingMode(.template)
                            .foregroundColor(.white)
                            .frame(width: 20, height: 20)
                            .padding(.leading)
                        Text("SQL 101")
                            .font(Font.custom("Poppins", size: 15).weight(.bold))
                            .foregroundColor(.white)
                    }
                }
                
                Link(destination: URL(string: "https://www.hackerrank.com/domains/sql")!) {
                    HStack(spacing: 20){
                        Image(systemName: "display")
                            .resizable()
                            .renderingMode(.template)
                            .foregroundColor(.white)
                            .frame(width: 20, height: 20)
                            .padding(.leading)
                        Text("SQL Practice")
                            .font(Font.custom("Poppins", size: 15).weight(.bold))
                            .foregroundColor(.white)
                    }
                }
                
                Link(destination: URL(string: "https://www.educative.io/blog/complete-guide-to-system-design")!) {
                    HStack(spacing: 20){
                        Image(systemName: "server.rack")
                            .resizable()
                            .renderingMode(.template)
                            .foregroundColor(.white)
                            .frame(width: 20, height: 20)
                            .padding(.leading)
                        Text("System Design Overview")
                            .font(Font.custom("Poppins", size: 15).weight(.bold))
                            .foregroundColor(.white)
                    }
                }
                
                
                Link(destination: URL(string: "https://eczachly.substack.com/p/how-to-pass-the-data-modeling-round")!) {
                    HStack(spacing: 20){
                        Image(systemName: "tablecells")
                            .resizable()
                            .renderingMode(.template)
                            .foregroundColor(.white)
                            .frame(width: 20, height: 20)
                            .padding(.leading)
                        Text("Data Modeling")
                            .font(Font.custom("Poppins", size: 15).weight(.bold))
                            .foregroundColor(.white)
                    }
                }
                
                Spacer()
                
            }
        }.navigationBarBackButtonHidden(true)
    }
}
