//
//  OTPTimeoutPresenter.swift
//  VerifAppSDK
//
//  Created by Hashim Khan on 15/11/2021.

import Foundation

protocol OtpTimeoutPresenter {
    
    //-------------------------------------------
    func startProcess(Timeout: Int64, completion: @escaping(_ code: OTPCodes, _ message: String, _ timeout: Int64,_ success: Bool)-> ())
    func haltProcess()
    //-------------------------------------------
}
