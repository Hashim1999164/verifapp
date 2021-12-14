//
//  OTPTimeoutCallback.swift
//  VerifAppSDK
//
//  Created by Hashim Khan on 15/11/2021.

import Foundation

protocol OTPTimeoutCallback{
    //MARK: Variables
    
    //MARK: Functions
    func onOtpTimeout(hardStop: Bool, level: String)
}

