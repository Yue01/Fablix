package com.ameyaraje.mobilefablix;



import android.content.Intent;
import android.support.v7.app.AppCompatActivity;
import android.os.Bundle;
import android.util.Log;
import android.view.View;
import android.view.View.OnClickListener;
import android.widget.AdapterView;
import android.widget.ArrayAdapter;
import android.widget.AutoCompleteTextView;
import android.widget.Button;
import android.widget.EditText;
import android.widget.ListView;
import android.widget.Toast;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;
import com.android.volley.AuthFailureError;
import com.android.volley.Request;
import com.android.volley.Response;
import com.android.volley.VolleyError;
import com.android.volley.toolbox.JsonArrayRequest;
import com.android.volley.toolbox.JsonObjectRequest;
import com.android.volley.toolbox.StringRequest;
import com.android.volley.toolbox.Volley;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.Map;

public class ShowMovies extends AppCompatActivity{

    private Button PrevPage;
    private Button NextPage;
    JSONArray jsonArray;
    ArrayList<String> list = new ArrayList<>();
    public boolean lock =true;


    @Override
    protected void onCreate(Bundle savedInstanceState) {

        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_showmovies);
//         ArrayList<String> list = new ArrayList<>();
        final String pagenum = getIntent().getExtras().getString("pagenum");
        final int page;

        if(pagenum == null)
            page=0;
        else
            page = Integer.parseInt(pagenum);

        Log.d("Page num value: ",String.valueOf(page));
        final String title = getIntent().getExtras().getString("title");
        final int results = getIntent().getExtras().getInt("results");
        final String moviename;

        if (title.contains(" "))
            moviename = title.replace(" ","%20");
        else
            moviename = title;
        String url = "http://54.202.120.12:8080/cs122b-winter18-team-44/servlet/showmovie?title="+moviename+"&page="+page;
        Log.d("URL: ",url);

        PrevPage = (Button)findViewById(R.id.PrevPage);
        NextPage = (Button)findViewById(R.id.NextPage);

        JsonArrayRequest sr = new JsonArrayRequest(url,
                new Response.Listener<JSONArray>() {

                    @Override
                    public void onResponse(JSONArray response) {

                        Log.i("Response", response.toString());
                        jsonArray = response;

                        try {

                            for (int i = 0; i < jsonArray.length(); i++) {
                                JSONObject json = new JSONObject();
                                json = response.getJSONObject(i);
                                String title = json.getString("feedback");
                                String year = json.getString("year");
                                String director = json.getString("director");
                                String banner_url = json.getString("b_url");
                                String trailer_url = json.getString("t_url");
                                list.add("Title:  "+title+"\n"+"Year:  "+year+"\n"+"Director:  " + director+"\n"+"Genres:  "+banner_url+"\n"+"Stars:"+"\n"+trailer_url);
                            }


                            displaydata(list);


                        } catch (JSONException e) {
                            e.printStackTrace();
                        }
                    }},


                new Response.ErrorListener() {
                    @Override
                    public void onErrorResponse(VolleyError error) {
                        Log.i("Response", "ERROR");
                    }
                });

            Volley.newRequestQueue(getApplicationContext()).add(sr);
//                final ArrayAdapter<String> Alist = new ArrayAdapter<String>(this, android.R.layout.simple_list_item_1, list);
//                ListView lv = (ListView) findViewById(R.id.ListView);
//                if (lv != null) {
//                    lv.setAdapter(Alist);
//                } else {
//                    Toast.makeText(getApplicationContext(), "Some problem", Toast.LENGTH_LONG).show();
//                    return;
//                }




//        lv.setOnItemClickListener(new AdapterView.OnItemClickListener() {
//
//            @Override
//            public void onItemClick(AdapterView<?> parent, View view, int position, long id) {
//
//                Toast.makeText(getApplicationContext(), "Clicked", Toast.LENGTH_LONG).show();
//                Intent i = new Intent(ShowMovies.this, SingleMovie.class);
//                String movie = list.get(position);
//                i.putExtra("title",movie);
//                startActivity(i);
//            }
//        });
        PrevPage.setOnClickListener(new OnClickListener() {

            @Override
            public void onClick(View view) {

                Log.d("Previous page cliked: ",String.valueOf(page-1));
                if (page == 0) {
                    Toast.makeText(getApplicationContext(), "Previous page does not exist", Toast.LENGTH_SHORT).show();
                    return;
                }

                Intent i = new Intent(ShowMovies.this, ShowMovies.class);
                i.putExtra("pagenum",String.valueOf(page-1));
                i.putExtra("title","big");
                i.putExtra("results",results);
                startActivity(i);
            }
        });

        NextPage.setOnClickListener(new OnClickListener() {

            @Override
            public void onClick(View view) {

                Log.d("Next page cliked: ",String.valueOf(page+1));
                if((results - (page*10))/10 == 0) {
                    Toast.makeText(getApplicationContext(), "Next page does not exist", Toast.LENGTH_SHORT).show();
                    return;
                }

                Intent i = new Intent(ShowMovies.this, ShowMovies.class);
                i.putExtra("pagenum",String.valueOf(page+1));
                i.putExtra("title","big");
                i.putExtra("results",results);
                startActivity(i);
            }
        });
    }

    private void displaydata(ArrayList<String> list) {
        final ArrayAdapter<String> Alist = new ArrayAdapter<String>(this, android.R.layout.simple_list_item_1, list);
        ListView lv = (ListView) findViewById(R.id.ListView);
        if (lv != null) {
            lv.setAdapter(Alist);
        } else {
            Toast.makeText(getApplicationContext(), "Some problem", Toast.LENGTH_SHORT).show();
            return;
        }
    }





}