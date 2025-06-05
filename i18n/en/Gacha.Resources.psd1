@{
    BlankLine = '';
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
        '4. Settings',
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
    CloudOptions = @(
        '1. Global',
        '2. China',
        'Press 0 to Exit'
        );
        
    TaskCompleted = 'Task completed. If any error occurred, rerun the script or contact support. Press any key to exit.';
    RegionUnavailable = 'This region is currently unavailable. Please choose another region.';
    AdminRequest = 'This script requires administrative privileges to run. Press [ENTER] to run as administrator or any key to cancel.';

    AttemptingToLocate = 'Locating gacha log URL...';
    FailedToLocatePath1 = 'Failed to locate game path! Please contact script provider for support. Error Code: 1';
    FailedToLocatePath2 = 'Failed to locate game path! Please contact script provider for support. Error Code: 2';
    ScriptProvider1 = 'Discord Server: https://discord.gg/e48fzqxuPM';
    ScriptProvider2 = 'Discord Server: https://discord.gg/srs';

    YSCacheOS = 'Using Global cache location';
    YSCacheCN = 'Using China cache location';

    # This sections is for tools.
    ToolSelection = 'Select a tool to run:';
    ToolOptions = @(
        '1. Cache Cleaner',
        '2. Reset Language Settings',
        'Press 0 to Exit'
    );

    ToolCleanerDisclaimer1 = 'This tool will delete all cache files from the game.';
    ToolCleanerDisclaimer2 = 'If you have any other similar region of the game installed'
    ToolCleanerDisclaimer3 = @(
        'Example'
        '- Genshin Impact (China) - Celestia and Genshin Impact (China) - Irminsul (BiliBili)'
        '- Honkai: Star Rail (China) - Astral Express and Honkai: Star Rail (China) - The Nameless (BiliBili)'
        '- Zenless Zone Zero (China) and Zenless Zone Zero (BiliBili)'
        '- Genshin Impact (Global) and Genshin Impact (Global) - Google Play)'
    )
    ToolCleanerDisclaimer4 = 'Please open those versions of the game for few seconds and then close them before running this tool.';
    ToolCleanerDisclaimer5 = 'For more information, you can read about it here:';
    ToolCleanerDisclaimerLink = '';

    ToolCleanerAnyKey = 'Press any key to continue...';
}