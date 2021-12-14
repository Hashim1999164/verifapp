//
//  OTPManager.swift
//  VerifAppSDK
//
//  Created by Hashim Khan on 15/11/2021.

import Foundation
/*
 
 */
public class OtpManager: OtpListener {
    
    
    
    private var RequestinProcess = false
    
    // PROTOCOLS
    public func PhoneNumberVerified(method: String, isVerified: Bool) {
        
    }
    
    public func onNotifyUser(code: OTPCodes, message: String, timeOut: Int64) {
    
    }
    
    
    //MARK: Constructors
    
    public init(){
        
    }
    
    
    //MARK: Variables
    
    var otp: OtpManagerImpl? = nil
    
    //MARK: Functions
    
    /**
         * Initialize sdk dependencies by delegating control to @link{OtpManager}
         * @param apiKey api key
         * @param context
         */
    public func Initialize(apiKey: String, callBack: OtpListener) {
        if(RequestinProcess){
            callBack.onNotifyUser(code: OTPCodes.REQUEST_IN_PROGRESS, message: "Please Wait for the request to be finished", timeOut: 100)
            return
        }
        RequestinProcess = true
        otp = OtpManagerImpl.getInstance()
        otp?.initialize(apiKey: apiKey, callback: callBack, completion: {
            (message, success, errorCode) in
            if(success){
                callBack.onNotifyUser(code: OTPCodes.SDK_INITIALIZED, message: message, timeOut: 100)
                self.RequestinProcess = false
                return
            }
            else{
                callBack.onNotifyUser(code: OTPCodes.SDK_NOT_INITIALIZED, message: message, timeOut: 100)
                self.RequestinProcess = false
                return
            }
        })
    }
    
    //----------------------------------------------------------
    
    public func verifyPhoneNumber(cellNo: String, callBack: OtpListener) {
        otp = OtpManagerImpl.getInstance()
        if(RequestinProcess){
            callBack.onNotifyUser(code: OTPCodes.REQUEST_IN_PROGRESS, message: "Please Wait for the request to be finished", timeOut: 100)
            return
        }
        RequestinProcess = true
        let phoneNumber = Utils().fixPhoneNumber(phoneNumber: cellNo)
        if(otp == nil){
            // THROW NULL POINTER EXCEPTION
            otp = OtpManagerImpl.getInstance()
            callBack.onNotifyUser(code: OTPCodes.SDK_NOT_INITIALIZED, message: "Please Initialize SDK First", timeOut: -1)
            self.RequestinProcess = false
            return
        }
        otp?.verifyPhoneNumber(phoneNumber: phoneNumber, completion: {
            (code, message, timeout, success) in
            print(code, message, timeout)
            if(code == OTPCodes.SMS_SENDING_FAILED){
                callBack.onNotifyUser(code: code, message: message, timeOut: -1)
                self.RequestinProcess = false
                self.verifyPhoneNumber(cellNo: phoneNumber , callBack: callBack)
            }
            if(code == OTPCodes.RETRYING_NEXT_OTP){
                callBack.onNotifyUser(code: code, message: "Retrying Next OTP", timeOut: -1)
                self.RequestinProcess = false
                self.verifyPhoneNumber(cellNo: phoneNumber , callBack: callBack)
            }
            else if(success){
            callBack.onNotifyUser(code: code, message: message, timeOut: timeout/1000)
                self.RequestinProcess = false
            }
            else{
                callBack.onNotifyUser(code: code, message: message, timeOut: -1)
                self.RequestinProcess = false
            }
            if(code == OTPCodes.NUMBER_NOT_VERIFIED){
                callBack.PhoneNumberVerified(method: "Number Verification Failed", isVerified: false)
                self.RequestinProcess = false
            }
            self.RequestinProcess = false
        })
    }
    
    //----------------------------------------------------------
    
    public func onOTPVerify(otpCode: String, callBack: OtpListener) {
        if(RequestinProcess){
            callBack.onNotifyUser(code: OTPCodes.REQUEST_IN_PROGRESS, message: "Please Wait for the request to be finished", timeOut: 100)
            return
        }
        RequestinProcess = true
        let otplevel = OtpLevels()
        let otpName = UserDefaults().getString(Appstatemanager.shared.CurrentPreferences.OTP_LEVEL)
        if(otpName == otplevel.WHATSAPP_SMS){
            otp?.ManualOtpVerify(code: otpCode, Level: otplevel.WHATSAPP_SMS, completion: {code,message,success in
                if(success){
                callBack.PhoneNumberVerified(method: "Phone Number Verified via " + otpName, isVerified: success)
                    self.dispose()
                }
                else{
                    callBack.PhoneNumberVerified(method: "Verification Failed", isVerified: false)
                }
                self.RequestinProcess = false
            })
        }
        if(otpName == otplevel.MTSMS){
            otp?.ManualOtpVerify(code: otpCode, Level: otplevel.MTSMS, completion: {code,message,success in
                if(success){
                callBack.PhoneNumberVerified(method: "Phone Number Verified via " + otpName, isVerified: success)
                    self.dispose()
                }
                else{
                    callBack.PhoneNumberVerified(method: "Verification Failed", isVerified: false)
                }
                self.RequestinProcess = false
            })
        }
        if(otpName == otplevel.MTCALL){ //NEED TO ASK THE THE NAME OF CALL USECASE
            otp?.ManualOtpVerify(code: otpCode, Level: otplevel.MTCALL, completion: {code,message,success in
                if(success){
                callBack.PhoneNumberVerified(method: "Phone Number Verified via " + otpName, isVerified: success)
                    self.dispose()
                }
                else{
                    callBack.PhoneNumberVerified(method: "Verification Failed", isVerified: false)
                }
                self.RequestinProcess = false
            })
        }
        
    }
    
    //----------------------------------------------------------
    
    public func cancelOTP(){
        otp?.cancelOtp()
    }
    
    //----------------------------------------------------------
    
    public func dispose(){
        cancelOTP()
        otp = OtpManagerImpl.getInstance()
    }
}
