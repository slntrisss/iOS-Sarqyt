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
    var signOutSubscription: AnyCancellable?
    
    func authenticate(with credentials: Credentials){
        signIn(credentials: credentials)
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
    
    func getToken() -> String {
        return getTokenFromKeychain()
    }
    
    func getEmail() -> String {
        return getEmailAddressFromKeychain()
    }
    
    func savePasscode(passcode: [Int]){
        savePasscodeToKeychain(passcode: passcode)
    }
    
    func getPasscode() -> [Int] {
        return getPasscodeFromKeychain()
    }
    
    func authenticateUsingPasscode(){
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
                    print("Came")
                    self?.saveTokenToKeychain()
                    if !KeychainManager.itemExists(service: Constants.USER_CEREDENTIALS, account: Constants.SARQYT_ACCOUNT){
                        self?.saveUserCredentials(credentials: credentials)
                    }
                    self?.signInSubscription?.cancel()
                }

        }catch let error{
            print("Error occured: \(error.localizedDescription)")
        }
    }
    
    func signOut(){
        let urlString = Constants.BASE_URL + Constants.SIGN_OUT
        let token = getToken().trimmingCharacters(in: .whitespacesAndNewlines)
        guard var request = AuthManager.constructRequest(for: urlString) else {
            print("Error creating request")
            return
        }
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        signOutSubscription = NetworkingManager.post(request: request)
            .sink(receiveCompletion: NetworkingManager.handleCompletion) {[weak self] _ in
                print("Signed out")
                self?.signOutSubscription?.cancel()
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
        print("sign up user saved to Keychain: \(authenticated())")
    }
    
    private func getTokenFromKeychain() -> String{
        if let data = KeychainManager.read(service: Constants.ACCESS_TOKEN, account: Constants.SARQYT_ACCOUNT){
            let token = String(data: data, encoding: .utf8) ?? ""
            return token
        }
        return ""
    }
    
    private func getEmailAddressFromKeychain() -> String{
        if let data = KeychainManager.read(service: Constants.USER_CEREDENTIALS, account: Constants.SARQYT_ACCOUNT){
            if let user = try? JSONDecoder().decode(Credentials.self, from: data){
                return user.email
            }
        }
        return ""
    }
    
    private func savePasscodeToKeychain(passcode: [Int]){
        do {
            let encodedPasscode = try JSONEncoder().encode(passcode)
            KeychainManager.save(encodedPasscode, service: Constants.PASSCODE, account: Constants.SARQYT_ACCOUNT)
        } catch let error {
            print("Error encoding and saving passcode to Keychain: \(error.localizedDescription)")
        }
    }
    
    private func getPasscodeFromKeychain() -> [Int]{
        if let passcodeData = KeychainManager.read(service: Constants.PASSCODE, account: Constants.SARQYT_ACCOUNT){
            do {
                let passcode = try JSONDecoder().decode([Int].self, from: passcodeData)
                return passcode
            } catch let error {
                print("Error decoding passcode: \(error.localizedDescription)")
            }
        }
        return Array(repeating: -1, count: 4)
    }
}
