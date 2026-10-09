package dev.pando.app

import com.google.android.gms.common.ConnectionResult
import com.google.android.gms.common.GoogleApiAvailability
import com.google.android.gms.fitness.FitnessLocal
import com.google.android.gms.fitness.LocalRecordingClient
import com.google.android.gms.fitness.data.LocalDataType
import com.google.android.gms.fitness.data.LocalField
import com.google.android.gms.fitness.request.LocalDataReadRequest
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import java.util.concurrent.TimeUnit

/**
 * Hosts the `pando/step_history` channel: the phone's own step history from
 * the Android Recording API (on-device, no account). Android records steps
 * even when Pando is closed, so a walk with the screen off can be read back
 * in 30 s slices at Stop.
 */
class MainActivity : FlutterActivity() {
    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, "pando/step_history")
            .setMethodCallHandler { call, result ->
                when (call.method) {
                    "ensureRecording" -> ensureRecording(result)
                    "slices" -> slices(call, result)
                    else -> result.notImplemented()
                }
            }
    }

    /** The Recording API needs a recent Google Play services. */
    private fun hasPlayServices(): Boolean =
        GoogleApiAvailability.getInstance().isGooglePlayServicesAvailable(
            this,
            LocalRecordingClient.LOCAL_RECORDING_CLIENT_MIN_VERSION_CODE,
        ) == ConnectionResult.SUCCESS

    /** Starts recording step counts. Safe to call again; data exists only after this. */
    private fun ensureRecording(result: MethodChannel.Result) {
        if (!hasPlayServices()) {
            result.error("unavailable", "Google Play services too old or missing", null)
            return
        }
        FitnessLocal.getLocalRecordingClient(this)
            .subscribe(LocalDataType.TYPE_STEP_COUNT_DELTA)
            .addOnSuccessListener { result.success(null) }
            .addOnFailureListener { e -> result.error("subscribe_failed", e.message, null) }
    }

    /**
     * Steps per bucket between `fromMs` and `toMs` (epoch milliseconds), in
     * buckets of `sizeS` seconds. Returns `[{startMs, endMs, steps}]`; buckets
     * with no data may be missing.
     */
    private fun slices(call: MethodCall, result: MethodChannel.Result) {
        if (!hasPlayServices()) {
            result.error("unavailable", "Google Play services too old or missing", null)
            return
        }
        val fromMs = call.argument<Number>("fromMs")!!.toLong()
        val toMs = call.argument<Number>("toMs")!!.toLong()
        val sizeS = call.argument<Number>("sizeS")!!.toInt()
        val request = LocalDataReadRequest.Builder()
            .aggregate(LocalDataType.TYPE_STEP_COUNT_DELTA)
            .bucketByTime(sizeS, TimeUnit.SECONDS)
            .setTimeRange(fromMs, toMs, TimeUnit.MILLISECONDS)
            .build()
        FitnessLocal.getLocalRecordingClient(this)
            .readData(request)
            .addOnSuccessListener { response ->
                val out = mutableListOf<Map<String, Any>>()
                for (bucket in response.buckets) {
                    for (dataSet in bucket.dataSets) {
                        for (point in dataSet.dataPoints) {
                            out.add(
                                mapOf(
                                    "startMs" to point.getStartTime(TimeUnit.MILLISECONDS),
                                    "endMs" to point.getEndTime(TimeUnit.MILLISECONDS),
                                    "steps" to point.getValue(LocalField.FIELD_STEPS).asInt(),
                                ),
                            )
                        }
                    }
                }
                result.success(out)
            }
            .addOnFailureListener { e -> result.error("read_failed", e.message, null) }
    }
}
