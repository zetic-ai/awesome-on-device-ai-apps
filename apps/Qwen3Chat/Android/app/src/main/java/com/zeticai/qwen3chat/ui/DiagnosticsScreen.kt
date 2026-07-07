package com.zeticai.qwen3chat.ui

import androidx.compose.foundation.layout.*
import androidx.compose.material3.*
import androidx.compose.runtime.*
import androidx.compose.ui.Modifier
import androidx.compose.ui.unit.dp
import com.zeticai.qwen3chat.viewmodel.ChatViewModel

@Composable
fun DiagnosticsScreen(viewModel: ChatViewModel) {
    val duration by viewModel.lastGenerationTime.collectAsState()
    val tokenCount by viewModel.lastTokenCount.collectAsState()
    
    Column(modifier = Modifier.fillMaxSize().padding(16.dp)) {
        Text("Model Diagnostics", style = MaterialTheme.typography.headlineMedium)
        Spacer(Modifier.height(16.dp))
        
        Card(modifier = Modifier.fillMaxWidth()) {
            Column(modifier = Modifier.padding(16.dp)) {
                Text("Model ID: Qwen/Qwen3-4B")
                Text("Personal Key: YOUR_MLANGE_KEY")
                Spacer(Modifier.height(16.dp))
                Text("Last Generation:")
                Text("Time: ${duration} ms")
                Text("Token Count: $tokenCount tokens")
                if (duration > 0 && tokenCount > 0) {
                    Text("Speed: ${"%.2f".format(tokenCount.toFloat() / (duration / 1000f))} tokens/sec")
                }
            }
        }
    }
}
