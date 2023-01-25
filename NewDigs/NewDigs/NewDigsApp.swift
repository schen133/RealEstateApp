//
//  NewDigsApp.swift
//  NewDigs
//
//  Created by Sifeng Chen on 11/5/22.
//

import SwiftUI

@main
struct NewDigsApp: App {
    @StateObject private var persistence = Persistence()
    @StateObject var locationVM = LocationVM()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistence.container.viewContext)
//                .environmentObject(locationVM)

        }
    }
}
