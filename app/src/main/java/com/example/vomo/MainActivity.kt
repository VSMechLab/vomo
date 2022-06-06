package com.example.vomo

import android.graphics.Color
import android.os.Build
import android.os.Bundle
import android.view.View
import androidx.appcompat.app.AppCompatActivity
import androidx.appcompat.widget.ActionBarContainer
import com.google.android.material.bottomappbar.BottomAppBar
import com.google.android.material.bottomnavigation.BottomNavigationView
import com.google.android.material.floatingactionbutton.FloatingActionButton
import com.google.android.material.snackbar.Snackbar

class MainActivity : AppCompatActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_main)


        // Bottom App Navigation
        val bottom_nav: ActionBarContainer = findViewById(R.id.Nav_Bar)
        bottom_nav.setOnMenuItemClickListener { menuItem ->
            when (menuItem.itemId) {
                R.id.search -> {
                    // Handle search icon press
                    true
                }
                R.id.more -> {
                    // Handle more item (inside overflow menu) press
                    true
                }
                else -> false
            }
        } //End method

        // Bottom nav bar, the view holding the icon
        BottomNavigationView.OnNavigationItemSelectedListener { item ->
            when(item.itemId) {
                R.id.item1 -> {
                    // Respond to navigation item 1 click
                    true
                }
                R.id.item2 -> {
                    // Respond to navigation item 2 click
                    true
                }
                else -> false
            }
        } //End method

        bottomNavigation.setOnNavigationItemReselectedListener { item ->
            when(item.itemId) {
                R.id.item1 -> {
                    // Respond to navigation item 1 reselection
                }
                R.id.item2 -> {
                    // Respond to navigation item 2 reselection
                }
            }
        } //End method

        // Record Button
        val fab_record: View = findViewById(R.id.FAB_Record)
        fab_record.setOnClickListener {
            // TEMP: show message
            Snackbar.make(findViewById(R.id.Screen_Boundary), "Record button pressed", Snackbar.LENGTH_SHORT)
                    .show()
        } //End method

    } //End fxn

    private var goals_progress = 0
} //End class

fun calc_NumDaysSinceVisit() : Int {

}