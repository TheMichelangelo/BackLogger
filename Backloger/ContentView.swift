//
//  ContentView.swift
//  Backloger
//
//  Created by Mike Pastula on 20.06.2023.
//

import SwiftUI

enum Category: String, CaseIterable, Identifiable {
    case games_playstation, games_xbox, games_switch, games_PC, comics, books, activities
    
    var id: Self { self }
}

struct ContentView: View {
    @State private var selectedCategory: Category = .comics
    @State private var newTask: String = ""
    @State private var backlogList: BacklogListAll
    
    @State private var currentSelectedBacklog: BacklogList
    
    init() {
            _selectedCategory = State(initialValue: Category.comics)
            _newTask = State(initialValue: "")
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
                    let totalProgress =  Float(currentSelectedBacklog.items.filter{$0.complete == true}.count) / Float(currentSelectedBacklog.items.count)
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
                List(currentSelectedBacklog.items.filter{ $0.complete == false }) { item in
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
                
                Text("Created by @mpast")
                    .font(.title2)
                    .foregroundColor(.orange)
            }
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
        case .games_PC:
            currentSelectedBacklog = backlogList.pcGameItems
        case .games_xbox:
            currentSelectedBacklog = backlogList.xboxGameItems
        }
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
        case .games_PC:
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

        newTask = ""
    }
    func setRandomItem(){
        currentSelectedBacklog.currentItem = currentSelectedBacklog.items.filter{ $0.complete == false }.randomElement()!
        
        saveCategory()
        saveItems()
    }
    func removeTask(_ item: BacklogItem) {
        currentSelectedBacklog.items.removeAll { $0.id == item.id }
        saveCategory()
        saveItems()
    }
    
    func completeTask(_ item: BacklogItem) {
        for i in 1 ..< currentSelectedBacklog.items.count {
            if currentSelectedBacklog.items[i].id == item.id{
                currentSelectedBacklog.items[i].complete=true
            }
        }
        if currentSelectedBacklog.currentItem.id == item.id{
            setRandomItem()
        }
        
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
