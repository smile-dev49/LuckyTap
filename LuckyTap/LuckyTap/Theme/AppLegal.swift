import Foundation

/// Legal / compliance copy for App Store review (Guideline 5.3 / entertainment-only).
enum AppLegal {
    static let appName = "Lucky Tap"
    static let supportEmail = "support@luckytap.example"

    /// Optional public privacy policy URL for App Store Connect.
    /// Replace with your real HTTPS page before submission.
    static let privacyPolicyURL = URL(string: "https://example.com/lucky-tap-privacy")

    static let shortDisclaimer =
        "Entertainment only. Virtual coins have no real-world value. No real-money gambling, deposits, or cash prizes."

    static let ageNotice =
        "This game includes simulated casino gameplay and is intended for users 17 years of age or older."

    static let fullDisclaimer = """
    Lucky Tap is a free entertainment game that simulates slot-machine play using virtual coins only.

    • Virtual coins cannot be purchased with real money in this version.
    • Virtual coins cannot be redeemed, traded, or withdrawn for real money or anything of value.
    • Outcomes are for fun and do not involve real-money wagering.
    • This app does not offer gambling services and is not affiliated with any real casino.

    By continuing, you confirm you are at least 17 years old and understand this is entertainment software only.
    """

    static let privacySummary = """
    Privacy Summary

    Lucky Tap stores game progress locally on your device (coins, level, settings, mission progress). We do not require an account and do not collect personal information through the app in this version.

    Data stored on device:
    • Virtual coin balance and play statistics
    • Settings preferences (sound, haptics)
    • Daily reward / mission progress

    You can erase local progress using Reset Progress in Settings. Uninstalling the app also removes locally stored data.

    If you later enable analytics, advertising, or sign-in features, this notice will be updated and a public Privacy Policy URL will be provided in App Store Connect.
    """

    static let termsSummary = """
    Terms of Use (Entertainment)

    Lucky Tap is provided for personal entertainment. Virtual items have no cash value. Do not use the app if real-money gambling is restricted for you by local law in a way that also prohibits simulated casino games.

    The game is intended for adults (17+). Parents and guardians should supervise device use by minors.
    """
}
