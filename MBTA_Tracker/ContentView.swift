
import SwiftUI
import GoogleSignIn

struct ContentView: View {
    @EnvironmentObject var userData: UserData
    var body: some View {
        if(!userData.isSignedIn){
            NavigationView{
                VStack {
                    Section{
                        Spacer().frame(height: 50)
                    }
                    HStack {
                        let imageName = "mLogo.png"
                        let image = UIImage(named: imageName)
                        Image(uiImage: image!)
                    }
                    Spacer().frame(height: 100)
                    Text("Please Sign In").font(.largeTitle).bold()
                    GoogleSignInBtn(userData).padding().disabled(userData.isSignedIn)
            
                }
                .navigationTitle("MBTA Tracker")
            }
        }
        else{
            MBTAView()
        }
    }
}

/*
 HStack {
     Button("Sign out", action: {
         GIDSignIn.sharedInstance.signOut()
         print("Sign out")
         userData.signIn(user: GIDSignIn.sharedInstance.currentUser)
     }).disabled(!userData.isSignedIn).padding()
     Spacer()
     Button("Disconnect", action: {
         GIDSignIn.sharedInstance.disconnect(callback: {error in
             if let error = error {
                 print("disconnect error: \(error.localizedDescription)")
             }
             else {
                 print("disconnected")
                 userData.signIn(user: GIDSignIn.sharedInstance.currentUser)
             }
         })
     }).disabled(!userData.isSignedIn).padding()
 }.padding()
*/

struct GoogleSignInBtn: UIViewRepresentable {
    var userData: UserData
    
    @Environment(\.colorScheme) var colorScheme: ColorScheme
    typealias UIViewType = GIDSignInButton
    
    init(_ userData: UserData) {
        self.userData = userData
    }
    
    func makeUIView(context: Context) -> GIDSignInButton {
        let button = GIDSignInButton()
        
        switch colorScheme {
        case .light:
            button.colorScheme = .light
        case .dark:
            button.colorScheme = .dark
        default:
            button.colorScheme = .light
        }
        
        button.addAction(.init(handler: { _ in
            guard let presentingViewController = (UIApplication.shared.connectedScenes.first as? UIWindowScene)?.windows.first?.rootViewController else {return}
            
            GIDSignIn.sharedInstance.signIn(
                with: self.userData.signInConfig,
                presenting: presentingViewController,
                callback: { user, error in
                    if let error = error {
                        print("error: \(error.localizedDescription)")
                    }
                    else if let user = user {
                        self.userData.signIn(user: user)
                    }
                })
        }), for: .touchUpInside)
        button.isEnabled = false
        return button
    }
    
    func updateUIView(_ uiView: GIDSignInButton, context: Context) {
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static let userData = UserData()
    static var previews: some View {
        ContentView().environmentObject(userData)
    }
}


extension String {
    func capitalizingFirstLetter() -> String {
        return prefix(1).capitalized + dropFirst()
    }

    mutating func capitalizeFirstLetter() {
        self = self.capitalizingFirstLetter()
    }
}

struct MBTAView: View{
    @State var harv_predictions: [Prediction] = []
    @State var blan_predictions: [Prediction] = []
    @State var temp_outside = get_temp()
    @State var desc_outside = get_desc()
    @EnvironmentObject var userData: UserData
    
    
    var body: some View{
        NavigationView{
            List {
                Section("Forecast"){
                    Text("It's \(Int(temp_outside))° today. \(desc_outside.capitalizingFirstLetter()).").bold()
                        .frame(maxWidth: .infinity, alignment: .center)
                }
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
                
                Section{
                    Button("Refresh Data"){
                        harv_predictions = harv_Predictions() ?? []
                        blan_predictions = blan_Predictions() ?? []
                        harv_predictions = Array(harv_predictions.prefix(5))
                        blan_predictions = Array(blan_predictions.prefix(5))
                        temp_outside = get_temp()
                        desc_outside = get_desc()
                    }
                    
                    
                    Button("Sign out", action: {
                        GIDSignIn.sharedInstance.signOut()
                        print("Sign out")
                        userData.signIn(user: GIDSignIn.sharedInstance.currentUser)
                    }).disabled(!userData.isSignedIn)
                }
                
               
                
            }.onAppear {
                harv_predictions = harv_Predictions() ?? []
                blan_predictions = blan_Predictions() ?? []
                harv_predictions = Array(harv_predictions.prefix(5))
                blan_predictions = Array(blan_predictions.prefix(5))
                temp_outside = get_temp()
                desc_outside = get_desc()
            }
            
            
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    VStack {
                        Text("")
                        Text("MBTA Tracker").font(.largeTitle).bold()
                        Text("Welcome Back \(userData.userName)").font(.subheadline)
                    }
                }
            }
        }
    }
}
