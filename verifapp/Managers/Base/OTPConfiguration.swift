//
//  OTPConfiguration.swift
//  VerifAppSDK
//
//  Created by Hashim Khan on 15/11/2021.

import Foundation

struct OtpConfiguration {
    
    
    var otplevel = OtpLevels()
    
    /**
     * Returns next otp level from the Otp list.
     * @param current: current Otp level.
     * @param scope: Scope value returned in the token Api response.
     */
    
    func getNextOtp(current: String?, scope: String) -> String? {
        var otpList = OtpConfiguration().getOtpsList(scope: scope)
        if(current == ""){
            //save in log "current otp is null getting first in the list"
            return otpList[0]
        }
        else{
            var index = otpList.index(of: current ?? "")
            if((index ?? 0) + 1 < otpList.count){
                return otpList[(index ?? 0) + 1]
            }
        }
        return ""
    }
    /**
     * returns an Otp list on the base of provided token scope.
     * @param scope: Scope value retiurned from token Api
     */
    func getOtpsList(scope: String) -> [String] {
        var UtilsInstance = Utils()
        if(UtilsInstance.isNumberLocal(number: UtilsInstance.getPhoneNumber())){
            if(!scope.isEmpty){
                if(scope.contains("app-permission")){
                    return getLocalPermissionOtpList()
                }
                else if(scope.contains("app-nonpermission")){
                    return getLocalNonPermissionOtpList()
                }
            }
            else{
                getLocalNonPermissionOtpList()
            }
        }
        else {
            if(!scope.isEmpty){
                if(scope.contains("app-permission")){
                    return getInternationalPermissionOtpList()
                }
                else if(scope.contains("app-nonpermission")){
                    return getInternationalNonPermissionOtpList()
                }
            }
            else {
                getInternationalNonPermissionOtpList()
            }
        }
        return getLocalNonPermissionOtpList()
    }
    private func getLocalPermissionOtpList() -> [String] {
        return [otplevel.MTCALL, otplevel.MTSMS, otplevel.WHATSAPP_SMS]
    }
    
    private func getLocalNonPermissionOtpList() -> [String] {
        return [ otplevel.MTSMS, otplevel.WHATSAPP_SMS]
    }
    
    private func getInternationalPermissionOtpList() -> [String] {
        return [otplevel.MTSMS, otplevel.MTCALL, otplevel.WHATSAPP_SMS, otplevel.MTSMS]
    }
    
    private func getInternationalNonPermissionOtpList() -> [String] {
        return [otplevel.MTSMS, otplevel.WHATSAPP_SMS]
    }
}

