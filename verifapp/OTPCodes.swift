//
//  OTPCodes.swift
//  VerifAppSDK
//
//  Created by Hashim Khan on 15/11/2021.

import Foundation
public enum OTPCodes{
    // region ERROR
    case REQUEST_IN_PROGRESS
    case INVALID_OTP
    case APP_SIGNATURE_ERROR
    case INVALID_SDK_API_KEY
    case USER_NOT_VERIFIED
    case INVALID_PHONE_NUMBER
    case NETWORK_ERROR
    case CALL_NOT_RECEIVED
    case SMS_SENDING_FAILED
    case SMS_NOT_RECEIVED
    case ERROR_INIT_CALL
    case NUMBER_NOT_VERIFIED
    case PERMISSION_REQUIRED
    case SDK_NOT_INITIALIZED
    case RETRYING_NEXT_OTP
    // endregio
    // region MI
    case SIM_CHANGED
    case SIM_NOT_READY
    case VALID_USER
    case NO_INTERNET
    case SDK_INITIALIZED
    case OTP_SENT
    // endregion
}
