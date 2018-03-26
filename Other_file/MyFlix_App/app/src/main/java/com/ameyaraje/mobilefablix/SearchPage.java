package com.ameyaraje.mobilefablix;

import android.content.Intent;
import android.support.v7.app.AppCompatActivity;
import android.os.Bundle;
import android.util.Log;
import android.view.View;
import android.view.View.OnClickListener;
import android.widget.AutoCompleteTextView;
import android.widget.Button;
import android.widget.EditText;
import android.widget.Toast;

import org.json.JSONException;
import org.json.JSONObject;
import com.android.volley.AuthFailureError;
import com.android.volley.Request;
import com.android.volley.Response;
import com.android.volley.VolleyError;
import com.android.volley.toolbox.JsonObjectRequest;
import com.android.volley.toolbox.StringRequest;
import com.android.volley.toolbox.Volley;




public class SearchPage extends AppCompatActivity {

    private EditText search;
    private Button SearchButton;

    @Override
    protected void onCreate(Bundle savedInstanceState){
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_search);

        search = (EditText) findViewById(R.id.search);
        SearchButton = (Button) findViewById(R.id.SearchButton);
        SearchButton.setOnClickListener(new View.OnClickListener() {
            @Override
    public void onClick(View view) {

        String moviename=null;
        final String title = search.getText().toString();
        if (title.trim().length() == 0) {
            Toast.makeText(getApplicationContext(), "Please enter a search query", Toast.LENGTH_SHORT).show();
            return;
        }

        if (title.contains(" "))
            moviename = title.replace(" ","%20");
        else
            moviename = title;

        String url = "http://54.202.120.12:8080/cs122b-winter18-team-44/servlet/SearchApp?title="+moviename;

        JsonObjectRequest sr = new JsonObjectRequest(Request.Method.GET, url, null,

                new Response.Listener<JSONObject>() {

                    @Override
                    public void onResponse(JSONObject response) {

                        Log.i("Response", response.toString());
                        String info = null;
                        int results = 0;

                        try {
                            info = response.getString("info");
                            String cur = response.getString("results");
                            results=Integer.parseInt(cur);
                        } catch (JSONException e) {
                            e.printStackTrace();
                        }

                        if (info.equalsIgnoreCase("yes") && results!=0) {

                            Toast.makeText(getApplication(), "Successful, number of search results: " + results, Toast.LENGTH_SHORT).show();
                            Intent i = new Intent(SearchPage.this,ShowMovies.class);
                            i.putExtra("title",title);
                            i.putExtra("results",results);
                            startActivity(i);

                        }

                        else if (info.equalsIgnoreCase("yes") && results == 0) {

                            Toast.makeText(getApplication(), "Does not exist", Toast.LENGTH_SHORT).show();
                            return;

                        }

                        else {
                            Toast.makeText(getApplication(), "info value: " + info + " results: " + results, Toast.LENGTH_SHORT).show();
                        }
                    }
                },

                new Response.ErrorListener() {
                    @Override
                    public void onErrorResponse(VolleyError error) {
                        Log.i("Response", "ERROR");
                    }
                });

        Volley.newRequestQueue(getApplicationContext()).add(sr);
    }
});
}
}
