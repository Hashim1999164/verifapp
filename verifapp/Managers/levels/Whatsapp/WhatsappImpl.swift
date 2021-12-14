//
//  WhatsappImpl.swift
//  VerifAppSDK
//
//  Created by Hashim Khan on 15/11/2021.

import Foundation
import Alamofire

/*
 * This class is responsible to perform a whatsapp verification process, in which the server sends a
 * verification code on whatsapp and user needs to manually enter the code into the sdk to verify the number.
 */

class WhatsappImpl: BaseOtpImpl {
    
    
    var OTPManagerCallback: OtpManagerCallback?
    
    override init(){
        super.init()
    }
    
    override func getNetworkRequest(
        params: [String: Any]
    ) -> HTTPRequestItem {
        var newReqItem = HTTPRequestItem(httpRequestUrl: prepareRequestUrl())
        newReqItem.EncodingType = JSONEncoding.default
        if (!(OTPManagerCallback?.getLastFailedUseCaseObject().isEmpty ?? true)){
            //params["err_obj"] = OTPManagerCallback?.getLastFailedUseCaseObject()
        }
        newReqItem.params = params
        return newReqItem
    }
    override func getVerifyRequest(
        params: [String: Any]
    ) -> HTTPRequestItem {
        var newReqItem = HTTPRequestItem(httpRequestUrl: prepareVerifyUrl())
        
        newReqItem.EncodingType = JSONEncoding.default
        newReqItem.params = params
        newReqItem.params["OS"] = "iOS"
        newReqItem.params["manufacturer"] = "Apple"
        newReqItem.params["brand"] = "Apple"
        newReqItem.params["model"] = UIDevice.modelName
        newReqItem.params["short_code"] = UserDefaults().getString(Appstatemanager.shared.CurrentPreferences.SECRET_CODE)
        newReqItem.headerParams["tenant_id"] = "1"
        newReqItem.headerParams["Content-Type"] = "application/json"
        newReqItem.headerParams["Authorization"] = "Bearer " + AuthUtils().get0AuthToken()
        return newReqItem
    }
    override func getTimeout() -> Int64 {
        return 45000 // WHATSAPP TIMEOUT IMPLEMENTATION
    }
    override func dispose(){
        
    }
    override func getOtpName() -> String {
        return OtpLevels().WHATSAPP_SMS
    }
    override func onNetworkSuccess(response: HttpResponseItem, completion: @escaping (OTPCodes, String, Bool) -> ()) {
        UserDefaults().saveString(Appstatemanager.shared.CurrentPreferences.OTP_LEVEL, value: OtpLevels().WHATSAPP_SMS)
        completion(OTPCodes.OTP_SENT, "OTP Sent Via Whatsapp", true)
    }
    override func onNetworkError(response: HttpResponseItem,completion: @escaping(_ code: OTPCodes,_ message: String,_ success: Bool)->()){
        if(response.responseCode == 100){
            completion(OTPCodes.NETWORK_ERROR, "Network Reachability Error", false)
            return
        }
        else if(response.responseCode == 401){
            completion(OTPCodes.INVALID_SDK_API_KEY, "Invalid API Key", false)
            return
        }
        else if(response.responseCode == 403){
            completion(OTPCodes.NETWORK_ERROR, "Request Forbidden", false)
            return
        }
        else if(response.responseCode == 400){
            completion(OTPCodes.SDK_NOT_INITIALIZED, "Parameters Error", false)
            return
        }
        else if(response.responseCode > 100 && response.responseCode < 200){
            completion(OTPCodes.NETWORK_ERROR, "Request Timed out", false)
            return
        }
        else {
            completion(OTPCodes.NETWORK_ERROR, "Request Failed", false)
            return
        }
    }
    private func sendSMS(reciever: String, code: String){
        
    }
    override func onVerifyOtp(code: String, params: [String : Any], completion: @escaping (OTPCodes, String, Bool) -> ()) {
        var UtilsInstance = Utils()
        if(UtilsInstance.isOtpValidated(code: code).isEmpty){
            completion(OTPCodes.INVALID_OTP, "OTP Code Invalid", false)
            return
        }
        var UD = UserDefaults()
        var scope = UD.string(forKey: Appstatemanager.shared.CurrentPreferences.SCOPE)
        var savedScope = ""
        if((scope?.contains("app-permission")) != nil){
            savedScope = "permission"
        }
        else{
            savedScope = "non-permission"
        }
        
        verify(params: params, completion: {
            (code, message, success) in
            completion(code,message,success)
        })
    }
    /**
     * Provides all the parameters required to perform a verify request.
     */
    override func getDefaultOtpResponseParams(
        status: Bool,
        code: String,
        level: String
    ) -> [String: Any] {
        var params = [String: Any]()
        params["uuid"] = otpManagerCallback.getUUid()
        params["code"] = code
        params["verified"] = status
        params["otp_level"] = level
        params["org_id"] = "mm"
        return params
    }
    /**
     * Stops timer when an Otp times out or if it is stopped forcefully.
     * @param hardStop: Check if the otp process was stopped forcefully.
     * @param level: Otp level that was stopped.
     */
    override func onOtpTimeout(hardStop: Bool, level: String) {
        if (hardStop) {
            return
        } else {
            otpManagerCallback.onTimeout(otpLevel: level)
        }
    }
    
}
