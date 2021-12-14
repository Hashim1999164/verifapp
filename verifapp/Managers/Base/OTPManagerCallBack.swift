//
//  OTPManagerCallBack.swift
//  VerifAppSDK
//
//  Created by Hashim Khan on 15/11/2021.

import Foundation

protocol OtpManagerCallback {
    
    func getUUid() -> String

    func getAppHashCode() -> String

    func onTimeout(otpLevel: String)

    func onSuccess(success: Bool)

    func getLastFailedUseCaseObject() -> [String: Any]

    func onNotify(responseCode: OTPCodes?, message: String?)
 
    func onFailed(otpLevel: String, responseCode: String?, message: String?)

    // fun getOtpManagerCallback(): OtpManagerCallback
}
