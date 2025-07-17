@{
    Greeting             = "歡迎使用抽卡紀錄 URL 獲取工具！";
    RegRememberChoice    = "是否記住語言選擇？(y/n)";
    RegRememberFailed    = "儲存到註冊表失敗：";
    RegRememberSuccess   = "語言選擇已成功儲存到註冊表。";
    RegSuggestAdmin      = "您可能需要以系統管理員身份執行 PowerShell 來儲存此設定。";
    RegRememberCancelled = "操作已取消。未對註冊表進行任何變更。";
    EnterChoice          = "請輸入您的選擇";
    NoURL                = "未找到抽卡紀錄 URL，請先在遊戲內開啟抽卡歷史紀錄後再執行。";
    Copied               = "抽卡紀錄 URL 已複製到剪貼簿：";
    PasteInstructions    = "請將其貼到您喜歡的抽卡紀錄追蹤工具中（如 zzz.rng.moe、Hoyo Buddy 等）";
    InvalidChoice        = "無效選擇。請重試。";
    URLFound             = "已找到抽卡紀錄 URL：";
    GachaMenuTitle       = "抽卡紀錄 URL 取得工具";
    GachaMenuDescription = "選擇遊戲：";
    GachaMenuOptions     = @(
        "1. 原神",
        "2. 崩壞：星穹鐵道",
        "3. 絕區零",
        "按 0 結束"
    );
    GachaMenuAnyKey      = "按任意鍵返回選單...";
    GachaMenuExit        = "正在清理暫存檔案並結束...";
    GachaMenuChooseLink  = "選擇區域：";
    RegionOptions        = @(
        "1. 國際版",
        "2. 中國服",
        "3. 雲端遊戲",
        "按 0 結束"
    );
    RegionOptionsNoCloud = @(
        "1. 國際版",
        "2. 中國服",
        "按 0 結束"
    );
    CloudOptions         = @(
        "1. 國際版",
        "2. 中國服",
        "按 0 結束"
    );

    TaskCompleted        = "任務完成。如果出現任何錯誤，請重新執行腳本或聯絡技術支援。按任意鍵結束。";
    RegionUnavailable    = "此區域目前無法使用。請選擇其他區域。";
    AdminRequest         = "此腳本需要系統管理員權限才能執行。按 [Enter] 以系統管理員身份執行或按任意鍵取消。";
    AttemptingToLocate   = "正在定位抽卡紀錄 URL...";
    FailedToLocatePath1  = "無法定位遊戲路徑！請聯絡腳本提供者尋求支援。錯誤代碼：1";
    FailedToLocatePath2  = "無法定位遊戲路徑！請聯絡腳本提供者尋求支援。錯誤代碼：2";
    ScriptProvider1      = "Discord 伺服器：https://discord.gg/e48fzqxuPM";
    ScriptProvider2      = "Discord 伺服器：https://discord.gg/srs";
    YSCacheOS            = "使用國際版快取位置";
    YSCacheCN            = "使用中國服快取位置";

        # --- MISSING STRINGS, NEED TRANSLATION ---
    BlankLine = "";
    SuggestAdmin = "";
    ToolSelection = "";
    ToolOptions = @("");
    CleanerOptions = @("");
    DisabledChoice = "";
    ToolCleanerDisclaimer1 = "";
    ToolCleanerDisclaimer2 = "";
    ToolCleanerDisclaimer3 = @("");
    ToolCleanerDisclaimer4 = "";
    ToolCleanerDisclaimer5 = "";
    ToolCleanerDisclaimer6 = "";
    ToolCleanerDisclaimer7 = "";
    ToolCleanerDisclaimer8 = "";
    ToolCleanerDisclaimer9 = "";
    ToolCleanerDisclaimerLink = "";
    ToolCleanerAnyKey = "";
    hk4e_cn = "";
    hk4e_cn_b = "";
    hk4e_global = "";
    hk4e_global_gplay = "";
    hk4e_global_epic = "";
    hkrpg_cn = "";
    hkrpg_cn_b = "";
    hkrpg_global = "";
    hkrpg_global_epic = "";
    nap_cn = "";
    nap_cn_b = "";
    nap_global = "";
    nap_global_epic = "";
    LauncherConfigNotFound = "";
    GameDataFolderNotFound = "";
    GameInstalled = "";
    GameCacheSelection = "";
    GameCacheRemovedStatus = "";
    GameCacheRemoved = "";
    GameCacheNotFound = "";
    GameCacheAlreadyRemoved = "";
    GameCacheRemoveHint = "";
    GameCacheNotFoundAll = "";
    GameCacheVerNotFound = "";
    GameCacheVerRemoved = "";
    GameCacheVerCleared = "";
    GameCacheVerFailed = "";
    GameCacheFailed = "";
    GameDataNotFound = "";
    GoBack = "";
    CollapseGameFolderNotFound = "";
    CloudContinuePrompt = "";
    CloudLogFileDeleted = "";
    CloudLogFileNotFound = "";
    CloudDirectoryNotFound = "";
    CloudNoFilesDeleted = "";
    LanguageResetPrompt = "";
    LanguageResetSuccess = "";
    LanguageResetCancelled = "";
    LanguageResetInvalidInput = "";
}