import SwiftUI


struct ContentView: View {
	@State var harv_predictions: [Prediction] = []
    @State var blan_predictions: [Prediction] = []
	
    var body: some View {
        NavigationView{
            List {
                Section("Harvard Departure Times", content: {
                    ForEach(harv_predictions.filter({prediction in Date() < prediction.attributes.arrival_time}), id: \.self) { prediction in
                        let leaveIn:String = (String(format:"%.1f", (Date().distance(to: prediction.attributes.arrival_time))/60))
                        Text("\(prediction.attributes.arrival_time.formatted(date: .omitted, time: .shortened))     --    in " + leaveIn + " minutes.")
                    }
                })
                
                Section("Blanford Departure Times", content: {
                    ForEach(blan_predictions.filter({prediction in Date() < prediction.attributes.arrival_time}), id: \.self) { prediction in
                        let leaveIn:String = (String(format:"%.1f", (Date().distance(to: prediction.attributes.arrival_time))/60))
                        Text("\(prediction.attributes.arrival_time.formatted(date: .omitted, time: .shortened))     --    in " + leaveIn + " minutes.")
                    }
                })
                
                Section{}
                
                Button("Refresh Data"){
                    harv_predictions = harv_Predictions() ?? []
                    blan_predictions = blan_Predictions() ?? []
                }
                
            }.onAppear {
                harv_predictions = harv_Predictions() ?? []
                blan_predictions = blan_Predictions() ?? []
        }
        .navigationBarTitle("MBTA Train Info")
    }
  }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
