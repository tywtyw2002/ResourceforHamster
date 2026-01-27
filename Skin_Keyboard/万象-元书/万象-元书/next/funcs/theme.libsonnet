{
  // mkTheme 函数
  // 参数:
  //   prefix: 主题前缀字符串
  //   config: 配置对象
  //   override: 覆盖配置（可选）
  // 返回: [themeRef, themeStyle, styleRef]
  mkTheme(prefix, config, override={})::
    local actualConfig = config + override;

    // 辅助函数：将 snake_case 转换为 CamelCase (首字母大写)
    local toCamelCase(str) =
      local parts = std.split(str, '_');
      local capitalized = std.map(function(part)
        std.asciiUpper(part[0:1]) + part[1:], parts);
      std.join('', capitalized);

    // 辅助函数：生成引用名
    local makeRefName(key) =
      if std.endsWith(key, '_bg') then
        local baseName = std.stripChars(key, '_bg');
        prefix + toCamelCase(baseName) + 'BG'
      else if std.endsWith(key, '_fg') then
        local baseName = std.stripChars(key, '_fg');
        prefix + toCamelCase(baseName) + 'FG'
      else if key == 'bg' then
        prefix + 'BG'
      else if key == 'fg' then
        prefix + 'FG'
      else
        prefix + toCamelCase(key);

    // 生成 themeRef
    local themeRef =
      // 首先添加 mixin 中的内容
      (if std.objectHas(actualConfig, 'mixin') then actualConfig.mixin else {}) +

      // 然后生成其他字段的引用
      std.foldl(
        function(acc, key)
          if key == 'mixin' || key == 'const' || std.startsWith(key, '_') then
            acc
          else
            acc { [key]: makeRefName(key) }
        ,
        std.objectFields(actualConfig),
        {}
      );

    // 生成 themeStyle (所有 _bg 结尾的或 bg)
    local themeStyle =
      std.foldl(
        function(acc, key)
          if (std.endsWith(key, '_bg') || key == 'bg') &&
             key != 'mixin' && key != 'const' && !std.startsWith(key, '_') then
            local refName = themeRef[key];
            acc { [refName]: actualConfig[key] }
          else
            acc
        ,
        std.objectFields(actualConfig),
        {}
      );

    // 生成 styleRef (所有 _fg 结尾的或 fg)
    local styleRef =
      std.foldl(
        function(acc, key)
          if (std.endsWith(key, '_fg') || key == 'fg') &&
             key != 'mixin' && key != 'const' && !std.startsWith(key, '_') then
            local refName = themeRef[key];
            acc { [refName]: actualConfig[key] }
          else
            acc
        ,
        std.objectFields(actualConfig),
        {}
      );

    [themeRef, themeStyle, styleRef],
}
