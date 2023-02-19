//
//  KeychainService.swift
//  RestaurantBooking
//
//  Created by Raiymbek Merekeyev on 19.02.2023.
//

import Foundation

final class KeychainService{
    
    static let shared = KeychainService()
    
    private init(){}
    
    enum KeychainError: Error{
        case itemAlreadyExists
        case itemNotFound
        case errorStatus(String?)
        
        init(status: OSStatus){
            switch status{
            case errSecDuplicateItem:
                self = .itemAlreadyExists
            case errSecItemNotFound:
                self = .itemNotFound
            default:
                let message = SecCopyErrorMessageString(status, nil) as String?
                self = .errorStatus(message)
            }
        }
    }
    
    func save<T>(_ item: T, service: String, account: String) where T: Codable{
        do {
            let data = try JSONEncoder().encode(item)
            save(data, service: service, account: account)
        } catch let error {
            print("Error encoding item: \(error)")
        }
    }
    
    func read<T>(service: String, account: String, type: T.Type) -> T? where T: Codable{
        guard let data = read(service: service, account: account) else{ return nil}
        
        do {
            let item = try JSONDecoder().decode(type, from: data)
            return item
        } catch let error {
            print("Error decoding item: \(error)")
            return nil
        }
    }
}

extension KeychainService{
    private func save(_ data: Data, service: String, account: String){
        let query = [
            kSecValueData: data,
            kSecClass: kSecClassGenericPassword,
            kSecAttrService: service,
            kSecAttrAccount: account
        ] as CFDictionary
        
        let status = SecItemAdd(query, nil)
        
        if status != errSecSuccess{
            print("Error: \(status)")
        }
        
        if status == errSecDuplicateItem{
            let query = [
                kSecAttrService: service,
                kSecAttrAccount: account,
                kSecClass: kSecClassGenericPassword,
            ] as CFDictionary
            
            let attributesToUpdate = [kSecValueData: data] as CFDictionary
            
            SecItemUpdate(query, attributesToUpdate)
        }
    }
    
    private func read(service: String, account: String) -> Data? {
        
        let query = [
            kSecAttrService: service,
            kSecAttrAccount: account,
            kSecClass: kSecClassGenericPassword,
            kSecReturnData: true
        ] as CFDictionary
        
        var result: AnyObject?
        SecItemCopyMatching(query, &result)
        return (result as? Data)
    }
    
    private func delete(service: String, account: String){
        
        let query = [
            kSecAttrService: service,
            kSecAttrAccount: account,
            kSecClass: kSecClassGenericPassword
        ] as CFDictionary
        
        SecItemDelete(query)
    }
}
