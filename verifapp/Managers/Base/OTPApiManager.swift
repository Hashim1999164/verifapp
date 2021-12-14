//
//  OTPApiManager.swift
//  VerifAppSDK
//
//  Created by Hashim Khan on 15/11/2021.

import Foundation

class OtpApiManager{
    //MARK: Constructor
    init(){
        
    }
    //MARK: Functions
    /**
     *This method prepares a request URl for the current Otp level provided
     * @param currentScope Otp scope which is fetched with token api
     * @param otpLevel Current otp level for which the request url is required
     */
    func prepareUrl(
        currentScopeisPermission: Bool,
        otpLevel: String,
        isVerifyURL: Bool
    ) -> String {
        var otplevel = OtpLevels()
        var constantInstance = Constants()
        var Verify = ""
        var scope = "app-permission/1"
        if(!currentScopeisPermission){
            scope = "app-nonpermission/1"
        }
        if(isVerifyURL){
            Verify = "/verify"
        }
        if(otpLevel == otplevel.WHATSAPP_SMS){
            return constantInstance.BASE_API_SERVER_WITH_PORT + scope + constantInstance.API_WHATSAPP + Verify
        }
        else if(otpLevel == otplevel.MTSMS){
            return constantInstance.BASE_API_SERVER_WITH_PORT + scope + constantInstance.API_SMSF + Verify
        }
        else if(otpLevel == otplevel.MTCALL){
            return constantInstance.BASE_API_SERVER_WITH_PORT + scope + constantInstance.API_FCFS + Verify
        }
        
        return ""
    }
}
