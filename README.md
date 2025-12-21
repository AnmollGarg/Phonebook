# Phonebook

A modern, professional phonebook application built with QML and Lomiri Components for managing contacts efficiently. The application features an adaptive layout that works seamlessly across mobile, tablet, and desktop devices.

## Features

### Core Functionality
- **Contact Management**: Create, view, edit, and delete contacts
- **Favorites**: Mark contacts as favorites for quick access
- **Search**: Real-time inline search functionality to quickly find contacts
- **Call History**: View call history for individual contacts
- **Contact Types**: Support for both Individual and Company contact types
- **Contact Information**: Store and manage:
  - First name and last name
  - Phone number with country code
  - Email address
  - Favorite status
  - Contact type (Individual/Company)

### User Interface
- **Adaptive Layout**: Responsive design that adapts to different screen sizes
  - **Mobile**: Single column layout
  - **Tablet**: Two column layout (contacts list + detail view)
  - **Desktop/Laptop**: Three column layout (main page + search + contact info)
- **Modern UI**: Clean, intuitive interface using Lomiri Components
- **Swipe Actions**: Swipe left/right on contacts for quick actions (Call, Message, Delete)
- **Floating Action Button**: Easy access to create new contacts
- **Avatar System**: Automatic avatar generation using contact initials
- **Splash Screen**: Professional splash screen on app launch

### Navigation
- **Multi-column Navigation**: Seamless navigation between pages in multi-column layouts
- **Page Stack**: Efficient page management with AdaptivePageLayout
- **Settings Page**: Application settings with account selection
- **User Profile**: Access to user profile information

## Technology Stack

- **QML 2.7**: User interface framework
- **Lomiri Components 1.3**: UI component library for native Lomiri/Ubuntu Touch look and feel
- **QtQuick.Layouts 1.3**: Layout management
- **Qt.labs.settings 1.0**: Application settings persistence
- **JavaScript**: Backend logic for contact data management

## Project Structure

```
phonebook/
├── qml/
│   ├── Main.qml                 # Main application entry point
│   ├── logic/
│   │   ├── ContactsData.js      # Contact data storage and manipulation
│   │   ├── ContactsService.qml  # QML service interface for contacts
│   │   └── qmldir               # QML module registration
│   └── ui/
│       ├── components/
│       │   ├── display/         # Display components
│       │   │   ├── Avatar.qml              # Avatar with initials
│       │   │   ├── ContactListItemDelegate.qml  # Contact list item
│       │   │   ├── FavoriteItemDelegate.qml     # Favorite item
│       │   │   ├── Favorites.qml                # Favorites section
│       │   │   ├── Recents.qml                  # All Contacts section
│       │   │   └── RecentCallItemDelegate.qml   # Call history item
│       │   ├── input/           # Input components
│       │   │   └── SearchBox.qml # Search input component
│       │   └── widget/           # Widget components
│       │       └── FloatingActionButton.qml  # FAB for creating contacts
│       └── pages/                # Application pages
│           ├── MainPage.qml           # Main landing page
│           ├── ContactInfoPage.qml   # Contact details and editing
│           ├── CallHistoryPage.qml   # Call history for a contact
│           ├── NewContactPage.qml   # Create new contact
│           ├── SearchPage.qml        # Search page (legacy)
│           ├── SettingsPage.qml      # Application settings
│           ├── UserProfilePage.qml   # User profile
│           └── SplashScreen.qml    # Splash screen
├── assets/                      # Application assets
│   ├── avatar.png              # Default avatar image
│   └── logo.svg                # Application logo
├── po/                         # Internationalization
│   └── phonebook.anmolgarg.pot # Translation template
├── CMakeLists.txt              # CMake build configuration
├── clickable.yaml              # Clickable build configuration
├── manifest.json.in            # App manifest template
├── phonebook.apparmor         # AppArmor security profile
├── phonebook.desktop.in        # Desktop file template
└── LICENSE                     # License file
```

