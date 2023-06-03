//
//  NetworkingManager.swift
//  RestaurantBooking
//
//  Created by Raiymbek Merekeyev on 17.04.2023.
//

import Combine
import Foundation

class NetworkingManager{
    
    static func download(url: URL) -> AnyPublisher<Data, Error>{
        return URLSession.shared.dataTaskPublisher(for: url)
            .subscribe(on: DispatchQueue.global(qos: .default))
            .tryMap({ try handleURLResponse(output: $0) })
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
    static func download(request: URLRequest) -> AnyPublisher<Data, Error>{
        return URLSession.shared.dataTaskPublisher(for: request)
            .subscribe(on: DispatchQueue.global(qos: .default))
            .tryMap({ try handleURLResponse(output: $0) })
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
    static func post(request: URLRequest) -> AnyPublisher<Data, Error>{
        return URLSession.shared.dataTaskPublisher(for: request)
            .subscribe(on: DispatchQueue.global(qos: .default))
            .tryMap({try handleURLResponse(output: $0 )})
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
    static func handleURLResponse(output: URLSession.DataTaskPublisher.Output) throws -> Data{
        guard let response = output.response as? HTTPURLResponse,
              response.statusCode >= 200 && response.statusCode < 300 else {
            throw URLError(.badServerResponse)
        }
        return output.data
    }
    
    static func handleCompletion(completion: Subscribers.Completion<Error>){
        switch completion{
        case .finished:
            break
        case .failure(let error):
            print(error.localizedDescription)
            NotificationCenter.default.post(name: Notification.EmptyLazyLoadData, object: nil)
        }
    }
    
    static func constructURLWith(parameters: [URLQueryItem], url: URL) throws -> URL{
        guard var components = URLComponents(url: url, resolvingAgainstBaseURL: true) else {
            print("Failed to create components from URL: \(url)")
            throw URLError(.badURL)
        }
        
        components.queryItems = parameters
        
        guard let urlWithParameters = components.url else{
            print("Failed to create url with parameters: \(parameters.description)")
            throw NetworkingError.unkown
        }
        
        return urlWithParameters
    }
}
