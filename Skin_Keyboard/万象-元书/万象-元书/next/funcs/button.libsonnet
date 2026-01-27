{
  Button(name, spec, themeR, overrides={})::
    local mkId(suffix) = '%s_btn_%s' % [name, suffix];
    local theme = std.mergePatch(themeR, overrides);

    // 1. 优化动作处理：配置化映射
    local actionMap = {
      action: 'action',
      caps: 'uppercasedStateAction',
      repeat: 'repeatAction',
      preedit: 'preeditStateAction',
      swipe_up: 'swipeUpAction',
      swipe_down: 'swipeDownAction',
      swipe_left: 'swipeLeftAction',
      swipe_right: 'swipeRightAction',
    };
    local actions = std.prune({
      [actionMap[k]]: std.get(spec.actions, k)
      for k in std.objectFields(actionMap)
    });

    // 2. 样式上下文通用处理函数
    local wrapStyle(labels, styleKey) = labels { ctx: styleKey };

    // 3. 前景色样式 (Foreground Styles) 处理
    local kvMap = {
      fg: 'foregroundStyle',
      caps: 'capsLockedStateForegroundStyle',
      upper: 'uppercasedStateForegroundStyle',
      preedit: 'preeditStateForegroundStyle',
    };
    local labels = spec.labels;

    // 获取所有在 labels 中定义的且在 kvMap 中的 key
    local activeKeys = std.set([
      k
      for item in std.objectValues(labels)
      for k in std.objectFields(item)
      if std.objectHas(kvMap, k)
    ]);

    local fg_styles = {
      [kvMap[k]]: [
        local itemObj = labels[item];
        // 逻辑优化：如果当前状态没有定义，则回退到 'fg'
        local suffix = if std.objectHas(itemObj, k) then k else 'fg';
        mkId(item + '_' + suffix)
        for item in std.objectFields(labels)
      ]
      for k in activeKeys
    };

    local fg_defines = {
      [mkId(k + '_' + sk)]:
        local sKey = if k == 'main' then sk else '%s_%s' % [k, sk];
        local sKeyFix = if std.endsWith(sKey, 'fg') then sKey else sKey + '_fg';
        wrapStyle(labels[k][sk], std.get(theme, sKeyFix, theme.fg))
      for k in std.objectFields(labels)
      for sk in std.objectFields(labels[k])
    };

    // 4. Hint 样式优化
    local hint_actions = std.get(spec, 'hint', {});
    local hint_defines = if std.length(hint_actions) > 0 then (
      local mkHintId(k) = mkId('hint_' + k);
      local swipeMap = { fg: 'foregroundStyle', up: 'swipeUpForegroundStyle', down: 'swipeDownForegroundStyle', left: 'swipeLeftForegroundStyle', right: 'swipeRightForegroundStyle' };

      local base = std.prune({
        insets: theme.hint_insets,
        backgroundStyle: theme.hint_bg,
      } + {
        [swipeMap[k]]: if std.objectHas(hint_actions, k) then mkHintId(k)
        for k in std.objectFields(swipeMap)
      });

      { [mkId('hint')]: base } + {
        // [mkHintId(k)]: wrapStyle(hint_actions[k].label, std.get(hint_actions[k], 'style', theme.hint_fg))
        // do not support hint style.
        [mkHintId(k)]: wrapStyle(hint_actions[k].label, theme.hint_fg)
        for k in std.objectFields(hint_actions)
      }
    ) else {};

    // 5. Hold 样式优化
    local hold_payloads = std.get(spec, 'hold', {});
    local hold_defines = if std.length(hold_payloads) > 0 then (
      local h_actions = hold_payloads.actions;
      local mkHoldKey(i) = mkId('hold_action_%d' % i);

      {
        [mkId('hold')]: std.prune({
          insets: theme.hold_insets,
          backgroundStyle: theme.hold_bg,
          selectedStyle: theme.hold_select_bg,
          selectedIndex: std.get(hold_payloads, 'index', 1),
          actions: [a.action for a in h_actions],
          foregroundStyle: [mkHoldKey(i) for i in std.range(0, std.length(h_actions) - 1)],
        }),
      } + {
        [mkHoldKey(i)]: wrapStyle(h_actions[i].label, std.get(h_actions[i], 'style', theme.hold_fg))
        for i in std.range(0, std.length(h_actions) - 1)
      }
    ) else {};

    // 6. 根规则合并
    local root_rules = std.prune({
      size: theme.size,
      backgroundStyle: theme.bg,
      bounds: if std.length(std.get(theme, 'bounds', {})) > 0 then theme.bounds,
      holdSymbolsStyle: if std.length(hold_payloads) > 0 then mkId('hold'),
      hintStyle: if std.length(hint_actions) > 0 then mkId('hint'),
    });

    {
      [mkId('_root')]: root_rules + actions + fg_styles,
    } + fg_defines + hold_defines + hint_defines,
}
