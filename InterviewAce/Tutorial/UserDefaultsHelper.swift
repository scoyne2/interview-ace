import Foundation

struct UserDefaultsHelper {
    static let hasShownTutorialKey = "hasShownTutorial"
    
    static var hasShownTutorial: Bool {
        get {
            return UserDefaults.standard.bool(forKey: hasShownTutorialKey)
        }
        set {
            UserDefaults.standard.set(newValue, forKey: hasShownTutorialKey)
        }
    }
}
