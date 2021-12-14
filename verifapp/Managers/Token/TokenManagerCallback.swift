//
//  TokenManagerCallback.swift
//  VerifAppSDK
//
//  Created by Hashim Khan on 15/11/2021.
//

import Foundation

protocol TokenManagerCallBack{
    //------------------------------------------
    func onSDKInitialized(responseCode: OTPCodes, message: String)
    //------------------------------------------
    func isNetworkConnected() -> Bool
}
