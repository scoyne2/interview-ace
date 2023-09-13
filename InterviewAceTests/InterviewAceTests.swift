import Foundation
import CoreData
import SwiftUI
import XCTest
@testable import InterviewAce

final class InterviewAceTests: XCTestCase {
    
    func makeTestContainer() -> NSPersistentContainer {
        let container: NSPersistentContainer
        container = NSPersistentContainer(name: "CrackingTheDataEngineeringInterview")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        container.viewContext.automaticallyMergesChangesFromParent = true
        return container
    }
    
    func testFetchTasksScheduledForDay() throws {
        let container = makeTestContainer()
        SeedInitialData(container: container)
        
        let context = container.viewContext
        
        let actual = fetchTasksScheduledForDay(container: container, day: 1)
        
        let expectedItem1 = TaskEntity(context: context)
        expectedItem1.estimatedTime = 30
        expectedItem1.isCompleted = false
        expectedItem1.isLink = false
        expectedItem1.link = ""
        expectedItem1.taskDescription = "Make a rough draft of your resume\nfocusing on format and sections."
        expectedItem1.taskTitle = "Refresh Resume (1 of 2)"
        expectedItem1.taskId = 1
        expectedItem1.taskType = "misc"
        expectedItem1.dayScheduled = 1
        
        let expectedItem2 = TaskEntity(context: context)
        expectedItem2.estimatedTime = 30
        expectedItem2.isCompleted = false
        expectedItem2.isLink = true
        expectedItem2.link = "https://codingbat.com/python"
        expectedItem2.taskDescription = "Complete CodingBat Warmup1\nand Warmup2."
        expectedItem2.taskTitle = "Python Practice: Coding Bat"
        expectedItem2.taskId = 2
        expectedItem2.taskType = "python"
        expectedItem2.dayScheduled = 1
        
        let actual1 = actual.filter({ $0.taskId == 1 }).first!
        let actual2 = actual.filter({ $0.taskId == 2 }).first!
        
        XCTAssert(expectedItem1.taskTitle == actual1.taskTitle)
        XCTAssert(expectedItem1.taskDescription == actual1.taskDescription)
        XCTAssert(expectedItem1.taskType == actual1.taskType)
       
        XCTAssert(expectedItem2.taskTitle == actual2.taskTitle)
        XCTAssert(expectedItem2.taskDescription == actual2.taskDescription)
        XCTAssert(expectedItem2.taskType == actual2.taskType)
    }
    
    func testGetColor() {
           XCTAssertEqual(getColor(taskType: "misc"), Color.customBlue)
           XCTAssertEqual(getColor(taskType: "python"), Color.customOrange)
           XCTAssertEqual(getColor(taskType: "sql"), Color.customPurple)
           XCTAssertEqual(getColor(taskType: "data-modeling"), Color.customYellow)
           XCTAssertEqual(getColor(taskType: "system-design"), Color.customGreenLight)
           XCTAssertEqual(getColor(taskType: "behavioral"), Color.customPurple)
           XCTAssertEqual(getColor(taskType: "product-sense"), Color.customBlue)
           XCTAssertEqual(getColor(taskType: "unknownType"), Color.gray)
       }

       func testGetIcon() {
           XCTAssertEqual(getIcon(taskType: "misc"), "gear")
           XCTAssertEqual(getIcon(taskType: "python"), "laptopcomputer")
           XCTAssertEqual(getIcon(taskType: "sql"), "laptopcomputer")
           XCTAssertEqual(getIcon(taskType: "data-modeling"), "pc")
           XCTAssertEqual(getIcon(taskType: "system-design"), "map")
           XCTAssertEqual(getIcon(taskType: "behavioral"), "person")
           XCTAssertEqual(getIcon(taskType: "product-sense"), "cart")
           XCTAssertEqual(getIcon(taskType: "unknownType"), "gear")
       }
}
