@{
    Greeting = 'Welcome to Gacha Log URL Obtainer!';
    RegRememberChoice = 'Remember the language selection? (y/n)';
    RegRememberFailed = 'Failed to save to registry:';
    RegRememberSuccess = 'Successfully saved language selection to registry.';
    RegSuggestAdmin = 'You may need to run PowerShell as Administrator to save this setting.';
    RegRememberCancelled = 'Operation cancelled. No changes made to the registry.';

    EnterChoice = 'Enter your choice';
    NoURL = 'Cannot find gacha log URL, open the gacha history in-game before running.';
    Copied = 'Gacha log URL copied to clipboard:';
    PasteInstructions = 'Paste it in your favorite gacha log tracker (zzz.rng.moe, Hoyo Buddy, etc.)';
    InvalidChoice = 'Invalid choice. Please try again.';
    URLFound = 'Gacha log URL found:';

    GachaMenuTitle = 'Gacha Log URL Obtainer';
    GachaMenuDescription = 'Select game:';
    GachaMenuOptions = @(
        '1. Genshin Impact',
        '2. Honkai: Star Rail',
        '3. Zenless Zone Zero',
        'Press 0 to Exit'
    );
    GachaMenuAnyKey = 'Press any key to return to the menu...';
    GachaMenuExit = 'Cleaning temp files and exiting...';

    GachaMenuChooseLink = 'Select region:';
    RegionOptions = @(
        '1. Global',
        '2. China',
        '3. Cloud',
        'Press 0 to Exit'
    );
    RegionOptionsNoCloud = @(
        '1. Global',
        '2. China',
        'Press 0 to Exit'
    );
    TaskCompleted = 'Task completed. If any error occurred, rerun the script or contact support. Press any key to exit.';

    CloudOptions = @(
        '1. Global',
        '2. China',
        'Press 0 to Exit'
    );

    RegionUnavailable = 'This region is currently unavailable. Please choose another region.';
    AdminRequest = 'This script requires administrative privileges to run. Press [ENTER] to run as administrator or any key to cancel.';

    AttemptingToLocate = 'Locating gacha log URL...';
    FailedToLocatePath1 = 'Failed to locate game path! Please contact script provider for support. Error Code: 1';
    FailedToLocatePath2 = 'Failed to locate game path! Please contact script provider for support. Error Code: 2';
    ScriptProvider1 = 'Discord Server: https://discord.gg/e48fzqxuPM';
    ScriptProvider2 = 'Discord Server: https://discord.gg/srs';

    YSCacheOS = 'Using Global cache location';
    YSCacheCN = 'Using China cache location';
}