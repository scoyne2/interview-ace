import Foundation
import CoreData
import SwiftUI
import UserNotifications

func getColor(taskType: String) -> Color {
    switch taskType {
    case "misc":
        return Color.customBlue
    case "python":
        return Color.customOrange
    case "sql":
        return Color.customPurple
    case "data-modeling":
        return Color.customYellow
    case "system-design":
        return Color.customGreenLight
    case "behavioral":
        return Color.customPurple
    case "product-sense":
        return Color.customBlue
    default:
        return Color.gray
    }
}

func getIcon(taskType: String) -> String {
    switch taskType {
    case "misc":
        return "gear"
    case "python":
        return "laptopcomputer"
    case "sql":
        return "laptopcomputer"
    case "data-modeling":
        return "pc"
    case "system-design":
        return "map"
    case "behavioral":
        return "person"
    case "product-sense":
        return "cart"
    default:
        return "gear"
    }
}

func setBadgeCount(count: Int) {
    UIApplication.shared.applicationIconBadgeNumber = count
}
