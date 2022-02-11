import AuthenticationServices
import SwiftUI

struct AppleUser: Codable {
    let userId: String
    let firstName: String
    let lastName: String
    let email: String
    
    init?(credentials: ASAuthorizationAppleIDCredential) {
        guard
            let firstName = credentials.fullName?.givenName,
            let lastName = credentials.fullName?.familyName,
            let email = credentials.email
        else { return nil }
        
        self.userId = credentials.user
        self.firstName = firstName
        self.lastName = lastName
        self.email = email
    }
}

struct AuthView2: View {
    @EnvironmentObject var applicationState: ApplicationState
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        SignInWithAppleButton(
            .signIn,
            onRequest: configure,
            onCompletion: handle
        )
        .signInWithAppleButtonStyle(
            colorScheme == .dark ? .white : .black
        )
        .frame(height: 45)
        .padding()
    }
    
    func configure(_ request: ASAuthorizationAppleIDRequest) {
        request.requestedScopes = [.fullName, .email]
//        request.nonce = ""
    }
    
    func handle(_ authResult: Result<ASAuthorization, Error>) {
        switch authResult {
        case .success(let auth):
            print(auth)
            applicationState.loggedIn = true
            switch auth.credential {
            case let appleIdCredentials as ASAuthorizationAppleIDCredential:
                if let appleUser = AppleUser(credentials: appleIdCredentials),
                   let appleUserData = try? JSONEncoder().encode(appleUser) {
                    UserDefaults.standard.setValue(appleUserData, forKey: appleUser.userId)
                    
                    print("saved apple user", appleUser)
                } else {
                    print("missing some fields", appleIdCredentials.email as Any, appleIdCredentials.fullName as Any, appleIdCredentials.user)
                    
                    guard
                        let appleUserData = UserDefaults.standard.data(forKey: appleIdCredentials.user),
                        let appleUser = try? JSONDecoder().decode(AppleUser.self, from: appleUserData)
                    else { return }
                    
                    print(appleUser)
                }
                
            default:
                print(auth.credential)
                applicationState.loggedIn = true
            }
            
        case .failure(let error):
            print(error)
        }
    }
}

struct ContentView_Previews2: PreviewProvider {
    static var previews: some View {
        Group {
            ContentView()
                .preferredColorScheme(.dark)
        }
    }
}
