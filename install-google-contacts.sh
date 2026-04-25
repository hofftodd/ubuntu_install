#!/bin/bash

# Function to check and install Google Contacts as a PWA using Chrome
install_contacts_pwa() {
    # Check if Google Chrome is installed
    if ! command -v google-chrome &> /dev/null
    then
        echo "Google Chrome not found. Please install Google Chrome first."
        exit 1
    fi

    echo "Attempting to install Google Contacts as a Progressive Web App (PWA)..."
    # This command uses Chrome's command-line flags to install the current URL as an app
    google-chrome --force-dark-mode --enable-features=WebApps,DesktopPWAs --install-system-app=https://contacts.google.com/

    echo "A Google Contacts shortcut/app icon should now be available in your application launcher."
}

install_contacts_pwa
