package org.pacific_emis.opendata

import android.util.Log
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import kotlinx.coroutines.GlobalScope
import kotlinx.coroutines.launch
import okhttp3.OkHttpClient
import okhttp3.Request
import okhttp3.internal.readBomAsCharset
import okio.Buffer

class MainActivity : FlutterActivity() {

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, "com.pacific_emis.opendata/api")
                .setMethodCallHandler { call, result ->
                    when (call.method) {
                        "apiGet" -> handleApiGet(call.argument("url")!!, call.argument("eTag"), result)
                        else -> result.notImplemented()
                    }
                }
    }

    private fun handleApiGet(url: String, eTag: String?, result: MethodChannel.Result) {
        GlobalScope.launch {
            try {
                val client = OkHttpClient()
                val request = Request.Builder().apply {
                    get()
                    url(url)
                    eTag?.let {
                        header("If-None-Match", it)
                    }
                }.build()
                val response = client.newCall(request).execute()

                val stringBuilder = StringBuilder()
                val buffer = Buffer()
                response.body?.source()?.use { source ->
                    while (!source.exhausted()) {
                        val data = buffer.readString(Charsets.UTF_8)
                        stringBuilder.append(data)
                    }
                }
                runOnUiThread {
                    result.success(mapOf(
                            "code" to response.code,
                            "eTag" to response.header("ETag"),
                            "body" to stringBuilder.toString()
                    ))
                }
            } catch (e: Exception) {
                runOnUiThread {
                    result.error("999", e.message, e)
                }
            }

        }
    }
}
