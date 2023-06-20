//
//  ContentView.swift
//  Backloger
//
//  Created by Mike Pastula on 18.06.2023.
//

import SwiftUI

struct GrowingButton: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding()
            .background(.blue)
            .foregroundStyle(.white)
            .clipShape(Capsule())
            .scaleEffect(configuration.isPressed ? 1.2 : 1)
            .animation(.easeOut(duration: 0.2), value: configuration.isPressed)
    }
}

struct MainView: View {
    var body: some View {
        NavigationView {
                    VStack {
                        ZStack {
                            LinearGradient(colors: [.red, .blue], startPoint: .top, endPoint: .bottom)
                                .ignoresSafeArea()
                            NavigationLink {
                                DayView()
                            } label: {
                                Text("See day activities")
                            }.buttonStyle(GrowingButton())
                            .padding([.bottom, .trailing], 120)
                            NavigationLink {
                                ContentView()
                            } label: {
                                Text("See backlog")
                            }.buttonStyle(GrowingButton())
                        }
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
