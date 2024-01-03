import SwiftUI

@main
struct InterviewAceApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

    let persistenceController = PersistenceController.shared
    
    // This state will control whether the tutorial is showing or not
    @State private var isShowingTutorial = !UserDefaultsHelper.hasShownTutorial
    
    var body: some Scene {
        WindowGroup {
            NavigationView {
                ZStack {
                    // Show tutorial on first load
                    if isShowingTutorial {
                        TutorialView(isShowing: $isShowingTutorial)
                    } else {
                        
                        HomeScreenView()
                            .environment(\.managedObjectContext, persistenceController.container.viewContext)
                        
                    }
                }
            }
        }
    }
}
