package org.pacific_emis.opendata

import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import kotlinx.coroutines.GlobalScope
import kotlinx.coroutines.launch
import okhttp3.OkHttpClient
import okhttp3.Request

class MainActivity : FlutterActivity() {

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, "org.pacific_emis.opendata/api")
                .setMethodCallHandler { call, result ->
                    when (call.method) {
                        "apiGet" -> handleApiGet(call.argument("url")!!, call.argument("eTag"), result)
                        else -> result.notImplemented()
                    }
                }
    }

    private fun handleApiGet(url: String, eTag: String?, result: MethodChannel.Result) {
        GlobalScope.launch {
            val client = OkHttpClient()
            val request = Request.Builder().apply {
                get()
                url(url)
                eTag?.let {
                    header("If-None-Match", it)
                }
            }.build()
            val response = client.newCall(request).execute()
            val body = response.body?.string()
            runOnUiThread {
                result.success(mapOf(
                        "code" to response.code,
                        "eTag" to response.header("ETag"),
                        "body" to body
                ))
            }
        }
    }
}
