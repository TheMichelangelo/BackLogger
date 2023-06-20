//
//  BackLogItem.swift
//  Backloger
//
//  Created by Mike Pastula on 19.06.2023.
//

import Foundation

struct BacklogItem : Identifiable, Codable{
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
}

struct BacklogList : Codable{
    var currentItem: BacklogItem
    var items: [BacklogItem]
    
    init(){
        currentItem=BacklogItem()
        items=[]
    }
}

struct BacklogListAll : Codable{
    var bookItems: BacklogList
    var comicsItems: BacklogList
    var playstationGameItems: BacklogList
    var xboxGameItems: BacklogList
    var switchGameItems: BacklogList
    var pcGameItems: BacklogList
    var activityItems: BacklogList
    var legoItems: BacklogList
    
    init(){
        bookItems=BacklogList()
        comicsItems=BacklogList()
        playstationGameItems=BacklogList()
        xboxGameItems=BacklogList()
        switchGameItems=BacklogList()
        pcGameItems=BacklogList()
        activityItems=BacklogList()
        legoItems=BacklogList()
    }
}

//---------DAY ACTIVITY-------------------
struct ActivityBacklogItem: Identifiable, Codable, Hashable{
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
}

struct DayActivityBacklogList : Codable{
    var currentDate: Date
    var items: [ActivityBacklogItem]
    
    init(){
        self.currentDate = Date()
        self.items = [ActivityBacklogItem]()
    }
    
    init(items: [ActivityBacklogItem]){
        self.currentDate = Date()
        self.items = [ActivityBacklogItem]()
    }
}

struct ActivityBacklogListAll : Codable{
    var days: [DayActivityBacklogList]
    
    init(){
        self.days = [DayActivityBacklogList]()
    }
}

//TODO use in future if develipment will continue
struct BuyBacklogItem : Identifiable, Codable{
    let id: UUID
    let task: String
    let price: Int
    let complete: Bool
    var dateAdded: Date
    
    init(task: String){
        self.id = UUID()
        self.task=task
        self.price=0
        self.complete = false
        self.dateAdded = Date()
    }
}

struct BuyBacklogList : Codable{
    let items: [BuyBacklogItem]
}

struct BuyBacklogListAll : Codable{
    let bookItems: [BacklogList]
    let comicsItems: [BacklogList]
    let gameItems: [BacklogList]
    let activityItems: [BacklogList]
}

enum CompleteCategory: String, CaseIterable, Identifiable {
    case completed, uncompleted
    
    var id: Self { self }
}
