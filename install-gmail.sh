#!/bin/bash

# Function to check and install Gmail as a PWA using Chrome
install_gmail_pwa() {
    # Check if Google Chrome is installed
    if ! command -v flatpak run com.google.Chrome &> /dev/null
    then
        echo "Google Chrome not found. Please install Google Chrome first."
        exit 1
    fi

    echo "Attempting to install Gmail as a Progressive Web App (PWA)..."
    # This command uses Chrome's command-line flags to install the current URL as an app
    google-chrome --force-dark-mode --enable-features=WebApps,DesktopPWAs --install-system-app=https://mail.google.com/mail/u/0/#inbox

    echo "A Gmail shortcut/app icon should now be available in your application launcher."
}

install_gmail_pwa

