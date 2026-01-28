package com.student.connect.student_management

import android.content.Intent
import android.os.Bundle
import android.util.Log
import io.flutter.embedding.android.FlutterActivity

class MainActivity : FlutterActivity() {

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        // Handle cold start deep links - app_links will read via getInitialLink()
        handleDeepLinkIntent(intent)
    }

    // Log deep link intents for debugging
    private fun handleDeepLinkIntent(intent: Intent?) {
        val data = intent?.data
        if (data != null) {
            val scheme = data.scheme?.lowercase() ?: ""
            val host = data.host?.lowercase() ?: ""

            val isExternalDeeplink = scheme == "schoolconnect" ||
                                    host.contains("schoolconnect.app")

            if (isExternalDeeplink) {
                Log.d("MainActivity", "Cold start deeplink detected: $data")
                // app_links will handle it via getInitialLink()
            }
        }
    }

    // Intercept deep links to ensure app_links plugin handles them
    // instead of Flutter's built-in deep link handler which resets routes
    override fun onNewIntent(intent: Intent) {
        val data = intent.data
        if (data != null) {
            val scheme = data.scheme?.lowercase() ?: ""
            val host = data.host?.lowercase() ?: ""

            // Check if this is an external deep link
            val isExternalDeeplink = scheme == "schoolconnect" ||
                                    host.contains("schoolconnect.app")

            if (isExternalDeeplink) {
                Log.d("MainActivity", "External deeplink detected: $data")
                Log.d("MainActivity", "Passing to app_links - NOT calling setIntent()")

                // Pass the ORIGINAL intent to super so app_links can read the URI
                super.onNewIntent(intent)

                // Do NOT call setIntent() - this prevents Flutter's built-in deep link handler
                // from processing it and resetting the route stack.
                // app_links will receive it via its stream listener.
                return
            }
        }

        // For internal navigation intents, pass to Flutter engine normally
        Log.d("MainActivity", "Internal navigation intent - passing to Flutter engine")
        super.onNewIntent(intent)
        setIntent(intent)
    }
}
