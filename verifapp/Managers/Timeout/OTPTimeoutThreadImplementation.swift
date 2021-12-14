//
//  OTPTimeoutThreadImplementation.swift
//  VerifAppSDK
//
//  Created by Hashim Khan on 15/11/2021.

import Foundation

class OtpTimeoutThreadImpl: OtpTimeoutPresenter{
    
    
    var callBack: OTPTimeoutCallback!
    static var isCancelled = Bool()
    private var level = String()
    
    
    var work = DispatchWorkItem(block: {
        // Can perform any code in thread if i want to, but currently there is no need to do so!
    })
    
    
    
    func startProcess(Timeout: Int64, completion: @escaping(_ code: OTPCodes, _ message: String, _ timeout: Int64,_ success: Bool) -> ()) {
        work = DispatchWorkItem(block: {
            print("Thread Timed Out after " + (Timeout/1000).description + " seconds")
            if(!OtpTimeoutThreadImpl.isCancelled){
            completion(OTPCodes.RETRYING_NEXT_OTP, "Retrying Next OTP", Timeout, false)
            }
            OtpTimeoutThreadImpl.isCancelled = false
        })
        DispatchQueue.main.asyncAfter(deadline: .now() + Double(Timeout/1000), execute: work)
        
    }
    
    func haltProcess() {
        OtpTimeoutThreadImpl.isCancelled = true
        work.cancel()
        ///Can Add CallBack Response, currently not seeing any work here
    }
}
