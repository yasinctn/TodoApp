//
//  EmptyListView.swift
//  Todo
//
//  Created by Yasin Cetin on 9.04.2024.
//

import Foundation
import SwiftUI

struct EmptyListView: View{
    var body: some View {
      ZStack {
        VStack(alignment: .center, spacing: 20) {
        Image(systemName: "clipboard")
                .resizable()
                .foregroundStyle(Color.accentColor)
                .frame(width: 200, height: 300, alignment: .center)
          Text("There is no task")
            .layoutPriority(0.5)
            .font(.system(.headline, design: .rounded))
            .foregroundColor(Color.accentColor)
            .bold()
            
        } //: VSTACK
          .padding(.horizontal)
          
      } //: ZSTACK
        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
        .background(Color.white)
        .edgesIgnoringSafeArea(.all)
    }
}
