package io.qcodelabsllc.swiftly.mobile
import android.app.Application
import io.maido.intercom.IntercomFlutterPlugin

class SwiftlyApp : Application() {
    override fun onCreate() {
        super.onCreate()
        // Add this line with your keys
        IntercomFlutterPlugin.initSdk(this, appId = "geg6j824", androidApiKey = "android_sdk-234d96022429300471a8279c4c216ebf10a75d35")
    }
}