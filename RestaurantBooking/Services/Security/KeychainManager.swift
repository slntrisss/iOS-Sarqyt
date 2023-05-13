//
//  KeychainManager.swift
//  RestaurantBooking
//
//  Created by Raiymbek Merekeyev on 02.04.2023.
//

import AuthenticationServices

class KeychainManager{
    static func save(_ data: Data, service: String, account: String){
        let query = [
            kSecValueData: data,
            kSecClass: kSecClassGenericPassword,
            kSecAttrService: service,
            kSecAttrAccount: account,
        ] as CFDictionary
        
        let saveStatus = SecItemAdd(query, nil)
        
        if saveStatus != errSecSuccess{
            print("Error saving data.")
        }else{
            print("Data saved to Keychain.")
        }
        
        if saveStatus == errSecDuplicateItem{
            update(data, service: service, account: account)
        }
    }
    
    static func update(_ data: Data, service: String, account: String){
        let query = [
            kSecAttrService: service,
            kSecAttrAccount: account,
            kSecClass: kSecClassGenericPassword,
        ] as CFDictionary
        
        let attributesToUpdate = [kSecValueData: data] as CFDictionary
        
        let updateStatus = SecItemUpdate(query, attributesToUpdate)
        
        if updateStatus == errSecItemNotFound{
            print("Cannot update Keychain data, item not found.")
        }else{
            print("Item updated.")
        }
    }
    
    static func read(service: String, account: String) -> Data? {
        let query = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrService: service,
            kSecAttrAccount: account,
            kSecReturnData: true
        ] as CFDictionary
        
        var result: AnyObject?
        SecItemCopyMatching(query, &result)
        
        return result as? Data
    }
    
    static func itemExists(service: String, account: String) -> Bool{
        let query = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrAccount : account,
            kSecAttrService : service,
            kSecMatchLimit : kSecMatchLimitOne,
            kSecReturnAttributes : true,
            kSecReturnData : true
        ] as CFDictionary
        var item: CFTypeRef?
        let status = SecItemCopyMatching(query as CFDictionary, &item)
        
        guard status != errSecItemNotFound else {
            return false
        }
        
        return true
    }
    
    static func delete(service: String, account: String){
        let query = [
            kSecAttrService: service,
            kSecAttrAccount: account,
            kSecClass: kSecClassGenericPassword,
        ] as CFDictionary
        
        
        SecItemDelete(query)
    }
}
