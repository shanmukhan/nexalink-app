# Google Play Store Listing

Onboarding details for publishing the customer app to the Google Play Console.

## App name

**Nexa Link**

(`android:label` in [AndroidManifest.xml](../android/app/src/main/AndroidManifest.xml) was updated to match — it previously showed the raw project slug `nexa_link`.)

## Package name (applicationId)

**`com.nexalink.nexa_link`**

Defined in [android/app/build.gradle.kts](../android/app/build.gradle.kts) (`namespace` and `defaultConfig.applicationId`). This is the unique identifier submitted to Play Console and cannot be changed after the first release.

## Short description

(Play Store limit: 80 characters — this one is 75)

> Passwordless OTP login. Shop, earn wallet cashback, and refer to earn more.

## Full description

(Play Store limit: 4000 characters)

> **Nexa Link — Shop. Earn Cashback. Refer & Earn.**
>
> Nexa Link is a shopping and referral rewards app: log in without a password, buy with instant cashback into your wallet, and earn real commission every time someone you refer makes a purchase.
>
> **Passwordless login, in seconds**
> Sign in with just your phone number or email — we send a 6-digit OTP, you enter it, you're in. No passwords to create or forget. Your session stays signed in until you log out.
>
> **Shop with confidence**
> Every product listing shows its price, warranty coverage, and exactly how much cashback you'll earn before you buy — no surprises at checkout.
>
> **Instant wallet cashback**
> A percentage of every paid order is credited straight to your Nexa Wallet as cashback. Your wallet balance can be applied toward future orders, so your savings keep compounding.
>
> **Flexible cart & checkout**
> Adjust quantities, apply a coupon code, and choose how you pay — UPI, debit/credit card, or cash on delivery. Save a delivery address once and reuse it on every order, with an optional GST invoice for business purchases.
>
> **Refer friends, earn commission**
> Every account gets a personal referral code. Share it — when someone signs up with your code and completes a purchase, you earn a fixed commission credited directly to your wallet, no claim forms required. Track how many people you've referred and your total commission earned, right from the Teams tab.
>
> **Track your orders**
> Follow each order's status from placed through payment and delivery, with your order ID and invoice number always on hand.
>
> **Your account, your way**
> Manage your profile, verify your identity (KYC), and keep multiple delivery addresses on file. The entire app is available in both English and Telugu — switch anytime from the login screen.
>
> Whether you're here to shop smarter or build a referral network on the side, Nexa Link puts shopping and earning in the same app.

**Copy notes (not for the listing itself):**
- Grounded in what's actually shipped per [docs/ui/02_Customer_Screens.md](ui/02_Customer_Screens.md) — e.g. no claims about a product gallery, multi-level referral tree, push notifications, or a wallet withdrawal screen, since none of those exist yet in the app.
- "Total Earnings / This Month / Pending Payout" tiles on Home are still mock data server-side (no reporting backend yet), so the copy avoids promising an earnings dashboard and instead focuses on the real, verified feature: per-referral commission credited to the wallet.

## Screenshots

10 full-resolution (1440×2880) phone screenshots captured on a physical device, saved to [`screenshots/`](../screenshots):

| File | Screen |
|---|---|
| `01_home.png` | Home — wallet balance, earnings summary |
| `02_login.png` | Login — phone/email entry, language switcher |
| `03_otp.png` | OTP verification |
| `04_product.png` | Product detail |
| `05_cart.png` | Cart — item, coupon field |
| `06_checkout.png` | Checkout — delivery address, payment method |
| `07_profile.png` | Profile — account details, settings list |
| `08_home_offers.png` | Home — mega offer banner, category grid |
| `09_product_specs.png` | Product detail — warranty, cashback, referral policy |
| `10_cart_wallet.png` | Cart — quantity updated, wallet balance applied |

**Before submitting:** `07_profile.png` (and the profile card visible in a few other screenshots) shows a real-looking name, email, and phone number sourced from backend seed/test data. Swap in placeholder/demo data before these go live publicly if that matters for your listing.

## Known issues to resolve before release

- **Checkout doesn't complete**: tapping "Place Order" calls the backend's `/orders/checkout` endpoint successfully (confirmed via server logs), but the client never advances to the order confirmation screen or shows an error — needs investigation in `checkout_page.dart`'s `_placeOrder`/`OrderService.pay` flow.
- **Teams screen**: shows "Unexpected response from server" consistently — likely a JSON parsing mismatch between `ReferralSummary.fromJson` (`api_models.dart`) and the actual `/referrals/*` response shape.
- **Earnings tab**: still a "coming soon" placeholder (`earnings_page` not implemented).
