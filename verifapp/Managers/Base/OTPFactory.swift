//
//  OTPFactory.swift
//  VerifAppSDK
//
//  Created by Hashim Khan on 15/11/2021.

import Foundation
/**
 *This class is a factory of all Otp levels, it is responsible for creating an instance of current
 * otp level and send it to [OtpManagerImpl] class to continue verification process
 *
 * Its [build] method takes the name of current otplevel and returns the suitable instance.
 */
class OtpFactory {
    
    /**
     *Takes the name of current otp level and returns the suitable instance.
     * @param type Current otp level name whose instance is required
     * @param callback
     */
    func build(
        type: String,
        callback: OtpManagerCallback,
        uuid: String,
        appHashCode: String
    ) -> BaseOtpImpl? {
        if(type == "MTCALL"){
            return CallToImpl()
        }
        if(type == "MTSMS"){
            return SMSToImpl()
        }
        if(type == "SMSTS"){
            return WhatsappImpl()
        }
        if(type == "WHATSAPP_SMS"){
            return WhatsappImpl()
        }
        
        return BaseOtpImpl()
    }
}
