//
//  AuthService.swift
//  RestaurantBooking
//
//  Created by Raiymbek Merekeyev on 18.02.2023.
//

import Foundation
import Combine

class AuthService{
    
    var authResponse: AuthResponse? = nil
    @Published var authStatus: AuthStatus?
    
    static let shared = AuthService()
    private init(){ }
    
    var signInSubscription: AnyCancellable?
    
    func authenticate(with credentials: Credentials){
        signIn(credentials: credentials)
        if authStatus == .ok {
            saveTokenToKeychain()
            if !KeychainManager.itemExists(service: Constants.USER_CEREDENTIALS, account: Constants.SARQYT_ACCOUNT){
                saveUserCredentials(credentials: credentials)
            }
        }
    }
    
    func authenticated() -> Bool {
        if KeychainManager.itemExists(service: Constants.USER_CEREDENTIALS, account: Constants.SARQYT_ACCOUNT){
            return true
        }
        return false
    }
    
    func authenticateUsingBiometrics(){
        guard let credentials = getUserCredentialsFromKeychain() else {
            print("Error getting user credentials")
            return
        }
        
        authenticate(with: credentials)
    }
    
}
//MARK: - Networking

extension AuthService{
    private func signIn(credentials: Credentials){
        let urlString = Constants.BASE_URL + Constants.SIGN_IN
        guard let url = URL(string: urlString) else {
            print("BAD URL: \(urlString)")
            return
        }
        var request = URLRequest(url: url)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        authStatus = .ok
        do{
            let jsonData = try JSONEncoder().encode(credentials)
            request.httpBody = jsonData
            
            signInSubscription = URLSession.shared.dataTaskPublisher(for: request)
                .tryMap{ [weak self] (data, response) throws -> Data in
                    guard let response = response as? HTTPURLResponse else{
                        print("Error occured while unwrapping response.")
                        throw URLError(.badServerResponse)
                    }
                    if !(response.statusCode >= 200 && response.statusCode < 300){
                        self?.authStatus = .credentialsError
                        print("User credentials error....")
                        throw NetworkingError.unauthorizedAccess(url: url)
                    }
                    return data
                }
                .receive(on: DispatchQueue.main)
                .decode(type: AuthResponse.self, decoder: JSONDecoder())
                .sink {completion in
                    print("inside sink")
                    switch completion{
                    case .finished:
                        print("Authenticated!")
                    case .failure(let error):
                        print("Error occured while signing in: \(error.localizedDescription)")
                    }
                } receiveValue: {[weak self] fetchedAuthResponse in
                    self?.authResponse = fetchedAuthResponse
                    self?.signInSubscription?.cancel()
                }

        }catch let error{
            print("Error occured: \(error.localizedDescription)")
        }
    }
}

//MARK: - Keychain manipulation
extension AuthService{
    
    private func getUserCredentialsFromKeychain() -> Credentials? {
        guard let data = KeychainManager.read(service: Constants.USER_CEREDENTIALS, account: Constants.SARQYT_ACCOUNT) else{
            print("No user credentials in Keychain for:\nService: \(Constants.USER_CEREDENTIALS)\nAccount: \(Constants.SARQYT_ACCOUNT)")
            return nil
        }
        var credentials: Credentials? = nil
        do {
            credentials = try JSONDecoder().decode(Credentials.self, from: data)
        } catch let error {
            print("Error decoding user credentials: \(error.localizedDescription)")
        }
        return credentials
    }
    
    private func saveTokenToKeychain(){
        if let token = authResponse?.accessToken{
            let data = Data(token.utf8)
            KeychainManager.save(data, service: Constants.ACCESS_TOKEN, account: Constants.SARQYT_ACCOUNT)
        }
    }
    
    private func saveUserCredentials(credentials: Credentials){
        do {
            let encodedCredentials = try JSONEncoder().encode(credentials)
            KeychainManager.save(encodedCredentials, service: Constants.USER_CEREDENTIALS, account: Constants.SARQYT_ACCOUNT)
        } catch let error {
            print("Error encoding user credentials: \(error.localizedDescription)")
        }
    }
}
