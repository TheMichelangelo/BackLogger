//
//  ShopListView.swift
//  Backloger
//
//  Created by Mike Pastula on 20.06.2023.
//

import SwiftUI

struct ShopListView: View {
    @State private var newTask: String = ""
    @State private var backlogItemsList: [BacklogItem]
    
    init() {
        _newTask = State(initialValue: "")
        if let data = UserDefaults.standard.data(forKey: "buyBacklogList") {
            let decoder = JSONDecoder()
            if let decodedTasks = try? decoder.decode([BacklogItem].self, from: data) {
                _backlogItemsList = State(initialValue: decodedTasks)
            } else {
                _backlogItemsList = State(initialValue: [BacklogItem]())
            }
        } else {
            _backlogItemsList = State(initialValue: [BacklogItem]())
        }
    }
    
    var body: some View {
        VStack {
            ZStack {
                LinearGradient(colors: [.red, .blue], startPoint: .top, endPoint: .bottom)
                    .ignoresSafeArea()
                VStack {
                    Text("My Buy List")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .padding(.top, 1)
                        .foregroundColor(.white.opacity(0.7))
                    
                    HStack{
                            TextField("New item",text: $newTask)
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
                    List(backlogItemsList) { item in
                        HStack {
                            Text(item.task)
                                .foregroundColor(.blue)
                        }
                        .swipeActions() {
                            Button(role: .destructive) {
                                removeTask(item)
                            } label: {
                                Label("Delete item", systemImage: "trash")
                            }
                        }
                    }
                
                Text("Created by @mpast")
                    .font(.title2)
                    .foregroundColor(.orange)
            }
        }
    }
    
    func addTask() {
        guard !newTask.isEmpty else {
            return
        }
        
        let newItem = BacklogItem(task: newTask)
        if backlogItemsList.isEmpty{
            backlogItemsList.append(newItem)
        }else{
            backlogItemsList.insert(newItem, at: 1)
        }
        saveItems()
        newTask = ""
    }
    func removeTask(_ item: BacklogItem) {
        backlogItemsList.removeAll { $0.id == item.id }
        saveItems()
    }
    
    func completeTask(_ item: BacklogItem) {
        for i in 0 ..< backlogItemsList.count {
            if backlogItemsList[i].id == item.id{
                backlogItemsList[i].complete=true
                backlogItemsList[i].dateCompleted = Date()
            }
        }
        saveItems()
    }
    
    func saveItems() {
        if let encoded = try? JSONEncoder().encode(backlogItemsList) {
            UserDefaults.standard.set(encoded, forKey: "buyBacklogList")
        }
    }
}

struct ShopListView_Previews: PreviewProvider {
    static var previews: some View {
        ShopListView()
    }
}
