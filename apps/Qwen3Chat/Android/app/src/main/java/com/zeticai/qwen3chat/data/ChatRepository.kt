package com.zeticai.qwen3chat.data

import android.content.Context
import com.google.gson.Gson
import com.google.gson.reflect.TypeToken
import com.zeticai.qwen3chat.data.model.ChatMessage
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.withContext
import java.io.File

class ChatRepository(private val context: Context) {
    private val file = File(context.filesDir, "chat_history.json")
    private val gson = Gson()
    
    suspend fun loadMessages(): List<ChatMessage> = withContext(Dispatchers.IO) {
        if (!file.exists()) return@withContext emptyList()
        try {
            val json = file.readText()
            val type = object : TypeToken<List<ChatMessage>>() {}.type
            gson.fromJson(json, type) ?: emptyList()
        } catch (e: Exception) {
            emptyList()
        }
    }
    
    suspend fun saveMessages(messages: List<ChatMessage>) = withContext(Dispatchers.IO) {
        try {
            val json = gson.toJson(messages)
            file.writeText(json)
        } catch (e: Exception) {
            e.printStackTrace()
        }
    }
    
    suspend fun clearHistory() = withContext(Dispatchers.IO) {
        if (file.exists()) {
            file.delete()
        }
    }
}
