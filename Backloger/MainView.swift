//
//  ContentView.swift
//  Backloger
//
//  Created by Mike Pastula on 18.06.2023.
//

import SwiftUI

struct MainView: View {
    var body: some View {
        NavigationView {
                    VStack {
                        
                        NavigationLink {
                            DayView()
                        } label: {
                            Text("See day activities")
                        }.buttonStyle(PlainButtonStyle())
                        .padding([.bottom, .trailing], 20)
                        NavigationLink {
                            ContentView()
                        } label: {
                            Text("See backlog")
                        }.buttonStyle(PlainButtonStyle())
                    }
                    .navigationTitle("Main view")
                }
        }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
