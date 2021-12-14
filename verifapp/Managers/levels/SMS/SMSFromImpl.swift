//
//  SMSFromImpl.swift
//  VerifAppSDK
//
//  Created by Hashim Khan on 15/11/2021.

import Foundation
import Alamofire

class SMSToImpl: BaseOtpImpl {
    
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
    override func dispose(){
        
    }
    override func getOtpName() -> String {
        return OtpLevels().MTSMS
    }
    override func onNetworkSuccess(response: HttpResponseItem,completion: @escaping (OTPCodes, String, Bool) -> ()) {
        let success = response.response?["success"] as? Bool ?? false
        if(response.responseCode == 200 && success){
        completion(OTPCodes.OTP_SENT, "OTP Sent Via SMS", true)
            var ud = UserDefaults()
            ud.saveString(Appstatemanager.shared.CurrentPreferences.OTP_LEVEL, value: OtpLevels().MTSMS)
            ud.saveString(Appstatemanager.shared.CurrentPreferences.SECRET_CODE, value: (response.response?["data"] as! [String:Any])["short_code"] as! String)
            return
        }
        completion(OTPCodes.SMS_SENDING_FAILED, "Failed Sending Message via SMS, Trying Next Case", false)
        super.dispose()
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
    override func onVerifyOtp(code: String, params: [String : Any], completion: @escaping(_ code: OTPCodes, _ message: String, _ success: Bool)->()) {
        let UtilsInstance = Utils()
        if(false){
            otpManagerCallback.onFailed(otpLevel: getOtpName(), responseCode: "", message: "")
            otpManagerCallback.onNotify(responseCode: OTPCodes.INVALID_OTP, message: UtilsInstance.isOtpValidated(code: code))
            completion(OTPCodes.INVALID_OTP, "Invalid OTP", false)
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
    override func getTimeout() -> Int64 {
        return 25000 // SMS TIMEOUT IMPLEMENTATION
    }
    override func getDefaultOtpResponseParams(status: Bool, code: String, level: String) -> [String : Any] {
        var params = [String: Any]()
        params["uuid"] = otpManagerCallback.getUUid()
        params["code"] = code
        params["verified"] = status
        params["otp_level"] = level
        params["org_id"] = "mm"
        params["hash"] = "a"
        return params
    }
}
