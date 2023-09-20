import android.content.Context
import android.os.Bundle
import android.os.Handler
import android.view.LayoutInflater
import android.view.View
import com.finetaste.kalsan.R
import io.flutter.embedding.android.SplashScreen


class SplashView : SplashScreen {
    override fun createSplashView(context: Context, savedInstanceState: Bundle?): View? {

        return LayoutInflater.from(context).inflate(R.layout.splash_view, null, false)
    }

    override fun transitionToFlutter(onTransitionComplete: Runnable) {

        Handler().postDelayed({
            onTransitionComplete.run()
        }, 1500)
    }
}