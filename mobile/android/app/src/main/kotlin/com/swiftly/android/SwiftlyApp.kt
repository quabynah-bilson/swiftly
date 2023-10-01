package com.swiftly.android

import android.app.Application
import io.maido.intercom.IntercomFlutterPlugin

class SwiftlyApp : Application() {
    override fun onCreate() {
        super.onCreate()
        IntercomFlutterPlugin.initSdk(
            this,
            appId = /*BuildConfig.INTERCOM_APP_ID ?:*/ "geg6j824",
            androidApiKey = /*BuildConfig.INTERCOM_ANDROID_KEY ?:*/ "android_sdk-234d96022429300471a8279c4c216ebf10a75d35"
        )
    }
}