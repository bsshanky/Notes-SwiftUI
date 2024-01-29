//
//  SwiftUIView.swift
//  Notes
//
//  Created by Shashank  on 1/27/24.
//

import SwiftUI
import CoreData

struct NotesView: View {

    @EnvironmentObject var vm: NotesViewModel
    @State var showConfirmationDialogue: Bool = false
    @State var showOverlay: Bool = false
    @State private var searchText = ""
            
    @State private var selectedNote: NoteEntity?

    var groupedByDate: [Date: [NoteEntity]] {
        let calendar = Calendar.current
        return Dictionary(grouping: vm.notes) { noteEntity in
            let dateComponents = calendar.dateComponents([.year, .month, .day], from: noteEntity.timestamp!)
            return calendar.date(from: dateComponents) ?? Date()
        }
    }
    
    var headers: [Date] {
        groupedByDate.map { $0.key }.sorted(by: { $0 > $1 })
    }
    
    var body: some View {
        
        NavigationSplitView {
            // sidebar
            List(selection: $selectedNote) {
                ForEach(headers, id: \.self) { header in
                    Section(header: Text(header, style: .date)) {
                        ForEach(groupedByDate[header]!) { note in
                            NavigationLink(value: note) {
                                ListCellView(note: note)
                                    
                            }
                        }
                        
                        .onDelete(perform: { indexSet in
                            deleteNote(in: header, at: indexSet)
                        })
                    }
                }
            }
            .id(UUID())
            .navigationTitle("Notes")
            .searchable(text: $searchText)
            .onChange(of: searchText) {
                // MARK: Core Data Operations
                vm.searchNotes(with: searchText)
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    
                    Button {
                        // Create a new empty note here:
                        createNewNote()
                        
                    } label: {
                        Image(systemName: "note.text.badge.plus")
                            .foregroundColor(Color(UIColor.systemOrange))
                    }
                }
            }
            
        } detail: {
            // item details
            if let selectedNote {
                EditNotesView(note: selectedNote)
                    .id(selectedNote)
            } else {
                Text("Select a Note.")
            }
            
        }
    }
    
    // MARK: Core Data Operations
    
    private func createNewNote() {
        selectedNote = nil
        selectedNote = vm.createNote()
    }

    private func deleteNote(in header: Date, at offsets: IndexSet) {
        offsets.forEach { index in
            if let noteToDelete = groupedByDate[header]?[index] {
                
                if noteToDelete == selectedNote {
                    selectedNote = nil
                }
                
                vm.deleteNote(noteToDelete)
            }
        }
    }
}

#Preview {
    NotesView()
}

