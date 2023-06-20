//
//  ContentView.swift
//  Backloger
//
//  Created by Mike Pastula on 20.06.2023.
//

import SwiftUI

enum Category: String, CaseIterable, Identifiable {
    case games_playstation, games_xbox, games_switch, games_windows, comics, books, activities
    
    var id: Self { self }
}

struct ContentView: View {
    @State private var completedCategory: CompleteCategory = .uncompleted
    @State private var selectedCategory: Category = .comics
    @State private var newTask: String = ""
    @State private var backlogList: BacklogListAll
    @State private var backlogItemsList: [BacklogItem]
    @State private var totalProgress: Float
    @State private var currentSelectedBacklog: BacklogList
    
    init() {
        _totalProgress = State(initialValue: 1.0)
        _selectedCategory = State(initialValue: Category.comics)
        _newTask = State(initialValue: "")
        _backlogItemsList = State(initialValue: [BacklogItem]())
        _currentSelectedBacklog = State(initialValue: BacklogList())
        if let data = UserDefaults.standard.data(forKey: "backlogList") {
            let decoder = JSONDecoder()
            if let decodedTasks = try? decoder.decode(BacklogListAll.self, from: data) {
                _backlogList = State(initialValue: decodedTasks)
            } else {
                _backlogList = State(initialValue: BacklogListAll())
            }
        } else {
            _backlogList = State(initialValue: BacklogListAll())
        }
        _currentSelectedBacklog = State(initialValue: backlogList.comicsItems)
        _backlogItemsList = State(initialValue: currentSelectedBacklog.items.filter{ $0.complete == false })
        if !_currentSelectedBacklog.wrappedValue.items.isEmpty{
            let completedItemsCount = currentSelectedBacklog.items.filter { $0.complete }.count
            let progress = Float(completedItemsCount) / Float(currentSelectedBacklog.items.count)
            _totalProgress = State(initialValue: progress)
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
            currentSelectedBacklog = backlogList.comicsItems
        case .books:
            currentSelectedBacklog = backlogList.bookItems
        case .activities:
            currentSelectedBacklog = backlogList.activityItems
        case .games_playstation:
            currentSelectedBacklog = backlogList.playstationGameItems
        case .games_switch:
            currentSelectedBacklog = backlogList.switchGameItems
        case .games_windows:
            currentSelectedBacklog = backlogList.pcGameItems
        case .games_xbox:
            currentSelectedBacklog = backlogList.xboxGameItems
        }
        
        changeCompleteCategory()
        totalProgress = currentSelectedBacklog.items.count == 0 ? 1 : Float(self.currentSelectedBacklog.items.filter{$0.complete == true}.count) / Float(self.currentSelectedBacklog.items.count)
    }
    
    func saveCategory() {
        switch selectedCategory {
        case .comics:
            backlogList.comicsItems  = currentSelectedBacklog
        case .books:
            backlogList.bookItems = currentSelectedBacklog
        case .activities:
            backlogList.activityItems = currentSelectedBacklog
        case .games_playstation:
            backlogList.playstationGameItems = currentSelectedBacklog
        case .games_switch:
            backlogList.switchGameItems = currentSelectedBacklog
        case .games_windows:
            backlogList.pcGameItems = currentSelectedBacklog
        case .games_xbox:
            backlogList.xboxGameItems = currentSelectedBacklog
        }
    }
    
    func addTask() {
        guard !newTask.isEmpty else {
            return
        }
        
        let newItem = BacklogItem(task: newTask)
        if currentSelectedBacklog.items.isEmpty{
            currentSelectedBacklog.items.append(newItem)
        }else{
            currentSelectedBacklog.items.insert(newItem, at: 1)
        }
        saveCategory()
        saveItems()
        changeCompleteCategory()
        newTask = ""
    }
    func setRandomItem(){
        currentSelectedBacklog.currentItem = backlogItemsList.randomElement()!
        
        saveCategory()
        saveItems()
    }
    func removeTask(_ item: BacklogItem) {
        currentSelectedBacklog.items.removeAll { $0.id == item.id }
        saveCategory()
        saveItems()
        changeCompleteCategory()
    }
    
    func completeTask(_ item: BacklogItem) {
        for i in 1 ..< currentSelectedBacklog.items.count {
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
        saveItems()
    }
    
    func saveItems() {
        if let encoded = try? JSONEncoder().encode(backlogList) {
            UserDefaults.standard.set(encoded, forKey: "backlogList")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
