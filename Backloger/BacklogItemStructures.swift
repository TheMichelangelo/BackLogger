//
//  BackLogItem.swift
//  Backloger
//
//  Created by Mike Pastula on 19.06.2023.
//

import Foundation

class BacklogItem : Identifiable, Codable, Hashable, ObservableObject{
    var id: UUID
    var task: String
    var complete: Bool
    var dateAdded: Date
    var dateCompleted: Date
    
    init(task: String){
        self.id = UUID()
        self.task = task
        self.complete = false
        self.dateAdded = Date()
        self.dateCompleted = Date()
    }
    
    init(){
        self.id = UUID()
        self.task = "task"
        self.complete = false
        self.dateAdded = Date()
        self.dateCompleted = Date()
    }
    
    static func == (lhs: BacklogItem, rhs: BacklogItem) -> Bool {
        return lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
            hasher.combine(id)
            hasher.combine(task)
    }
}

class BacklogList : Codable, Hashable, ObservableObject{
    var currentItem: BacklogItem
    var items: [BacklogItem]
    
    init(){
        currentItem=BacklogItem()
        items=[]
    }
    
    static func == (lhs: BacklogList, rhs: BacklogList) -> Bool {
        return lhs.currentItem == rhs.currentItem && lhs.items == rhs.items
    }
    
    func hash(into hasher: inout Hasher) {
            hasher.combine(currentItem)
            hasher.combine(items)
    }
}

class BacklogListAll : Codable, Hashable, ObservableObject{
    var bookItems: BacklogList
    var comicsItems: BacklogList
    var playstationGameItems: BacklogList
    var xboxGameItems: BacklogList
    var switchGameItems: BacklogList
    var pcGameItems: BacklogList
    var activityItems: BacklogList
    
    init(){
        bookItems=BacklogList()
        comicsItems=BacklogList()
        playstationGameItems=BacklogList()
        xboxGameItems=BacklogList()
        switchGameItems=BacklogList()
        pcGameItems=BacklogList()
        activityItems=BacklogList()
    }
    
    static func == (lhs: BacklogListAll, rhs: BacklogListAll) -> Bool {
        return lhs.bookItems == rhs.bookItems && lhs.comicsItems == rhs.comicsItems
        && lhs.playstationGameItems == rhs.playstationGameItems && lhs.activityItems == rhs.activityItems
    }
    
    static func loadFromStorage() -> BacklogListAll {
        if let data = UserDefaults.standard.data(forKey: "backlogList") {
            let decoder = JSONDecoder()
            if let decodedTasks = try? decoder.decode(BacklogListAll.self, from: data) {
                return decodedTasks
            }
            return BacklogListAll()
        }
        return BacklogListAll()
    }
    
    static func saveToStorage(backlogList: BacklogListAll){
        if let encoded = try? JSONEncoder().encode(backlogList) {
            UserDefaults.standard.set(encoded, forKey: "backlogList")
        }
    }
    
    func hash(into hasher: inout Hasher) {
            hasher.combine(bookItems)
            hasher.combine(comicsItems)
    }
}

//---------DAY ACTIVITY-------------------
class ActivityBacklogItem: Identifiable, Codable, Hashable, ObservableObject{
    var id: UUID
    var task: String
    var complete: Bool
    var dateAdded: Date
    
    init(task: String){
        self.id = UUID()
        self.task=task
        self.complete = false
        self.dateAdded = Date()
    }
    
    static func == (lhs: ActivityBacklogItem, rhs: ActivityBacklogItem) -> Bool {
        return lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
            hasher.combine(id)
            hasher.combine(task)
    }
}

class DayActivityBacklogList : Codable, Hashable, ObservableObject{
    var currentDate: Date
    var items: [ActivityBacklogItem]
    
    init(){
        self.currentDate = Date()
        self.items = [ActivityBacklogItem]()
    }
    
    init(items: [ActivityBacklogItem]){
        self.currentDate = Date()
        self.items = items
    }
    
    static func == (lhs: DayActivityBacklogList, rhs: DayActivityBacklogList) -> Bool {
        return lhs.currentDate == rhs.currentDate
    }
    
    func hash(into hasher: inout Hasher) {
            hasher.combine(currentDate)
            hasher.combine(items)
    }
}

class ActivityBacklogListAll : Codable, Hashable, ObservableObject{
    var days: [DayActivityBacklogList]
    
    init(){
        self.days = [DayActivityBacklogList]()
    }
    
    static func == (lhs: ActivityBacklogListAll, rhs: ActivityBacklogListAll) -> Bool {
        return lhs.days == rhs.days
    }
    
    func hash(into hasher: inout Hasher) {
            hasher.combine(days)
    }
    
    static func loadFromStorage() -> ActivityBacklogListAll {
        if let data = UserDefaults.standard.data(forKey: "activityBacklogList") {
            let decoder = JSONDecoder()
            if let decodedTasks = try? decoder.decode(ActivityBacklogListAll.self, from: data) {
                return decodedTasks
            }
            return ActivityBacklogListAll()
        }
        return ActivityBacklogListAll()
    }
    
    static func saveToStorage(backlogList: ActivityBacklogListAll){
        if let encoded = try? JSONEncoder().encode(backlogList) {
            UserDefaults.standard.set(encoded, forKey: "activityBacklogList")
        }
    }
}

enum CompleteCategory: String, CaseIterable, Identifiable {
    case completed, uncompleted
    
    var id: Self { self }
}

enum Category: String, CaseIterable, Identifiable {
    case games_playstation, games_xbox, games_switch, games_windows, comics, books, activities
    var id: Self { self }
}
