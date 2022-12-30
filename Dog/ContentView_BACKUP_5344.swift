//
//  ContentView.swift
//  Dog
//
//  Created by Nyi Ye Han on 25/11/2022.
//

import SwiftUI

struct ContentView: View {
    @StateObject var viewModel = DogViewModel()
    var body: some View {
        VStack {
            if let image = viewModel.image{
                Image(uiImage: image)
                    .frame(width: 200,height: 200)
            }
            

            Text("Feature Chat-Room")
        }
        .onAppear{
            viewModel.getDogs()
            viewModel.decodeJsonToStruct()
        }
        .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
