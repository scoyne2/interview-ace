import SwiftUI
import CoreData


struct MyTasksHeader: View {
    let heightMultiplier: CGFloat
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        ZStack {
            VStack {
                HStack() {
                    Button(action: {
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        HStack(spacing: 8) {
                            
                            Image(systemName: "arrow.left")
                                .foregroundColor(.white)
                                .font(.system(size: 15))
                                .padding(15)
                                .frame(width: 38, height: 38)
                                .background(Color.customMediumGrey)
                                .cornerRadius(5)
                            Spacer()
                            
                        }
                    }
                    .navigationBarBackButtonHidden(true)
                    
                    Spacer()
                    
                }
                HStack() {
                    
                    Spacer()
                    
                    Text("My Tasks")
                        .font(Font.custom("Poppins", size: 20).weight(.bold))
                        .foregroundColor(.white)
                    
                    Spacer()
                }
            }
        }
    }
}
