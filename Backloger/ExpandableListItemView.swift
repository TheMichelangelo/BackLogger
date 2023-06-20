//
//  ExpandableListItemView.swift
//  Backloger
//
//  Created by Mike Pastula on 20.06.2023.
//

import SwiftUI

struct ExpandableListItemView: View {
    @State private var isExpanded = false
    
    var title: String
    var items: [ActivityBacklogItem]
    
    var body: some View {
            VStack {
                DisclosureGroup(isExpanded: $isExpanded) {
                    let completedItemsCount = items.filter { $0.complete }.count
                    let progress = Float(completedItemsCount) / Float(items.count)
                    ProgressView(value: progress,total: 1)
                    VStack(alignment: .leading) {
                        ForEach(items, id: \.self) { item in
                            Text(item.task)
                                .padding(.leading)
                                .foregroundColor(item.complete ? .green : .red)
                        }
                    }
                } label: {
                    Text(title)
                        .font(.headline)
                }
                .padding()
                .foregroundColor(.blue)
                .background(Color.gray.opacity(0.2))
                .cornerRadius(8)
            }
        }
}

struct ExpandableListItemView_Previews: PreviewProvider {
    static var previews: some View {
        ExpandableListItemView(title:"Test",items: [ActivityBacklogItem(task: "Task 1"),ActivityBacklogItem(task:"Task 2")])
    }
}
