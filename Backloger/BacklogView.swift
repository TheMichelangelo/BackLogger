//
//  BacklogView.swift
//  Backloger
//
//  Created by Mike Pastula on 19.06.2023.
//

import SwiftUI

struct BacklogView: View {
    @State private var items : Array<BacklogItem>
    @State private var newTask : String
    
    init() {
        if let data = UserDefaults.standard.data(forKey: "backlogList") {
            let decoder = JSONDecoder()
            // Decode the data back into an array of Task structs
            if let decodedTasks = try? decoder.decode([BacklogItem].self, from: data) {
                self.items = decodedTasks
            }else{
                self.items = [BacklogItem]()
            }
        }else{
            self.items = [BacklogItem]()
        }
        newTask = ""
    }
    
    var body: some View {
        VStack {
            ZStack{
                LinearGradient(colors: [.red,.blue], startPoint: .top, endPoint: .bottom)
                    .ignoresSafeArea()
                VStack{
                    Text("My Backlog List").font(.largeTitle).fontWeight(.bold).padding(.top,50).foregroundColor(.white.opacity(0.7))
                    HStack{
                        TextField("New backlog item",text: $newTask)
                            .padding(.all)
                            .background(.regularMaterial)
                            .cornerRadius(25)
                            .accentColor(.red)
                        Button(action:addTask){
                            Text("Add").foregroundColor(.white.opacity(0.7))
                        }.buttonStyle(.bordered)
                    }
                }
            }
                .frame(height:200)
                VStack{
                    List(items){
                        item in HStack{
                            Text(item.task).foregroundColor(.blue)
                            ProgressView(value: 5, total: 15)
                        }.swipeActions{Button(role:.destructive){
                            removeTask(item)
                        }label: {
                            Label("Delete item",systemImage: "trash")
                        }
                    }
                }
                    Text("Created by @mpast").font(.title2).foregroundColor(.orange)
            }
        }
    }
    func addTask(){
        guard !newTask.isEmpty else {
            return
        }
                
        items.append(BacklogItem(task: newTask))
        saveItems()
            newTask = ""
    }
    func removeTask(_ item: BacklogItem){
        items.removeAll{$0.id == item.id}
        saveItems()
    }
    func saveItems() {
        if let encoded = try? JSONEncoder().encode(items) {
            UserDefaults.standard.set(encoded, forKey: "backlogList")
        }
    }
}

struct BacklogView_Previews: PreviewProvider {
    static var previews: some View {
        BacklogView()
    }
}
