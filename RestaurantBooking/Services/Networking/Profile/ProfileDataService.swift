//
//  ProfileDataService.swift
//  RestaurantBooking
//
//  Created by Raiymbek Merekeyev on 22.04.2023.
//

import Foundation
import Combine

class ProfileDataService{
    @Published var user: Userr? = nil
    
    var saveProfileSibscription: AnyCancellable?
    
    static let instance = ProfileDataService()
    let authService = AuthService.shared
    private init(){ }
    
    func save(user: Userr){
        let urlString = Constants.BASE_URL + Constants.PROFILE_BASE_URL
        let token = authService.getToken().trimmingCharacters(in: .whitespacesAndNewlines)
        guard let url = URL(string: urlString) else {
            print("BAD URL: \(urlString)")
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        do{
            let encoder = JSONEncoder()
            encoder.dateEncodingStrategy = .iso8601
            let jsonData = try encoder.encode(user)
            request.httpBody = jsonData
            print("token: \(token)")
            saveProfileSibscription = NetworkingManager.post(request: request)
                .decode(type: Userr.self, decoder: JSONDecoder.decoder)
                .sink(receiveCompletion: NetworkingManager.handleCompletion, receiveValue: { [weak self] fetcjedUser in
                    self?.user = fetcjedUser
                    print("POST request success!")
                    self?.saveProfileSibscription?.cancel()
                })
        }catch let error{
            print("Error occured: \(error.localizedDescription)")
        }
    }
}
