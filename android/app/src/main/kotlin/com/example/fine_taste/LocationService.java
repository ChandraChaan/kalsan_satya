package com.finetaste.kalsan;
import android.Manifest;
import android.app.Service;
import android.content.Intent;
import android.content.pm.PackageManager;
import android.location.Location;
import android.location.LocationListener;
import android.location.LocationManager;
import android.os.Bundle;
import android.os.IBinder;
import androidx.annotation.Nullable;
import androidx.core.app.ActivityCompat;

import org.json.JSONException;
import org.json.JSONObject;

import java.net.HttpURLConnection;
import java.net.URL;
import java.io.IOException;
import java.io.OutputStreamWriter;


public class LocationService extends Service implements LocationListener {

    private LocationManager locationManager;



    @Override
    public void onCreate() {
        super.onCreate();
        locationManager = (LocationManager) getSystemService(LOCATION_SERVICE);
    }

    @Override
    public int onStartCommand(Intent intent, int flags, int startId) {
        requestLocationUpdates();
        return START_STICKY;
    }

    @Override
    public void onDestroy() {
        super.onDestroy();
        locationManager.removeUpdates(this);
    }

    @Nullable
    @Override
    public IBinder onBind(Intent intent) {
        return null;
    }

    private void requestLocationUpdates() {
        if (ActivityCompat.checkSelfPermission(this, Manifest.permission.ACCESS_FINE_LOCATION) == PackageManager.PERMISSION_GRANTED) {
            locationManager.requestLocationUpdates(LocationManager.GPS_PROVIDER, 60 * 1000, 0, this);
        }
    }

    @Override
    public void onLocationChanged(Location location) {
        // Send location data to the API
        double latitude = location.getLatitude();
        double longitude = location.getLongitude();
        sendLocationToApi(latitude, longitude);
    }

    private void sendLocationToApi(double latitude, double longitude) {
        // Create the request body as JSON
        JSONObject requestBody = new JSONObject();
        try {
            requestBody.put("latitude", latitude);
            requestBody.put("longitude", longitude);
            requestBody.put("API_KEY", "640590");
            requestBody.put("user_id", "21");
        } catch (JSONException e) {
            e.printStackTrace();
            return; // Return early if there is an error creating the request body
        }

        // Perform the API request
        try {
            URL url = new URL("https://kalsanfood.com/kalsan_dev/api/send_location");
            HttpURLConnection connection = (HttpURLConnection) url.openConnection();
            connection.setRequestMethod("POST");
            connection.setRequestProperty("Content-Type", "application/json");
            connection.setDoOutput(true);

            // Write the request body to the connection's output stream
            OutputStreamWriter outputStreamWriter = new OutputStreamWriter(connection.getOutputStream());
            outputStreamWriter.write(requestBody.toString());
            outputStreamWriter.flush();

            // Check the response code
            int responseCode = connection.getResponseCode();
            if (responseCode == HttpURLConnection.HTTP_OK) {
                System.out.println("API call successful. Response code: " + responseCode);
            } else {
                System.out.println("API call failed. Response code: " + responseCode);
            }

            // Close the connection
            connection.disconnect();
        } catch (IOException e) {
            e.printStackTrace();
            // Handle the exception if needed
        }
    }


    @Override
    public void onStatusChanged(String provider, int status, Bundle extras) {
    }

    @Override
    public void onProviderEnabled(String provider) {
    }

    @Override
    public void onProviderDisabled(String provider) {
    }


}
