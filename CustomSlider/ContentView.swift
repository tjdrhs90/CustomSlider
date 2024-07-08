//
//  ContentView.swift
//  CustomSlider
//
//  Created by ssg on 7/4/24.
//

import SwiftUI

struct ContentView: View {
    @State var value: Double = 0
    
    var body: some View {
        CustomSlider(value: $value)
    }
}

#Preview {
    ContentView()
}
