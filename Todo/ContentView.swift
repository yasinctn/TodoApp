//
//  ContentView.swift
//  Todo
//
//  Created by Yasin Cetin on 8.04.2024.
//

import SwiftUI
import CoreData

struct ContentView: View {
  // MARK: - PROPERTIES
  
  @Environment(\.managedObjectContext) var managedObjectContext
    
  @FetchRequest(entity: Task.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \Task.name, ascending: true)]) var tasks: FetchedResults<Task>
  
  @State private var isShowingAddTodoView: Bool = false
  @State private var animatingButton: Bool = false
  
  
  // MARK: - BODY
  
  var body: some View {
    NavigationView {
      ZStack {
        List {
          ForEach(self.tasks, id: \.self) { task in
            HStack {
              Circle()
                .frame(width: 12, height: 12, alignment: .center)
                .foregroundColor(self.colorize(priority: task.priority ?? "Normal"))
              Text(task.name ?? "Unknown")
                .fontWeight(.semibold)
              
              Spacer()
              
              Text(task.priority ?? "Unkown")
                .font(.footnote)
                .foregroundColor(Color(UIColor.systemGray2))
                .padding(3)
                .frame(minWidth: 62)
                .overlay(
                  Capsule().stroke(Color(UIColor.systemGray2), lineWidth: 0.75)
              )
            } //: HSTACK
              .padding(.vertical, 10)
          } //: FOREACH
          .onDelete(perform: deleteTask)
        } //: LIST
          .navigationBarTitle("Tasks", displayMode: .inline)
          .navigationBarItems(
            leading: EditButton().accentColor(Color.accentColor)
        )
        
        // MARK: - NO TODO ITEMS
        if tasks.count == 0 {
          EmptyListView()
        }
      } //: ZSTACK
        .sheet(isPresented: $isShowingAddTodoView) {
          AddTaskView().environment(\.managedObjectContext, self.managedObjectContext)
        }
        .overlay(
          ZStack {
            Group {
              Circle()
                    .fill(Color.blue)
                .opacity(self.animatingButton ? 0.2 : 0)
                .scaleEffect(self.animatingButton ? 1 : 0)
                .frame(width: 68, height: 68, alignment: .center)
              Circle()
                    .fill(Color.blue)
                .opacity(self.animatingButton ? 0.15 : 0)
                .scaleEffect(self.animatingButton ? 1 : 0)
                .frame(width: 88, height: 88, alignment: .center)
            }
            .animation(.easeInOut(duration: 2).repeatForever(autoreverses: true))
            
            Button(action: {
              self.isShowingAddTodoView.toggle()
            }) {
              Image(systemName: "plus.circle.fill")
                .resizable()
                .scaledToFit()
                .background(Circle().fill(Color.white))
                .frame(width: 48, height: 48, alignment: .center)
            } //: BUTTON
            .accentColor(Color.blue)
              .onAppear(perform: {
                 self.animatingButton.toggle()
              })
          } //: ZSTACK
            .padding(.bottom, 15)
            .padding(.trailing, 15)
            , alignment: .bottomTrailing
        )
    } //: NAVIGATION
      .navigationViewStyle(StackNavigationViewStyle())
  }
  
  // MARK: - FUNCTIONS
  
  private func deleteTask(at offsets: IndexSet) {
    for index in offsets {
      let task = tasks[index]
      managedObjectContext.delete(task)
      
      do {
        try managedObjectContext.save()
      } catch {
        print(error)
      }
    }
  }
  
  private func colorize(priority: String) -> Color {
    switch priority {
    case "High":
      return .pink
    case "Normal":
      return .green
    case "Low":
      return .blue
    default:
      return .gray
    }
  }
}

// MARK: - PREVIEW

#Preview {
    ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
}