## Building and Installation

### Prerequisites
- Ubuntu Touch development environment
- Clickable (Ubuntu Touch app development tool)
- CMake 3.10 or higher
- Qt 5.x with QML support
- Lomiri Components development packages

### Building with Clickable

1. **Install Clickable** (if not already installed):
   ```bash
   sudo snap install clickable
   ```

2. **Clone the repository**:
   ```bash
   git clone https://github.com/AnmollGarg/Phonebook.git
   cd phonebook
   ```

3. **Build the application**:
   ```bash
   clickable build
   ```

4. **Install on device** (connected via USB or SSH):
   ```bash
   clickable install
   ```

5. **Run the application**:
   ```bash
   clickable run
   ```

### Building with CMake

1. **Create build directory**:
   ```bash
   mkdir build && cd build
   ```

2. **Configure and build**:
   ```bash
   cmake ..
   make
   ```

3. **Install**:
   ```bash
   make install
   ```

## Usage

### Main Page
- **Favorites Section**: Displays all contacts marked as favorites
- **All Contacts Section**: Shows all contacts in alphabetical order
- **Search**: Click the search icon in the header to activate inline search
- **Create Contact**: Tap the floating action button (FAB) in the bottom right

### Contact Management
- **View Contact**: Tap any contact to view details
- **Edit Contact**: Tap the edit icon in the contact info page header
- **Delete Contact**: Swipe left on a contact in the list and tap delete
- **Mark as Favorite**: Toggle the favorite switch when editing a contact

### Search
- Click the search icon in the header to activate search mode
- Type in the search field to filter contacts in real-time
- Search matches contact names, phone numbers, and email addresses
- Click the close icon (X) to exit search mode

### Quick Actions
- **Call**: Swipe right on a contact and tap the call icon
- **Message**: Swipe right on a contact and tap the message icon
- **Delete**: Swipe left on a contact and tap the delete icon

## Adaptive Layouts

The application automatically adapts its layout based on screen width:

### Mobile (< 80 gu)
- Single column layout
- Full-width pages
- Stack navigation

### Tablet (80-130 gu)
- Two column layout
- Contacts list in first column
- Detail view in second column

### Desktop/Laptop (≥ 130 gu)
- Three column layout
- Main page in first column
- Search/List in second column
- Contact info in third column

## Development

### Code Structure

#### Data Layer
- `ContactsData.js`: Contains the contact data array and all data manipulation functions
- `ContactsService.qml`: Provides a QML interface to the JavaScript data layer

#### UI Components
- **Pages**: Main application screens
- **Display Components**: Reusable components for displaying contact information
- **Input Components**: Search and input fields
- **Widget Components**: Custom widgets like FAB

### Adding New Features

1. **New Page**: Create a new QML file in `qml/ui/pages/` and register it in `qmldir`
2. **New Component**: Create in appropriate subdirectory under `qml/ui/components/`
3. **Data Functions**: Add to `ContactsData.js` and expose via `ContactsService.qml`

## Internationalization

The application supports internationalization through the `po/` directory. To add translations:

1. Extract translatable strings:
   ```bash
   clickable translate
   ```

2. Add translations to the `.pot` file

3. Build with translations:
   ```bash
   clickable build
   ```

## License

Copyright (C) 2025 Anmol Garg

Licensed under the MIT License. See [LICENSE](LICENSE) file for details.

## Author

**Anmol Garg**
- GitHub: [@AnmollGarg](https://github.com/AnmollGarg)

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## Acknowledgments

- Built with [Lomiri Components](https://github.com/ubports/ubuntu-ui-toolkit)
- Uses [Qt/QML](https://www.qt.io/) framework
- Developed for Ubuntu Touch platform

## Version

Current Version: 1.0.0

---

For more information, visit the [GitHub repository](https://github.com/AnmollGarg/Phonebook).
