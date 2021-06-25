//
//  ContentView.swift
//  NFCReader
//
//  Created by Vadiraj Hippargi on 6/24/21.
//

import SwiftUI
import CoreNFC

struct ContentView: View {
    
@State var writer = NFCReader()
@State var urlT = ""
    
    var body: some View {
        VStack {
            TextField("Enter URL Here", text: $urlT)
            Button(action: {
                writer.scan(data: urlT)
                
            }, label: {
                Text("Write To Tag")
            }).padding()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
