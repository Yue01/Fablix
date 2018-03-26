package com.ameyaraje.mobilefablix;

import android.content.Intent;
import android.os.AsyncTask;
import android.support.v7.app.AppCompatActivity;
import android.os.Bundle;
import android.util.Log;
import android.view.View;
import android.widget.Button;
import android.widget.EditText;
import android.widget.Toast;

import com.android.volley.Request;
import com.android.volley.Response;
import com.android.volley.VolleyError;
import com.android.volley.toolbox.JsonObjectRequest;
import com.android.volley.toolbox.Volley;

import org.json.JSONException;
import org.json.JSONObject;

import java.io.InputStream;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.URL;

public class MainActivity extends AppCompatActivity {

    EditText email1;
    EditText password1;
    Button login1;
    JSONObject json;
    int duration = Toast.LENGTH_LONG;
    Toast toast;
    boolean auth;
    String error = "Email/Password is wrong";

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);

        toast = Toast.makeText(this, "Hi and welcome to FabFlix's mobile app", Toast.LENGTH_SHORT);
        toast.show();
        email1 = (EditText) findViewById(R.id.search);
        password1 = (EditText) findViewById(R.id.passwordField);
        login1 = (Button) findViewById(R.id.SearchButton);
        assert login1!=null;

        login1.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                final String email = email1.getText().toString();
                final String password = password1.getText().toString();

                /*
                try {
                    json.put("email",email);
                    json.put("password",password);
                } catch (JSONException e) {
                    e.printStackTrace();
                }*/

                if (email.length() == 0 || password.length() == 0) {
                    Toast.makeText(getApplicationContext(), "Please enter UserName / Password", Toast.LENGTH_SHORT).show();
                    return;
                }

                String url = "http://54.202.120.12:8080/cs122b-winter18-team-44/servlet/Applogin?email="+email+"&password="+password;
                JsonObjectRequest sr = new JsonObjectRequest(Request.Method.GET, url,json,

                        new Response.Listener<JSONObject>() {

                            @Override
                            public void onResponse(JSONObject response) {

                                Log.i("Response", response.toString());
                                String info = null;


                                try {
                                    info = response.getString("info");
                                } catch (JSONException e) {
                                    e.printStackTrace();
                                }

                                if (info.equalsIgnoreCase("yes")) {
                                    Toast.makeText(getApplication(), "Welcome!", Toast.LENGTH_SHORT).show();
                                    Intent MovieSearch = new Intent(MainActivity.this, SearchPage.class);
                                    startActivity(MovieSearch);

                                } else {
                                    Toast.makeText(getApplication(), "Wrong UserName / Password", Toast.LENGTH_SHORT).show();
                                }
                            }
                        },
                        new Response.ErrorListener() {
                            @Override
                            public void onErrorResponse(VolleyError error) {
                                Log.i("Response", "ERROR");
                                Toast.makeText(getApplication(), "Unable to connect to server", Toast.LENGTH_SHORT).show();
                            }
                        });

                Volley.newRequestQueue(getApplicationContext()).add(sr);



            }
        });
}



}
