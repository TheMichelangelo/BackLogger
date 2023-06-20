//
//  DayView.swift
//  Backloger
//
//  Created by Mike Pastula on 19.06.2023.
//

import SwiftUI

struct DayView: View {
    @State private var totalProgress: Float
    @State private var newTask: String = ""
    @State private var completedCategory: CompleteCategory = .uncompleted
    @State private var backlogList: ActivityBacklogListAll
    @State private var currentBacklogList: DayActivityBacklogList
    @State private var isExpanded = false
    
    init() {
        _totalProgress = State(initialValue: 1.0)
        _newTask = State(initialValue: "")
        _currentBacklogList = State(initialValue: DayActivityBacklogList())
        _backlogList = State(initialValue: ActivityBacklogListAll())
        if let data = UserDefaults.standard.data(forKey: "activityBacklogList") {
            let decoder = JSONDecoder()
            if let decodedTasks = try? decoder.decode(ActivityBacklogListAll.self, from: data) {
                _backlogList = State(initialValue: decodedTasks)
            } else {
                _backlogList = State(initialValue: ActivityBacklogListAll())
            }
        } else {
            _backlogList = State(initialValue: ActivityBacklogListAll())
        }
        if _backlogList.wrappedValue.days.isEmpty{
            let activityBaklogItem = DayActivityBacklogList()
            backlogList.days.append(activityBaklogItem)
            _currentBacklogList = State(initialValue: activityBaklogItem)
        }else {
            let currentDate = Date()
            let isItemWithCurrentDateExists = backlogList.days.contains { dayActivity in
                Calendar.current.isDate(dayActivity.currentDate, inSameDayAs: currentDate)
            }

            if isItemWithCurrentDateExists {
                for dayActivity in backlogList.days {
                    if Calendar.current.isDate(dayActivity.currentDate, inSameDayAs: currentDate) {
                        _currentBacklogList = State(initialValue: dayActivity)
                    }
                }
            } else {
                let previousDayActivity  = backlogList.days.first!
                let activities = previousDayActivity.items.filter{ $0.complete == false }
                let activityBacklogItem = DayActivityBacklogList(items: activities)
                _currentBacklogList = State(initialValue: activityBacklogItem)
                backlogList.days.append(activityBacklogItem)
                backlogList.days.sort { (item1, item2) -> Bool in
                    return item1.currentDate > item2.currentDate
                }
            }
        }
    }
    
    var body: some View {
        VStack {
            ZStack {
                LinearGradient(colors: [.red, .blue], startPoint: .top, endPoint: .bottom)
                    .ignoresSafeArea()
                VStack {
                    Text("My Activity List")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .padding(.top, 1)
                        .foregroundColor(.white.opacity(0.7))
                    HStack{
                            TextField("New activity",text: $newTask)
                                    .padding(.all)
                                    .background(.regularMaterial)
                                    .cornerRadius(25)
                                    .accentColor(.red)
                            Button(action:addTask){
                            Text("Add").foregroundColor(.white.opacity(0.7))
                        }.buttonStyle(.bordered)
                    }.padding(.bottom, 45)
                }
            }
            .frame(height: 200)
            
            VStack {
  
                Text("Created by @mpast")
                    .font(.title2)
                    .foregroundColor(.orange)
            }
        }
    }

    func changeCompleteCategory() {
        /*switch completedCategory {
        case .uncompleted:
            //backlogItemsList = currentSelectedBacklog.items.filter{ $0.complete == false }
        case .completed:
            //backlogItemsList = currentSelectedBacklog.items.filter{ $0.complete == true }
        }*/
    }
    
    func addTask() {
        guard !newTask.isEmpty else {
            return
        }
        
        /*let newItem = BacklogItem(task: newTask)
        if currentSelectedBacklog.items.isEmpty{
            currentSelectedBacklog.items.append(newItem)
        }else{
            currentSelectedBacklog.items.insert(newItem, at: 1)
        }
        saveCategory()
        saveItems()
        changeCompleteCategory()
        newTask = ""*/
    }
    
    func removeTask(_ item: BacklogItem) {
        
        /*currentSelectedBacklog.items.removeAll { $0.id == item.id }
        saveCategory()
        saveItems()
        changeCompleteCategory()*/
    }
    
    func completeTask(_ item: BacklogItem) {
        /*for i in 1 ..< currentSelectedBacklog.items.count {
            if currentSelectedBacklog.items[i].id == item.id{
                currentSelectedBacklog.items[i].complete=true
                currentSelectedBacklog.items[i].dateCompleted = Date()
            }
        }
        if currentSelectedBacklog.currentItem.id == item.id{
            setRandomItem()
        }
        changeCompleteCategory()
        saveCategory()
        saveItems()*/
    }
    
    func saveItems() {
        if let encoded = try? JSONEncoder().encode(backlogList) {
            UserDefaults.standard.set(encoded, forKey: "activityBacklogList")
        }
    }
}

struct DayView_Previews: PreviewProvider {
    static var previews: some View {
        DayView()
    }
}
