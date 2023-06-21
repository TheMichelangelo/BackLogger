//
//  ContentView.swift
//  Backloger
//
//  Created by Mike Pastula on 20.06.2023.
//

import SwiftUI

struct ContentView: View {
    @State private var completedCategory: CompleteCategory = .uncompleted
    @State private var selectedCategory: Category = .comics
    @State private var newTask: String = ""
    @State private var totalProgress: Float
    @ObservedObject private var backlogList: BacklogListAll
    @State private var currentSelectedBacklog: BacklogList
    @State private var backlogItemsList: [BacklogItem]
    
    init() {
        _totalProgress = State(initialValue: 1.0)
        _selectedCategory = State(initialValue: Category.comics)
        _newTask = State(initialValue: "")
        _backlogItemsList = State(initialValue: [BacklogItem]())
        _currentSelectedBacklog = State(initialValue: BacklogList())
        backlogList = BacklogListAll.loadFromStorage()
        _currentSelectedBacklog = State(initialValue: backlogList.comicsItems)
        _backlogItemsList = State(initialValue: currentSelectedBacklog.items.filter{ $0.complete == false })
        if !_currentSelectedBacklog.wrappedValue.items.isEmpty {
            totalProgress = currentSelectedBacklog.items.count == 0 ? 1 : Float(self.currentSelectedBacklog.items.filter{$0.complete == true}.count) / Float(self.currentSelectedBacklog.items.count)
        }
    }

    var body: some View {
        VStack {
            ZStack {
                LinearGradient(colors: [.red, .blue], startPoint: .top, endPoint: .bottom)
                    .ignoresSafeArea()
                VStack {
                    Text("My Backlog List")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .padding(.top, 1)
                        .foregroundColor(.white.opacity(0.7))
                    
                    Picker("Category", selection: $selectedCategory) {
                        ForEach(Category.allCases) { category in
                            Text(category.rawValue.capitalized).tag(category)
                        }
                    }
                    .onChange(of: selectedCategory) { _ in
                        changeCategory()
                    }
                    
                    ProgressView(value: totalProgress,total: 1)
                        .shadow(color: Color(red: 0, green: 0, blue: 0.6), radius: 4.0, x: 1.0, y: 2.0)
                    Label(currentSelectedBacklog.currentItem.task, systemImage: "bolt.fill")
                    Button(action:setRandomItem){
                    Text("Randomise current").foregroundColor(.white.opacity(0.7))
                    }.buttonStyle(.bordered)
                    
                    HStack{
                            TextField("New backlog item",text: $newTask)
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
                Picker("Completed", selection: $completedCategory) {
                    ForEach(CompleteCategory.allCases) { category in
                        Text(category.rawValue.capitalized).tag(category)
                    }.onChange(of: completedCategory) { _ in
                        changeCompleteCategory()
                    }
                }.pickerStyle(SegmentedPickerStyle())
                if completedCategory == CompleteCategory.uncompleted{
                    List(backlogItemsList) { item in
                        HStack {
                            Text(item.task)
                                .foregroundColor(.blue)
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
                }else{
                    List(backlogItemsList) { item in
                        HStack {
                            Text(item.task)
                                .foregroundColor(.blue)
                        }
                    }
                }
                
                Text("Created by @mpast")
                    .font(.title2)
                    .foregroundColor(.orange)
            }
        }
    }
    
    func getBacklogItemsList()-> [BacklogItem] {
        switch completedCategory {
        case .uncompleted:
            return currentSelectedBacklog.items.filter{ $0.complete == false }
        case .completed:
            return currentSelectedBacklog.items.filter{ $0.complete == true }
        }
    }
    
    func changeCompleteCategory() {
        switch completedCategory {
        case .uncompleted:
            backlogItemsList = currentSelectedBacklog.items.filter{ $0.complete == false }
        case .completed:
            backlogItemsList = currentSelectedBacklog.items.filter{ $0.complete == true }
        }
    }
    
    func changeCategory() {
        switch selectedCategory {
        case .comics:
            currentSelectedBacklog.currentItem = backlogList.comicsItems.currentItem
            currentSelectedBacklog.items = backlogList.comicsItems.items
        case .books:
            currentSelectedBacklog.currentItem = backlogList.bookItems.currentItem
            currentSelectedBacklog.items = backlogList.bookItems.items
        case .activities:
            currentSelectedBacklog.currentItem = backlogList.activityItems.currentItem
            currentSelectedBacklog.items = backlogList.activityItems.items
        case .games_playstation:
            currentSelectedBacklog.currentItem = backlogList.playstationGameItems.currentItem
            currentSelectedBacklog.items = backlogList.playstationGameItems.items
        case .games_switch:
            currentSelectedBacklog.currentItem = backlogList.switchGameItems.currentItem
            currentSelectedBacklog.items = backlogList.switchGameItems.items
        case .games_windows:
            currentSelectedBacklog.currentItem = backlogList.pcGameItems.currentItem
            currentSelectedBacklog.items = backlogList.pcGameItems.items
        case .games_xbox:
            currentSelectedBacklog.currentItem = backlogList.xboxGameItems.currentItem
            currentSelectedBacklog.items = backlogList.xboxGameItems.items
        }
        
        changeCompleteCategory()
        totalProgress = currentSelectedBacklog.items.count == 0 ? 1 : Float(self.currentSelectedBacklog.items.filter{$0.complete == true}.count) / Float(self.currentSelectedBacklog.items.count)
    }
    
    func addTask() {
        guard !newTask.isEmpty else {
            return
        }
        
        let newItem = BacklogItem(task: newTask)
        
        currentSelectedBacklog.items.append(newItem)
        currentSelectedBacklog.items.sort { (item1, item2) -> Bool in
            return item1.task < item2.task
        }
           
        BacklogListAll.saveToStorage(backlogList: backlogList)
        changeCompleteCategory()
        newTask = ""
    }
    
    func setRandomItem(){
        currentSelectedBacklog.currentItem = backlogItemsList.randomElement()!
        BacklogListAll.saveToStorage(backlogList: backlogList)
    }
    
    func removeTask(_ item: BacklogItem) {
        currentSelectedBacklog.items.removeAll { $0.id == item.id }
        BacklogListAll.saveToStorage(backlogList: backlogList)
        changeCompleteCategory()
    }
    
    func completeTask(_ item: BacklogItem) {
        for i in 0 ..< currentSelectedBacklog.items.count {
            if currentSelectedBacklog.items[i].id == item.id{
                currentSelectedBacklog.items[i].complete = true
                currentSelectedBacklog.items[i].dateCompleted = Date()
            }
        }
        if currentSelectedBacklog.currentItem.id == item.id{
            setRandomItem()
        }
        changeCompleteCategory()
        BacklogListAll.saveToStorage(backlogList: backlogList)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
