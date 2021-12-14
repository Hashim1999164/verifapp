//
//  SharedPreferenceManager.swift
//  VerifAppSDK
//
//  Created by Hashim Khan on 15/11/2021.

import Foundation

class SharedPreferenceManager{
    
    private var instance: SharedPreferenceManager? = nil
    
    private var editor = UserDefaults()
    
    
    /**
     * Clear all values in [SharedPreferences]
     */
    func clearPreferences(){
        Appstatemanager.shared.CurrentPreferences.delete()
    }
    /**
     * Read string value from [SharedPreferences]
     *
     * @param valueKey     key
     * @return string value
     */
    func read(valueKey: String) -> String {
        return UserDefaults().getString(valueKey)
    }
    /**
     * Read Bool value from [SharedPreferences]
     *
     * @param valueKey     key
     * @return string value
     */
    func read(valueKey: String) -> Bool {
        return UserDefaults().getBool(valueKey)
    }
    /**
     * Read Int value from [SharedPreferences]
     *
     * @param valueKey     key
     * @return string value
     */
    func read(valueKey: String) -> Int {
        return UserDefaults().getInt(valueKey)
    }
    /**
     * Save String value in [SharedPreferences]
     *
     * @param valueKey key
     * @param value    default value
     */
    func save(valueKey: String, value: String) {
        UserDefaults().saveString(valueKey, value: value)
    }
    /**
     * Save Bool value in [SharedPreferences]
     *
     * @param valueKey key
     * @param value    default value
     */
    func save(valueKey: String, value: Bool) {
        UserDefaults().saveBool(valueKey, value: value)
    }
    /**
     * Save Int value in [SharedPreferences]
     *
     * @param valueKey key
     * @param value    default value
     */
    func save(valueKey: String, value: Int) {
        UserDefaults().saveInt(valueKey, value: value)
    }
    /**
     * There must be only one instance of [SharedPreferences] or [SharedPreferenceManager]
     * If you will try to create another instance exception arises
     *
     *
     */
    func setSingletonInstance() {
        
    }
    
    
    static func getPreferenceInstance() -> SharedPreferenceManager {
        return SharedPreferenceManager()
    }
}
