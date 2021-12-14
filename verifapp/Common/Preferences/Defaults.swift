//
//  Defaults.swift
//  VerifAppSDK
//
//  Created by Hashim Khan on 16/11/2021.

import Foundation

class Appstatemanager : NSObject {
    
    static var shared = Appstatemanager()
    var token: String! {
        get{
            if(AuthUtils().get0AuthToken() != ""){
                AuthUtils().get0AuthToken()
            }
            return ""
        }
        set {
            // will be only one way!
        }
    }
    var CurrentPreferences: PreferenceUtils! {
        get{
            PreferenceUtils().get()
        } set {
            PreferenceUtils().save(newValue)
        }
    }
    
}

extension UserDefaults {
    
    func set<T: Encodable>(codable: T, forKey key: String) {
        let encoder = JSONEncoder()
        do {
            let data = try encoder.encode(codable)
            let jsonString = String(data: data, encoding: .utf8)!
            print("Saving \"\(key)\": \(jsonString)")
            self.set(jsonString, forKey: key)
        } catch {
            print("Saving \"\(key)\" failed: \(error)")
        }
    }
    
    func codable<T: Decodable>(_ codable: T.Type, forKey key: String) -> T? {
        guard let jsonString = self.string(forKey: key) else { return nil }
        guard let data = jsonString.data(using: .utf8) else { return nil }
        let decoder = JSONDecoder()
        print("Loading \"\(key)\": \(jsonString)")
        return try? decoder.decode(codable, from: data)
    }
    func saveString(_ key: String, value: String){
        UserDefaults.standard.set(codable: value, forKey: key)
    }
    func saveBool(_ key: String, value: Bool){
        UserDefaults.standard.set(codable: value, forKey: key)
    }
    func saveInt(_ key: String, value: Int){
        UserDefaults.standard.set(codable: value, forKey: key)
    }
    func saveInt64(_ key: String, value: Int64){
        UserDefaults.standard.set(codable: value, forKey: key)
    }
    func deleteString(_ key: String){
        UserDefaults.standard.set(codable: "", forKey: key)
    }
    func deleteBool(_ key: String){
        UserDefaults.standard.set(codable: false, forKey: key)
    }
    func deleteInt(_ key: String){
        UserDefaults.standard.set(codable: -1, forKey: key)
    }
    func deleteInt64(_ key: String){
        UserDefaults.standard.set(codable: -1, forKey: key)
    }
    func getString(_ key: String) -> String{
        return UserDefaults.standard.codable(String.self, forKey: key) ?? ""
    }
    func getBool(_ key: String) -> Bool{
        return UserDefaults.standard.codable(Bool.self, forKey: key) ?? false
    }
    func getInt(_ key: String) -> Int{
        return UserDefaults.standard.codable(Int.self, forKey: key) ?? -1
    }
    func getInt64(_ key: String) -> Int64{
        return UserDefaults.standard.codable(Int64.self, forKey: key) ?? -1
    }
}
