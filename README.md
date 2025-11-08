# InAppPurchase-iOS
## Prerequisites
### App ID + Capabilities
- In Xcode → Target → Signing & Capabilities → Add “In-App Purchase”.
### App Store Connect
 - Go to Features → In-App Purchases
 - Add a product (e.g. `com.yourapp.premium`)
### StoreKit Configuration File (for testing)
 - Xcode → File → New → File → StoreKit Configuration File
 - Name it `Products.storekit`
 - Add your test products (non-consumable / subscription etc.)
 - In Xcode toolbar, select the file in `Scheme` → `StoreKit Configuration` dropdown.
