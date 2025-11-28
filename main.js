const { app, BrowserWindow, Menu } = require('electron');
const path = require('path');

// Clear the global app menu immediately (prevents default from showing)
Menu.setApplicationMenu(null);

function createWindow() {
  const mainWindow = new BrowserWindow({
    width: 1200,
    height: 800,
    menuBarVisible: false,  // Hides the top menu bar (File, Edit, etc.)
    icon: path.join(__dirname, 'icon.png'),  // Loads your custom icon (place icon.png in project root)
    webPreferences: {
      nodeIntegration: true,
      contextIsolation: false
    }
  });

  // Load the HTML file
  mainWindow.loadFile('index.html');

  // Double-check window menu (redundant but ensures no overrides)
  mainWindow.setMenu(null);

  // Open DevTools in development (comment out for production)
  // mainWindow.webContents.openDevTools();
}

app.whenReady().then(createWindow);

app.on('window-all-closed', () => {
  if (process.platform !== 'darwin') {
    app.quit();
  }
});

app.on('activate', () => {
  if (BrowserWindow.getAllWindows().length === 0) {
    createWindow();
  }
});