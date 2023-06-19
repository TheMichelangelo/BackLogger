//
//  ContentView.swift
//  Backloger
//
//  Created by Mike Pastula on 18.06.2023.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
          // объявляем NavigationView единожды на первом экране
            NavigationView {
                NavigationLink {
                    BacklogView()
                } label: {
                    Text("Go to unread books")
                }
                .navigationTitle("Main Screen")
            }
        }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
