//
//  OTPListener.swift
//  VerifAppSDK
//
//  Created by Hashim Khan on 15/11/2021.

import Foundation

public protocol OtpListener{
    
    //MARK: Functions
    
    func PhoneNumberVerified(method: String, isVerified: Bool)
    
    //----------------------------------------
    
    func onNotifyUser(code: OTPCodes, message: String, timeOut: Int64)
    
    //----------------------------------------
    
}
