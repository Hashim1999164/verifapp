//
//  AuthUtils.swift
//  VerifAppSDK
//
//  Created by Hashim Khan on 15/11/2021.
//

import Foundation
import SwiftKeychainWrapper

struct AuthUtils{
   
    
    //------------------------------- -----------------
    
    func save0AuthToken(response: String, expiresIn: Int) {
        var saveSuccessful: Bool = KeychainWrapper.standard.set(response, forKey: Appstatemanager.shared.CurrentPreferences.ACCESS_TOKEN)
        if(saveSuccessful){
            print( "Token saved Successfully")
            let dateFormatter : DateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MMM-dd HH:mm:ss"
            let date = Date()
            let dateString = dateFormatter.string(from: date)
            let EXPIRES_IN = date.addingTimeInterval(TimeInterval((expiresIn - 1)))
            saveSuccessful = KeychainWrapper.standard.set(Data(from: EXPIRES_IN), forKey: Appstatemanager.shared.CurrentPreferences.EXPIRES_IN)
            if(saveSuccessful){
                print("Token Time Set Successfully")
                return
            }
            print("Token Time Saving Failed")
            return
        }
        print("Token Saving Failed")
    }
    
    //------------------------------------------------
    func requestNewAccessToken() -> Bool {
        // Calling initializing function againnnnnnnn!!!!! ):
        return false
    }
    
    //------------------------------------------------
    func get0AuthToken() -> String {
        return KeychainWrapper.standard.string(forKey: Appstatemanager.shared.CurrentPreferences.ACCESS_TOKEN) ?? ""
    }
    
    //------------------------------------------------
    func get0AuthTokenTime() -> Date {
        let recievedData = KeychainWrapper.standard.data(forKey: Appstatemanager.shared.CurrentPreferences.EXPIRES_IN)
        let time = recievedData?.to(type: Date.self)
        return time ?? Date()
    }
    
    //------------------------------------------------
    func validateToken() -> Bool {
        let Accesstoken = get0AuthToken()
        var result = get0AuthTokenTime()
        let dateFormatter : DateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MMM-dd HH:mm:ss"
        let date = Date()
        if(result <= date || Accesstoken == ""){ //Request new token in case token is expired
            requestNewAccessToken()
        }
        return (result >= date && Accesstoken != "")
    }
}
