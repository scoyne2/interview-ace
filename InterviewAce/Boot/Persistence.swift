import CoreData

struct PersistenceController {
    static let shared = PersistenceController()
    
    static var preview: PersistenceController = {
        let result = PersistenceController(inMemory: true)
        let viewContext = result.container.viewContext
        SeedPreviewData(context: viewContext)
        
        do {
            try viewContext.save()
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
        return result
    }()
    
    let container: NSPersistentContainer
    
    init(inMemory: Bool = false) {
        container = NSPersistentContainer(name: "InterviewAce")
        if inMemory {
            container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
        }
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        container.viewContext.automaticallyMergesChangesFromParent = true
        
        // Call the seeding function after the persistent store has been loaded
        SeedInitialData(container: container)
        
        // Determine todays tasks
        PrepareTodaysTasks(container: container)
        
        // Handle streaks and set todays Activity as 0 if it does not already exist
        PrepareTodaysActivities(container: container)
        
        // Post the users data to the InterviewAce REST Api
        PostUserData(container: container)
    }
}
