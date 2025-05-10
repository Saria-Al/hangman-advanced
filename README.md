# Hangman Game 🎯 (Sinatra)

A smart hangman game with levels, sarcasm, hints, and light/dark mode – built with Ruby and Sinatra!

## 🚀 How to Deploy on Render

1. Create a GitHub repo and upload this code.
2. Go to [https://render.com](https://render.com)
3. Click **"New Web Service"**
4. Connect your GitHub repo.
5. Set the following settings:

- **Build Command:** `bundle install`
- **Start Command:** `rackup --host 0.0.0.0 --port $PORT`
- **Environment:** Ruby
- **Port:** 9292 (automatically handled by $PORT on Render)

6. Click **"Deploy"** and wait a minute ⏳

You’ll get a public URL like:  
👉 https://your-hangman-app.onrender.com

## 🎮 Features

- ✅ Random words with difficulty variety
- ✅ Hints available (💡)
- ✅ Sarcastic feedback 😏
- ✅ Light/Dark mode toggle (🌓)
- ✅ Level progression
- ✅ Applause sound on win
