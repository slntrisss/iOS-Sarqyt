//
//  AuthManager.swift
//  RestaurantBooking
//
//  Created by Raiymbek Merekeyev on 22.04.2023.
//

import Foundation
import Combine

class AuthManager{
    
    static func post(request: URLRequest) -> AnyPublisher<Data, Error>{
        URLSession.shared.dataTaskPublisher(for: request)
            .subscribe(on: DispatchQueue.global(qos: .default))
            .tryMap({ try AuthManager.handleURLResponse(output: $0) })
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
    static func constructRequest(for urlString: String) -> URLRequest?{
        guard let url = URL(string: urlString) else {
            print("BAD URL: \(urlString)")
            return nil
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        return request
    }
    
    static func handleURLResponse(output: URLSession.DataTaskPublisher.Output) throws -> Data {
        guard let response = output.response as? HTTPURLResponse else{
            print("Error occured while unwrapping response.")
            throw URLError(.badServerResponse)
        }
        if response.statusCode == 400{
            if let errorResponse = try? JSONDecoder().decode(String.self, from: output.data){
                throw NetworkingError.authError(message: errorResponse)
            }
        }
        if response.statusCode == 401{
            throw NetworkingError.unauthorizedAccess
        }
        return output.data
    }
}
