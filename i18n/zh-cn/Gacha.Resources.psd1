@{
    Greeting             = '欢迎使用抽卡记录 URL 获取工具！';
    RegRememberChoice    = '是否记住语言选择？(y/n)';
    RegRememberFailed    = '保存到注册表失败：';
    RegRememberSuccess   = '语言选择已成功保存到注册表。';
    RegSuggestAdmin      = '您可能需要以管理员身份运行 PowerShell 来保存此设置。';
    RegRememberCancelled = '操作已取消。未对注册表进行任何更改。';
    EnterChoice          = '请输入您的选择';
    NoURL                = '未找到抽卡记录 URL，请先在游戏内打开抽卡历史记录后再运行。';
    Copied               = '抽卡记录 URL 已复制到剪贴板：';
    PasteInstructions    = '请将其粘贴到您喜欢的抽卡记录追踪工具中（如 zzz.rng.moe、Hoyo Buddy 等）';
    InvalidChoice        = '无效选择。请重试。';
    URLFound             = '已找到抽卡记录 URL：';
    GachaMenuTitle       = '抽卡记录 URL 获取工具';
    GachaMenuDescription = '选择游戏：';
    GachaMenuOptions     = @(
        '1. 原神',
        '2. 崩坏：星穹铁道',
        '3. 绝区零',
        '按 0 退出'
    );
    GachaMenuAnyKey      = '按任意键返回菜单...';
    GachaMenuExit        = '正在清理临时文件并退出...';
    GachaMenuChooseLink  = '选择区域：';
    RegionOptions        = @(
        '1. 国际服',
        '2. 国服',
        '3. 云游戏',
        '按 0 退出'
    );
    RegionOptionsNoCloud = @(
        '1. 国际服',
        '2. 国服',
        '按 0 退出'
    );
    CloudOptions         = @(
        '1. 国际服',
        '2. 国服',
        '按 0 退出'
    );
       
    TaskCompleted        = '任务完成。如果出现任何错误，请重新运行脚本或联系技术支持。按任意键退出。';
    RegionUnavailable    = '此区域当前不可用。请选择其他区域。';
    AdminRequest         = '此脚本需要管理员权限才能运行。按 [回车] 以管理员身份运行或按任意键取消。';
    AttemptingToLocate   = '正在定位抽卡记录 URL...';
    FailedToLocatePath1  = '无法定位游戏路径！请联系脚本提供者寻求支持。错误代码：1';
    FailedToLocatePath2  = '无法定位游戏路径！请联系脚本提供者寻求支持。错误代码：2';
    ScriptProvider1      = 'Discord 服务器：https://discord.gg/e48fzqxuPM';
    ScriptProvider2      = 'Discord 服务器：https://discord.gg/srs';
    YSCacheOS            = '使用国际服缓存位置';
    YSCacheCN            = '使用国服缓存位置';
}