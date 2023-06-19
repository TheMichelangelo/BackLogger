//
//  BackLogItem.swift
//  Backloger
//
//  Created by Mike Pastula on 19.06.2023.
//

import Foundation

struct BacklogItem : Identifiable, Codable{
    let id: UUID
    let task: String
    
    init(task: String){
        self.id = UUID()
        self.task=task
    }
}

struct BacklogList : Codable{
    let currentItem: BacklogItem
    let items: [BacklogItem]
}

struct BacklogListAll : Codable{
    let bookItems: [BacklogList]
    let comicsItems: [BacklogList]
    let gameItems: [BacklogList]
    let activityItems: [BacklogList]
}

struct ActivityBacklogItem: Identifiable, Codable{
    let id: UUID
    let task: String
    
    init(task: String){
        self.id = UUID()
        self.task=task
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
    
    init(task: String){
        self.id = UUID()
        self.task=task
        self.price=0
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
