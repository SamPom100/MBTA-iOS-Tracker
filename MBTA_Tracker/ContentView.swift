import SwiftUI

class ApplicationState: ObservableObject {
    @Published var loggedIn = true
}


struct ContentView: View {
    @StateObject var applicationState: ApplicationState = ApplicationState()
    var body: some View {
        if(!applicationState.loggedIn) {
            AuthView().environmentObject(applicationState)
        }
        else{
            MBTAView().environmentObject(applicationState)
        }
    }
    
}

struct AuthView: View {
    @EnvironmentObject var applicationState: ApplicationState
    var body: some View {
        List {
            Section{}
            Section{}
            Text("MBTA Sign In")
            Section{}
            Button("Log In"){
                applicationState.loggedIn = true
            }
        }
    }
}



struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}


struct SomeView: View {
    var body: some View {
        NavigationView {
            VStack {
                Text("Navigation Link Below:")
                NavigationLink(destination: SecondView()) {
                    Text("Navigate Here")
                        .foregroundColor(.black)
                        .font(.system(size:30))
                        .fontWeight(.bold)
                }
            }.navigationBarTitle("Page One")
        }
    }
}

struct SecondView: View {
    var body: some View {
        Text("Now on the second view.")
    }
}


struct MBTAView: View{
    @State var harv_predictions: [Prediction] = []
    @State var blan_predictions: [Prediction] = []
    @EnvironmentObject var applicationState: ApplicationState
    var body: some View{
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
                
                Section{}
                
                Button("Log Out"){
                    applicationState.loggedIn = false
                }
                
            }.onAppear {
                harv_predictions = harv_Predictions() ?? []
                blan_predictions = blan_Predictions() ?? []
            }
            .navigationBarTitle("MBTA Train Info")
        }
    }
}
