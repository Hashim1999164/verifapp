//
//  BaseOTPImpl.swift
//  VerifAppSDK
//
//  Created by Hashim Khan on 15/11/2021.

import Foundation
import Alamofire
class BaseOtpImpl: OnNetworkResponseCallBack, OTPTimeoutCallback{
    
    init(){
        
    }
    init(otpManagerCallBack: OtpManagerCallback){
        
    }
    var otpManagerCallback: OtpManagerCallback!
    //----------------From Protocols
    var isnetworkConnected: Bool{
        get {
            return false
        }
    }
    
    func onNetworkResponse(response: HttpResponseItem, completion: @escaping (OTPCodes, String, Bool) -> ()) {
        
    }
    
    func onNetworkSuccess(response: HttpResponseItem, completion: @escaping (OTPCodes, String, Bool) -> ()) {
        
    }
    
    func onNetworkError(response: HttpResponseItem, completion: @escaping (OTPCodes, String, Bool) -> ()) {
        
    }
    
    func onNetworkCanceled(response: HttpResponseItem, completion: @escaping (OTPCodes, String, Bool) -> ()) {
        
    }
    
    func onOtpTimeout(hardStop: Bool, level: String) {
        
    }
    //------------------------------------------
    
    //MARK: Variables
    var TAG = "BaseOtpImpl"
    var otpTimer: OtpTimeoutPresenter? = nil
    
    //MARK: Abstract Functions
    func getNetworkRequest(params: [String: Any]) -> HTTPRequestItem{
        //METHOD TO OVERRIDE
        return HTTPRequestItem()
    }
    func getVerifyRequest(params: [String: Any]) -> HTTPRequestItem{
        //METHOD TO OVERRIDE
        return HTTPRequestItem()
    }
    func getOtpName() -> String{
        return ""
    }
    func onVerifyOtp(code: String, params: [String: Any], completion: @escaping(_ code: OTPCodes, _ message: String, _ success: Bool)->()){
        
    }
    //----------------------------------
    //MARK: Functions
    public func dispose(){
        
        OtpManager().otp?.dispose()
    }
    /**
     * Prepares a request url for the respective Otp level
     */
    func prepareRequestUrl() -> String{
        let currentScope = getCurrentScope()
        return OtpApiManager().prepareUrl(currentScopeisPermission: false, otpLevel: getOtpName(), isVerifyURL: false)
    }
    /**
     * Prepares a verify url for the respective Otp level
     */
    func prepareVerifyUrl() -> String {
        let currentScope = getCurrentScope()
        return OtpApiManager().prepareUrl(currentScopeisPermission: false, otpLevel: getOtpName(), isVerifyURL: true)
    }
    /**
     * Returns the time out duration for the current Otp level.
     */
    func getTimeout() -> Int64{
        return -1
    }
    /**
     * Returns the scope saved from token api's response.
     */
    private func getCurrentScope() -> String {
        let manager = SharedPreferenceManager.getPreferenceInstance()
        let scope = manager.read(valueKey: Appstatemanager.shared.CurrentPreferences.SCOPE) ?? "default"
        if (scope == "app-permission"){
            return "permission/"
        }
        else if (scope == "app-nonpermission"){
            return "nonpermission/"
        }
        else if (scope == "default"){
            return "nonpermission/"
        }
        else{
            return "nonpermission/"
        }
    }
    
    func proceed(completion: @escaping(_ code: OTPCodes, _ message: String, _ timeout: Int64,_ success: Bool) -> ()){
        var item = self.getNetworkRequest(params: self.getDefaultOtpRequestParams())
        item.httpRequestUrl = prepareRequestUrl()
        item.headerParams =
        [
            "Authorization": "Bearer " + AuthUtils().get0AuthToken(),
            "tenant_id": "1"
        ]
        item.EncodingType = JSONEncoding.default
        if(item == nil){
            completion(OTPCodes.SMS_SENDING_FAILED, "NO API details found for this use-case", -1 , false)
        }
        if(getOtpName() == getOtpName()){
            NetworkUtils().executeNetworkRequest(params: item, completion: {
                response in
                if(response.responseCode == 200){
                    self.onNetworkSuccess(response: response, completion: {
                        (code, message, success) in
                        completion(code, message,self.getTimeout(), success)
                        if(success){
                        OtpTimeoutThreadImpl().startProcess(Timeout: self.getTimeout(), completion: {
                            (code, message, timeout, success) in
                            completion(code, message, self.getTimeout(), success)
                            return
                        })
                        }
                    })
                    return
                }
                else{
                    self.onNetworkError(response: response, completion: {
                        (code, message, success) in
                        completion(code, message, -1, success)
                    })
                    return
                }
            })
        }
        //completion line!
        
    }
    func verify(params: [String: Any], completion: @escaping(_ code: OTPCodes, _ message: String,_ success: Bool)-> ()){
        var NM = NetworkUtils()
        NM.executeNetworkRequest(params: getVerifyRequest(params: params), completion: {
            response in
            if(response.responseCode == 200){
                if(response.response?["success"] as! Bool){
                    completion(OTPCodes.VALID_USER, "User Verified Successfully", true)
                    OtpTimeoutThreadImpl().haltProcess()
                    self.dispose()
                }
                else{
                    completion(OTPCodes.INVALID_OTP, "User Verification Failed", false)
                }
            }
            else{
                completion(OTPCodes.USER_NOT_VERIFIED, "Verification Failed", false)
            }
        })
    }
    private func getDefaultOtpRequestParams() -> [String: Any] {
        var UtilsInstance = Utils()
        let params: [String: Any] = [
            "cellno": UtilsInstance.getPhoneNumber(),
            "dialing_code" : UtilsInstance.getDialingCode(phoneNumber: UtilsInstance.getPhoneNumber()),
            "operator_code" : UtilsInstance.getDialingCode(phoneNumber: UtilsInstance.getPhoneNumber()),
            "uuid" : UIDevice.current.identifierForVendor?.uuidString ?? "",
            "org_id" : "mm",
            "hash" : Utils().getHash(),
            "OS":"iOS",
            "manufacturer":"Apple",
            "brand":"Apple",
            "model": UIDevice.modelName
        ]
        return params
    }
    func getDefaultOtpResponseParams( //---------> Function Name
        status: Bool,  //------------|
        code: String,  //            |---> Parameters
        level: String  //------------|
    ) -> [String: Any] {// ---> Return Type
        
        let params: [String: Any] = [
            "uuid" : UIDevice.current.identifierForVendor?.uuidString ?? "",
            "code" : code,
            "verified" : status,
            "otp_level" : level,
            "org_id" : "mm",
            "hash": Utils().getHash()
        ]
        return params
    }
}
