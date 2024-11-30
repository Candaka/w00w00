### **Step 1: Install Prerequisites**

1. **Install Node.js and npm**
   Open a terminal and run:
   ```bash
   sudo apt update
   sudo apt install -y nodejs npm
   ```
   Verify installation:
   ```bash
   node -v
   npm -v
   ```

2. **Install DFINITY SDK**
   Download and install the Internet Computer SDK:
   ```bash
   sh -ci "$(curl -fsSL https://internetcomputer.org/install.sh)"
   ```
   Add the SDK to your shell’s PATH:
   ```bash
   echo 'export PATH="$HOME/bin:$PATH"' >> ~/.bashrc
   source ~/.bashrc
   ```
   Verify installation:
   ```bash
   dfx --version
   ```

3. **Install a Code Editor (Optional)**
   Install Visual Studio Code for better development experience:
   ```bash
   sudo apt install -y software-properties-common apt-transport-https wget
   wget -q https://packages.microsoft.com/keys/microsoft.asc -O- | sudo apt-key add -
   sudo add-apt-repository "deb [arch=amd64] https://packages.microsoft.com/repos/vscode stable main"
   sudo apt update
   sudo apt install code
   ```

---

### **Step 2: Set Up the Project**

1. **Clone or Create the Project**
   Navigate to a working directory and create a new DFINITY project:
   ```bash
   dfx new decentralized_social_media
   cd decentralized_social_media
   ```

2. **Replace Starter Files**
   - Replace the default Motoko backend code in `src/decentralized_social_media` with your `civitas.mo` file.
   - Add your React frontend (`App.js` and others) to the `src/decentralized_social_media_assets` directory.

3. **Update `dfx.json`**
   Ensure your `dfx.json` file includes the correct settings for your backend and frontend:
   ```json
   {
     "canisters": {
       "backend": {
         "main": "src/decentralized_social_media/civitas.mo",
         "type": "motoko"
       },
       "decentralized_social_media_assets": {
         "source": ["src/decentralized_social_media_assets"],
         "type": "assets"
       }
     },
     "defaults": {
       "build": {
         "packtool": ""
       }
     },
     "networks": {
       "local": {
         "bind": "127.0.0.1:8000",
         "type": "ephemeral"
       }
     },
     "version": 1
   }
   ```

---

### **Step 3: Start the Local IC Environment**

1. **Start the DFX Network**
   Run the local Internet Computer replica:
   ```bash
   dfx start --background
   ```

2. **Deploy the Canisters**
   Deploy your backend and frontend canisters:
   ```bash
   dfx deploy
   ```

3. **Check the Canisters**
   Verify the deployment and obtain the URLs for testing:
   ```bash
   dfx canister id backend
   dfx canister id decentralized_social_media_assets
   ```

---

### **Step 4: Test the Backend**

1. **Test Backend Functions**
   Use the DFX CLI to call backend functions. For example:
   ```bash
   dfx canister call backend createPost '( "Hello World", "https://example.com/image.jpg" )'
   dfx canister call backend getPosts
   ```

---

### **Step 5: Run the Frontend**

1. **Install Frontend Dependencies**
   Navigate to the React frontend directory:
   ```bash
   cd src/decentralized_social_media_assets
   npm install
   ```

2. **Start the React Development Server**
   Run the React app:
   ```bash
   npm start
   ```

3. **Access the Frontend**
   Open your browser and navigate to:
   ```
   http://localhost:3000
   ```

---

### **Step 6: Interact with the Application**

1. Create posts, like posts, and add comments through the React UI.
2. Verify that the changes reflect on the backend.

---

### **Step 7: Stop the Local IC Environment**

When finished testing, stop the Internet Computer replica:
```bash
dfx stop
```

---

### Troubleshooting Tips:
- If you encounter issues with canister deployment, try running:
  ```bash
  dfx deploy --network local
  ```
- Check logs for detailed error messages:
  ```bash
  dfx start --background && dfx logs
  ```

Let me know if you need further clarification or run into any issues!