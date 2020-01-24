package fm.doe.national.pacific_dashboards

import android.os.Bundle
import androidx.annotation.NonNull

import io.flutter.app.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugins.GeneratedPluginRegistrant
import kotlinx.coroutines.GlobalScope
import kotlinx.coroutines.launch
import okhttp3.OkHttpClient
import okhttp3.Request

class MainActivity : FlutterActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        GeneratedPluginRegistrant.registerWith(this)

        MethodChannel(flutterView, "fm.doe.national.pacific_dashboards/api")
                .setMethodCallHandler { call, result ->
                    when (call.method) {
                        "apiGet" -> handleApiGet(call.argument("url")!!, call.argument("etag"), result)
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
                        "isSuccessful" to response.isSuccessful,
                        "eTag" to response.header("ETag"),
                        "body" to body
                ))
            }
        }
    }
}
