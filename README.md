# How to Use the VS Code Web Server

This guide will walk you through setting up and using your own private version of Visual Studio Code that runs in your web browser.

## What you need before you start

Before you begin, make sure you have these things installed on your computer:
1. **Docker**: This is the software that runs the "container" where VS Code lives.
2. **Docker Compose**: This helps manage the container settings easily.
3. **A Web Browser**: Use a modern browser like Chrome, Edge, or Firefox.

---

## Step 1: Getting it running

The easiest way to start the server is using **Docker Compose**.

1. Open your terminal (like PowerShell or Command Prompt).
2. Navigate to this project folder
3. Type this command and press Enter:
   ```powershell
   docker compose up --build
   ```
4. Wait for the process to finish. You will see some text scrolling in your terminal. Once it stops moving and says something about being "started" or "running", you are ready.

   **Tip: Run in the background (Detached Mode)**
   
   If you want to run the container in the background so your terminal remains free, add the `-d` flag:
   ```powershell
   docker compose up --build -d
   ```
   This starts the server without blocking your terminal. You can check the logs anytime with:
   ```powershell
   docker compose logs -f vscode
   ```
   And stop it later with:
   ```powershell
   docker compose down
   ```

---

## Step 2: Opening VS Code

Once the server is running:
1. Open your web browser.
2. In the address bar, type: `http://localhost:8003`
3. Press Enter.

You should now see the VS Code interface right in your browser!

---

## Step 3: Working with your files

Your current project files are automatically "linked" to the VS Code inside the browser. 
- Any file you create or edit in the browser will be saved directly in your folder on your computer.
- The folder you see inside VS Code is called `/workspace`.

---

## Step 4: Using Python

This setup is specially made for Python developers.
- A "Virtual Environment" is already set up for you at `/opt/venv`.
- If VS Code asks you to "Select an Interpreter", choose the one located at `/opt/venv/bin/python`.
- You can install new Python packages by typing `pip install <package-name>` in the terminal inside VS Code.

---

## Step 5: Stopping the server

When you are finished working:
1. Go back to your terminal.
2. Press `Ctrl + C` to stop the process, or open a new terminal window and type:
   ```powershell
   docker compose down
   ```

---

## Common Problems & Quick Fixes

### "I see a blank page in my browser"
- **Check if it's actually running**: Go to your terminal. If you don't see any activity, try running `docker compose up` again.
- **Check the port**: Make sure you are typing `http://localhost:8003` and not something else.
- **Restart**: Try typing `docker compose restart` in your terminal.

### "VS Code says it can't connect to the server"
- This usually means the container crashed. Run `docker compose logs vscode` in your terminal to see the error message.
- Most of the time, simply running `docker compose down` and then `docker compose up --build` fixes it.

### "I can't find my Python packages"
- Make sure you are using the correct Python. In VS Code, press `Ctrl+Shift+P`, type "Select Interpreter", and make sure `/opt/venv/bin/python` is selected.

### "I'm getting permission errors when saving files"
- This can happen if the files on your computer are owned by a different user. Try restarting Docker or running the container with different settings (see the technical README for details).

---

## ⚠️ Important Security Warning

**This setup is for your own use on your own computer only.** 

It does **not** have a password. If you connect this to the internet, anyone in the world could access your files and your computer through this browser window. Only use this on your local network or via a secure VPN.
