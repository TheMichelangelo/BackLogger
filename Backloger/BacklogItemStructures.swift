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
    
    init(task: String){
        self.id = UUID()
        self.task = task
        self.complete = false
    }
    
    init(){
        self.id = UUID()
        self.task = "task"
        self.complete = false
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
    
    init(){
        bookItems=BacklogList()
        comicsItems=BacklogList()
        playstationGameItems=BacklogList()
        xboxGameItems=BacklogList()
        switchGameItems=BacklogList()
        pcGameItems=BacklogList()
        activityItems=BacklogList()
    }
}

struct ActivityBacklogItem: Identifiable, Codable{
    let id: UUID
    let task: String
    let complete: Bool
    
    init(task: String){
        self.id = UUID()
        self.task=task
        self.complete = false
    }
}

struct DayActivityBacklogList : Codable{
    let currentItem: Date
    let items: [ActivityBacklogItem]
}

struct ActivityBacklogListAll : Codable{
    let days: [DayActivityBacklogList]
}


struct BuyBacklogItem : Identifiable, Codable{
    let id: UUID
    let task: String
    let price: Int
    let complete: Bool
    
    init(task: String){
        self.id = UUID()
        self.task=task
        self.price=0
        self.complete = false
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
