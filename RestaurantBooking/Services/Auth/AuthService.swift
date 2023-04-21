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
    var signUpSubscription: AnyCancellable?
    
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
        authStatus = nil
        guard var request = AuthManager.constructRequest(for: urlString) else {
            print("Error creating request")
            return
        }
        
        do{
            let jsonData = try JSONEncoder().encode(credentials)
            request.httpBody = jsonData
            
            signInSubscription = AuthManager.post(request: request)
                .decode(type: AuthResponse.self, decoder: JSONDecoder())
                .sink {[weak self] completion in
                    switch completion{
                    case .finished:
                        print("Authenticated!")
                    case .failure(let error as NetworkingError):
                        self?.authStatus = .authorizationError(message: error.localizedDescription)
                    case .failure(let error):
                        print("Error occured while signing in: \(error.localizedDescription)")
                    }
                } receiveValue: {[weak self] fetchedAuthResponse in
                    self?.authResponse = fetchedAuthResponse
                    self?.authStatus = .ok
                    self?.signInSubscription?.cancel()
                }

        }catch let error{
            print("Error occured: \(error.localizedDescription)")
        }
    }
    
    func signUp(credentials: Credentials) {
        let urlString = Constants.BASE_URL + Constants.SIGN_UP
        authStatus = nil
        guard var request = AuthManager.constructRequest(for: urlString) else {
            print("Error creating request")
            return
        }
        do{
            let jsonData = try JSONEncoder().encode(credentials)
            request.httpBody = jsonData
            
            signUpSubscription = AuthManager.post(request: request)
                .decode(type: AuthResponse.self, decoder: JSONDecoder())
                .sink {[weak self] completion in
                    switch completion{
                    case .finished:
                        print("Authenticated!")
                    case .failure(let error as NetworkingError):
                        self?.authStatus = .authorizationError(message: error.localizedDescription)
                    case .failure(let error):
                        print("Error occured while signing in: \(error.localizedDescription)")
                    }
                } receiveValue: { [weak self] fetchedAuthResponse in
                    self?.authResponse = fetchedAuthResponse
                    self?.authStatus = .ok
                    self?.saveUserCredentialsAndTokenToKeychain(credentials: credentials, token: fetchedAuthResponse.accessToken)
                    self?.signUpSubscription?.cancel()
                }

        } catch let error{
            print("Error occured : \(error.localizedDescription)")
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
    
    private func saveUserCredentialsAndTokenToKeychain(credentials: Credentials, token: String){
        saveUserCredentials(credentials: credentials)
        let data = Data(token.utf8)
        KeychainManager.save(data, service: Constants.ACCESS_TOKEN, account: Constants.SARQYT_ACCOUNT)
    }
}
