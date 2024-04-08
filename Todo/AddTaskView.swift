//
//  AddTaskView.swift
//  Todo
//
//  Created by Yasin Cetin on 9.04.2024.
//

import Foundation
import SwiftUI

struct AddTaskView: View{
    
    @Environment(\.managedObjectContext) var managedObjectContext
    @Environment(\.presentationMode) var presentationMode
    
    @State private var name = ""
    @State private var priority = "Normal"
    
    let priorities = ["High", "Normal", "Low"]
    
    @State private var errorShowing = false
    @State private var errorTitle = ""
    @State private var errorMessage = ""
    
    
    var body: some View {
      NavigationView {
        VStack {
          VStack(alignment: .leading, spacing: 20) {
            // MARK: - TASK NAME
            TextField("Task", text: $name)
              .padding()
              .background(Color(UIColor.tertiarySystemFill))
              .cornerRadius(9)
              .font(.system(size: 24, weight: .bold, design: .default))
            
            // MARK: - TASK PRIORITY
            Picker("Priority", selection: $priority) {
              ForEach(priorities, id: \.self) {
                Text($0)
              }
            }
            .pickerStyle(SegmentedPickerStyle())
            
            // MARK: - SAVE BUTTON
            Button(action: {
              if self.name != "" {
                let task = Task(context: self.managedObjectContext)
                task.name = self.name
                task.priority = self.priority
                
                do {
                  try self.managedObjectContext.save()

                } catch {
                  print(error)
                }
              } else {
                self.errorShowing = true
                self.errorTitle = "Invalid Name"
                self.errorMessage = "Make sure to enter something for\nthe new task."
                return
              }
              self.presentationMode.wrappedValue.dismiss()
            }) {
              Text("Save")
                    .font(.system(size: 24, weight: .bold, design: .default))
                .padding()
                .frame(minWidth: 0, maxWidth: .infinity)
                .cornerRadius(9)
                .foregroundColor(Color.accentColor)
            } //: SAVE BUTTON
          } //: VSTACK
            .padding(.horizontal)
            .padding(.vertical, 30)
          
          Spacer()
        } //: VSTACK
        .navigationBarTitle("New Task", displayMode: .inline)
          .navigationBarItems(trailing:
            Button(action: {
              self.presentationMode.wrappedValue.dismiss()
            }) {
              Image(systemName: "xmark")
            }
        )
          .alert(isPresented: $errorShowing) {
            Alert(title: Text(errorTitle), message: Text(errorMessage), dismissButton: .default(Text("OK")))
        }
      } //: NAVIGATION
      .accentColor(Color.blue)
        .navigationViewStyle(StackNavigationViewStyle())
    }
}
