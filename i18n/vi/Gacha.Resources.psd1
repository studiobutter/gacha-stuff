@{
    Greeting = 'Welcome to Gacha Log Interactive Clipboard Menu!';
    RegRememberChoice = 'Do you want to remember this language selection for next time? (y/n)';
    RegRememberFailed = 'Failed to saved to registry:';
    RegRememberSuccess = 'Language selection saved to registry successfully.';
    RegSuggestAdmin = 'You may need to run PowerShell as Administrator to save this setting.';
    RegRememberCancelled = 'Operation cancelled. No changes made to the registry.';

    GachaMenuTitle = 'Gacha Clipboard Catcher';
    GachaMenuDescription = 'Select which Gacha link to obtain:';
    GachaMenuOptions = @(
        '1. Genshin Impact',
        '2. Honkai: Star Rail',
        '3. Zenless Zone Zero'
        'Press 0 to Exit'
    );
    GachaMenuChoice = 'Enter your choice';
    GachaMenuInvalidChoice = 'Invalid choice. Please try again.';
    GachaMenuAnyKey = 'Press any key to return to the menu...';
    GachaMenuExit = 'Cleaning Temp Files and Exiting...';

    GachaMenuChooseLink = 'Choose a Gacha link to obtain:';
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
    TaskCompleted = 'Task completed. If any error occurs, please rerun the script or follow the instruction above to contact support. Press any key to exit.';

    RegionChoice = 'Select your choice:';
    GachaMenuInvalidRegion = 'Invalid region choice. Please try again.';

    CloudChoice = 'Type "1" to copy Global Gacha URL, "2" for China Gacha URL.';
    NoURL = 'No matching URL found or URL cannot located. Please open the Gacha History in-game.';
    Copied = 'Gacha Log URL copied to clipboard:';
    PasteInstructions = 'Paste it in your favorite Wish Tracker Service';
    InvalidChoice = 'Invalid choice. Please run the command again.';

    RegionUnavailable = 'This region is currently unavailable. Please choose another region.';
    AdminRequest = 'This script requires administrative privileges to run. Press [ENTER] to run as administrator or any key to cancel.';

    AttemptingToLocate = 'Attempting to locate Gacha Log URL...';
    FailedToLocateLogCN = 'Failed to locate log file! Please try rerun the script with the Global region option.';
    FailedToLocateLogOS = 'Failed to locate log file! Please try rerun the script with the Global region option.';
    FailedToLocateLog = 'Failed to locate log file! Make sure to open the Gacha History in-game first.';
    FailedToLocatePath1 = 'Failed to locate game path! Please contact script provider for support. Error Code: 1';
    FailedToLocatePath2 = 'Failed to locate game path! Please contact script provider for support. Error Code: 2';
    ScriptProvider1 = 'Provider Support Discord Server: https://discord.gg/e48fzqxuPM'
    ScriptProvider2 = 'Provider Support Discord Server: https://discord.gg/srs';

    ZZZURLFound = 'Signal History URL found:';
    ZZZURLClipboard = 'Signal History URL saved to clipboard.';
    
    SRURLFound = 'Warp History URL found:';
    SRURLClipboard = 'Warp History URL saved to clipboard.';

    YSCacheOS = 'Using Global cache location';
    YSCacheCN = 'Using China cache location';
    
    GachaLogInstructions = 'Now paste it in your Favorite Gacha Log Tracker (i.e: zzz.rng.moe, Hoyo Buddy, etc)';
}