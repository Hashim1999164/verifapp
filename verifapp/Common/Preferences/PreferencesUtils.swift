//
//  PreferencesUtils.swift
//  VerifAppSDK
//
//  Created by Hashim Khan on 15/11/2021.

import Foundation

struct PreferenceUtils: Codable {
    let PRIVATE_MODE = 0
    let APP_PREFERENCE_NAME = "mm_otp"
    
    let PHONE_NUMBER = "phone_number"
    let SECRET_CODE = "secret_code"
    let RANDOM_CALLER_ID = "random_caller_id"
    let SIM_SERIAL_NO = "sim_serial"
    
    let ACCESS_TOKEN = "access_token"
    let REFRESH_TOKEN = "refresh_token"
    let EXPIRES_IN = "expires_in"
    let START_TIME_STAMP = "start_time_stamp"
    let CLIENT_ID = "consumer_key"
    let CLIENT_SECRET = "consumer_secret"
    let GRANT_TYPE = "grant_type"
    let SCOPE = "scope"
    let AVAILABLE_SCOPES = "app-permission app-nonpermission"
    let API_KEY = "apikey"
    let OTP_LEVEL = "OTP_LEVEL"
    
    
    func save(_ data: PreferenceUtils){
        
        UserDefaults.standard.set(codable: data, forKey: "Preferences")

    }
    
    
    func delete(){
        
        UserDefaults.standard.set(codable: PreferenceUtils(), forKey: "Preferences")
        
    }
    
    
    func get() -> PreferenceUtils{
        
        return UserDefaults.standard.codable(PreferenceUtils.self, forKey: "Preferences") ?? PreferenceUtils()
    }
}
