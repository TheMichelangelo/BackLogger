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
                DisclosureGroup(isExpanded: $isExpanded) {
                    let completedItemsCount = currentBacklogList.items.filter { $0.complete }.count
                    let progress = Float(completedItemsCount) / Float(currentBacklogList.items.count)
                    ProgressView(value: progress,total: 1)
                    VStack{
                        List(currentBacklogList.items.filter { !$0.complete }) { item in
                            HStack {
                                Text(item.task).padding(.leading)
                                    .foregroundColor(.green)
                            }
                            .swipeActions(edge: .leading) {
                                Button(role: .destructive) {
                                    removeTask(item)
                                } label: {
                                    Label("Delete item", systemImage: "trash")
                                }
                            }
                            .swipeActions(edge: .trailing) {
                                Button(role: .destructive) {
                                    completeTask(item)
                                } label: {
                                    Label("Complete item", systemImage: "visa")
                                }
                            }
                        }
                        var prevDays = buildDayHistory()
                        ForEach(prevDays, id: \.title) { listItem in
                                        listItem
                                    }
                    }
                } label: {
                    Text("Today")
                        .font(.headline)
                }
                .padding()
                .foregroundColor(.blue)
                .background(Color.gray.opacity(0.2))
                .cornerRadius(8)
                
                //TODO add expandable dropdown lists for every day
                Text("Created by @mpast")
                    .font(.title2)
                    .foregroundColor(.orange)
            }
        }
    }
    
    func buildDayHistory() -> [ExpandableListItemView] {
        var prevDays = [ExpandableListItemView]()
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "YY/MM/dd"

        for i in 1 ..< backlogList.days.count{
            prevDays.append(ExpandableListItemView(
                title: dateFormatter.string(from: backlogList.days[i].currentDate),
                items:backlogList.days[i].items))
        }
        return prevDays
    }
    
    
    func addTask() {
        guard !newTask.isEmpty else {
            return
        }
        
        let newItem = ActivityBacklogItem(task: newTask)
        if currentBacklogList.items.isEmpty{
            currentBacklogList.items.append(newItem)
        }else{
            currentBacklogList.items.insert(newItem, at: 1)
        }
        if backlogList.days.isEmpty{
            backlogList.days.append(currentBacklogList)
        }else{
            backlogList.days[0] = currentBacklogList
        }
        saveItems()
        newTask = ""
    }
    
    func removeTask(_ item: ActivityBacklogItem) {
        currentBacklogList.items.removeAll { $0.id == item.id }
        if backlogList.days.isEmpty{
            backlogList.days.append(currentBacklogList)
        }else{
            backlogList.days[0] = currentBacklogList
        }
        saveItems()
    }
    
    func completeTask(_ item: ActivityBacklogItem) {
        for i in 1 ..< currentBacklogList.items.count {
            if currentBacklogList.items[i].id == item.id{
                currentBacklogList.items[i].complete = true
            }
        }
        if backlogList.days.isEmpty{
            backlogList.days.append(currentBacklogList)
        }else{
            backlogList.days[0] = currentBacklogList
        }
        saveItems()
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
