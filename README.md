Sandwich Shop App

A small Flutter demo app for creating simple sandwich orders. Lets users choose sandwich size, bread type, quantity, and add order notes. Core UI and logic live in main.dart. Key widgets and classes include App, OrderScreen, OrderItemDisplay, StyledButton, and the BreadType enum. Order state is managed by OrderRepository. UI styles are in app_styles.dart.

Features:
Increment / decrement order quantity with guards on min/max implemented by OrderRepository.

Toggle between six-inch and footlong sandwiches via a Switch (_isFootlong in lib/main.dart).

Choose bread type from a dropdown (BreadType enum in lib/main.dart).

Add an order note (text field) and preview in the order display.

Desktop platform runners included (Windows and Linux): e.g. main.cpp and my_application.cc.


Prerequisites
Flutter SDK installed and on PATH. See https://flutter.dev for install steps.

Platform toolchains if building for desktop:
    Windows: Visual Studio with C++ workload.
    Linux: GTK development libraries and CMake.

Basic git (optional to clone).


Installation & Setup:

Clone the repository (or open this workspace).

git clone https://github.com/James40H/Sandwich_shop.git


From the project root, get packages:

flutter pub get


Run the app on your desired platform:

flutter run


For mobile or web (single command):

flutter run


For Windows desktop (uses the Windows runner in windows/runner):

flutter run -d windows


For Linux desktop (uses the Linux runner in linux/runner):

flutter run -d linux


Build release artifacts:

flutter build apk    # Android

flutter build ios    # iOS (macOS required)

flutter build windows

flutter build linux

flutter build web


Usage
Launch the app.
The main ordering UI is in OrderScreen. Default behavior:
Quantity is controlled by the green "Add" and red "Remove" buttons (StyledButton in lib/main.dart). These buttons call into OrderRepository for increment/decrement logic.
Toggle sandwich size (six-inch / footlong) using the Switch bound to _isFootlong (state in lib/main.dart).
Select bread type from the dropdown populated from the BreadType enum (in lib/main.dart).
Add notes in the text field (key: notes_textfield) — notes are mirrored in the OrderItemDisplay widget.
To change max allowable quantity, modify the maxQuantity passed to OrderScreen in App:
Example: OrderScreen(maxQuantity: 5).

Project layout (selected)
main.dart — app entry, UI, and primary widgets (see App, OrderScreen).
order_repository.dart — order quantity logic.
app_styles.dart — text styles used across the UI.
Desktop runners:
main.cpp and flutter_window.cpp
my_application.cc
