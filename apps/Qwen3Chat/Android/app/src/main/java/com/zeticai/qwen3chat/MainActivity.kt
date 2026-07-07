package com.zeticai.qwen3chat

import android.os.Bundle
import androidx.activity.ComponentActivity
import androidx.activity.compose.setContent
import androidx.compose.foundation.layout.*
import androidx.compose.material3.*
import androidx.compose.runtime.*
import androidx.compose.ui.Modifier
import androidx.lifecycle.viewmodel.compose.viewModel
import androidx.navigation.compose.*
import com.zeticai.qwen3chat.ui.theme.Qwen3ChatTheme
import com.zeticai.qwen3chat.ui.ChatScreen
import com.zeticai.qwen3chat.ui.DiagnosticsScreen
import com.zeticai.qwen3chat.ui.SettingsScreen
import com.zeticai.qwen3chat.viewmodel.ChatViewModel

class MainActivity : ComponentActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContent {
            Qwen3ChatTheme {
                val viewModel: ChatViewModel = viewModel()
                val navController = rememberNavController()
                
                Scaffold(
                    bottomBar = {
                        NavigationBar {
                            val currentRoute = navController.currentBackStackEntryAsState().value?.destination?.route
                            NavigationBarItem(
                                selected = currentRoute == "chat",
                                onClick = { navController.navigate("chat") { launchSingleTop = true } },
                                icon = { Text("Chat") }
                            )
                            NavigationBarItem(
                                selected = currentRoute == "diagnostics",
                                onClick = { navController.navigate("diagnostics") { launchSingleTop = true } },
                                icon = { Text("Diag") }
                            )
                            NavigationBarItem(
                                selected = currentRoute == "settings",
                                onClick = { navController.navigate("settings") { launchSingleTop = true } },
                                icon = { Text("Set") }
                            )
                        }
                    }
                ) { padding ->
                    NavHost(navController, startDestination = "chat", modifier = Modifier.padding(padding)) {
                        composable("chat") { ChatScreen(viewModel) }
                        composable("diagnostics") { DiagnosticsScreen(viewModel) }
                        composable("settings") { SettingsScreen(viewModel) }
                    }
                }
            }
        }
    }
}
