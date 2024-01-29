//
//  NotesApp.swift
//  Notes
//
//  Created by Shashank  on 1/27/24.
//

import SwiftUI

@main
struct NotesToDocApp: App {
    let coreDataManager = CoreDataManager()
    @StateObject var notesViewModel: NotesViewModel

        init() {
            let viewModel = NotesViewModel(manager: coreDataManager)
            _notesViewModel = StateObject(wrappedValue: viewModel)
        }


    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(notesViewModel)
        }
    }
}
