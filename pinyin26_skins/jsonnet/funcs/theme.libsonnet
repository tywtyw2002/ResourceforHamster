local stringifyNumbers(val) =
  // if true then val else
  if std.isObject(val) then
    { [k]: stringifyNumbers(val[k]) for k in std.objectFields(val) }
  else if std.isArray(val) then
    [stringifyNumbers(v) for v in val]
  else if std.isNumber(val) then
    std.format('%.10g', val)
  else
    val;

{
  // mkTheme 函数
  // 优化内容：修复了 stripChars 的逻辑错误，使用推导式提升可读性
  mkTheme(prefix, config, override={})::
    local actualConfig = config + override;

    // 内部辅助：首字母大写
    local capitalize(s) = if std.length(s) > 0 then std.asciiUpper(s[0]) + s[1:] else s;

    // 内部辅助：snake_case 转 CamelCase
    local toCamelCase(str) =
      std.join('', [capitalize(part) for part in std.split(str, '_')]);

    // 内部辅助：安全移除后缀并生成 RefName
    local makeRefName(key) =
      if key == 'bg' || key == 'fg' then
        prefix + std.asciiUpper(key)
      else if std.endsWith(key, '_bg') then
        prefix + toCamelCase(key[0:std.length(key) - 3]) + 'BG'
      else if std.endsWith(key, '_fg') then
        prefix + toCamelCase(key[0:std.length(key) - 3]) + 'FG'
      else
        prefix + toCamelCase(key);

    // 预过滤有效字段，避免在后续多次循环中重复判断
    local validFields = [
      f
      for f in std.objectFields(actualConfig)
      if f != 'mixin' && f != 'const' && !std.startsWith(f, '_')
    ];

    // 1. 生成 themeRef
    local themeRef = (if std.objectHas(actualConfig, 'mixin') then actualConfig.mixin else {}) + {
      [f]: makeRefName(f)
      for f in validFields
    };

    // 2. 生成 themeStyle (处理所有背景相关的配置)
    local themeStyle = {
      [themeRef[f]]: actualConfig[f]
      for f in validFields
      if f == 'bg' || std.endsWith(f, '_bg')
    };

    // 3. 生成 styleRef (处理所有前景相关的配置)
    local styleRef = {
      [themeRef[f]]: actualConfig[f]
      for f in validFields
      if f == 'fg' || std.endsWith(f, '_fg')
    };

    [themeRef, themeStyle, styleRef],
}
