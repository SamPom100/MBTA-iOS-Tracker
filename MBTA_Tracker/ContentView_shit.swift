//
//  ContentView.swift
//  MBTA_Tracker
//
//  Created by Sam Pomerantz on 2/9/22.
//

import SwiftUI
import Foundation

struct APIResponse: Codable {
    var data: [Prediction]
}

struct Prediction: Codable {
    var attributes: PredictionAttributes
    
    struct PredictionAttributes: Codable {
        var arrival_time: String
        var departure_time: String
    }
}

func testFunc() -> Array<String>{
    let urlString = "https://api-v3.mbta.com/predictions?filter%5Bstop%5D=70130"

    guard let url = URL(string: urlString) else { exit(1) } // Valid URL

    guard let data = try? Data(contentsOf: url) else { exit(2) } // Got response

    let decoder = JSONDecoder()
    #decoder.dateDecodingStrategy = .iso8601

    var predictions: APIResponse?

    do {
        predictions = try decoder.decode(APIResponse.self, from: data)
    }
    catch{
        //
    }
    
    var toReturn: [String] = []

    for prediction in predictions!.data {
        //print(prediction.attributes.departure_time)
        toReturn.append(prediction.attributes.arrival_time)
    }
    
    print("testFunc ran!")
    return toReturn
}



struct ContentView: View {
    @State var MBTA_data = testFunc()
    var body: some View {
        NavigationView { //adds a navigation bar
            Form {
                Text("Forms can only have 10 children")
                
                
                List {
                    ForEach(MBTA_data) { section in
                        Text(section.arrival_time)

                        
                    }
                }
                
                
                Section{}
                
                Button("Refresh Data"){
                    Swift.print("DONE")
                    MBTA_data = testFunc()
                }
                
                Section{}
                
            
            }
            .navigationTitle("MBTA Train Data")
            //.navigationBarTitleDisplayMode(.inline) //make font smaller
            
            
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
