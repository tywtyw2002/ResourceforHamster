{
  Button(name, spec, themeR, overrides={})::
    local mkId(suffix) = '%s_btn_%s' % [name, suffix];

    local theme = std.mergePatch(themeR, overrides);

    local items = spec.actions;
    local actions = std.prune({
      action: items.action,

      uppercasedStateAction: std.get(items, 'caps'),
      repeatAction: std.get(items, 'repeat'),
      preeditStateAction: std.get(items, 'preedit'),

      swipeUpAction: std.get(items, 'swipe_up'),
      swipeDownAction: std.get(items, 'swipe_down'),
      swipeLeftAction: std.get(items, 'swipe_left'),
      swipeRightAction: std.get(items, 'swipe_right'),
    });

    // process styles
    local kvMap = {
      fg: 'foregroundStyle',
      caps: 'capsLockedStateForegroundStyle',
      upper: 'uppercasedStateForegroundStyle',
      preedit: 'preeditStateForegroundStyle',
    };
    local labels = spec.labels;

    local activeKeys = std.set(
      [
        k
        for k in std.flattenArrays([std.objectFields(z) for z in std.objectValues(labels)])
        if std.objectHas(kvMap, k)
      ]
    );

    local fg_styles = {
      [kvMap[k]]: [
        local itemObj = labels[item];
        if std.objectHas(itemObj, k) then
          mkId(item + '_' + k)
        else if std.objectHas(itemObj, 'fg') then
          mkId(item + '_fg')
        for item in std.objectFields(labels)
      ]
      for k in activeKeys
    };

    // process fg styles instances
    local getStyleContent(actionKey, statusKey) =
      // actionKey  main up down ....
      // statusKey fg caps...
      local key = if actionKey == 'main' then statusKey else '%s_%s' % [statusKey, actionKey];
      local sKey = std.get(theme, key, theme.fg);
      { ctx: sKey };

    local fg_defines = {
      [mkId(k + '_' + sk)]: labels[k][sk] + getStyleContent(k, sk)
      for k in std.objectFields(labels)
      for sk in std.objectFields(labels[k])
    };

    // hintStyle
    local getHintStyle(action) =
      local sKey = std.get(action, 'style', theme.hint_fg);
      { ctx: sKey };

    local genHintStyle(actions) =
      local mkHintId(k) = mkId('hint_' + k);
      local genStyleName(name) = if std.objectHas(actions, name) then mkHintId(name) else null;

      local base = std.prune({
        insets: theme.hint_insets,
        backgroundStyle: theme.hint_bg,
        foregroundStyle: genStyleName('fg'),
        swipeUpForegroundStyle: genStyleName('up'),
        swipeDownForegroundStyle: genStyleName('down'),
        swipeLeftForegroundStyle: genStyleName('left'),
        swipeRightForegroundStyle: genStyleName('right'),
      });

      // rules
      local style_rules = {
        [genStyleName(e.key)]: e.value.labels + getHintStyle(e.value)
        for e in std.objectKeysValues(actions)
      };

      {
        [mkId('hint')]: base,
      } + style_rules;

    local hint_actions = std.get(spec, 'hint', {});
    local hint_defines = if std.length(hint_actions) > 0 then
      genHintStyle(hint_actions)
    else
      {};

    // holdSymbolsStyle
    local getHoldStyle(action) =
      local sKey = std.get(action, 'style', theme.hold_fg);
      { ctx: sKey };

    local genHoldStyles(payloads) =
      local actions = payloads.actions;
      local mkHoldKey(i) = mkId('hold_action_%d' % i);

      local rules = {
        [if std.length(theme.hold_insets) > 0 then 'insets']: theme.hold_insets,
        backgroundStyle: theme.hold_bg,
        selectedStyle: theme.hold_select,
        selectedIndex: std.get(payloads, 'index', 1),
        actions: [a.action for a in actions],
        foregroundStyle: [
          mkHoldKey(i)
          for i in std.range(0, std.length(actions) - 1)
        ],
      };

      local style_rules = {
        [mkHoldKey(i)]:
          local action = actions[i];
          action.labels + getHoldStyle(action)
        for i in std.range(0, std.length(actions) - 1)
      };

      {
        [mkId('hold')]: rules,
      } + style_rules;

    local hold_actions = std.get(spec, 'hold', {});
    local hold_defines = if std.length(hold_actions) > 0 then
      genHoldStyles(hold_actions)
    else
      {};

    // root_rules
    local root_rules = {
      // size
      size: theme.size,
      backgroundStyle: theme.bg,
      [if std.length(std.get(theme, 'bounds', {})) > 0 then 'bounds']: theme.bounds,
      [if std.length(hold_actions) > 0 then 'holdSymbolsStyle']: mkId('hold'),
      [if std.length(hint_actions) > 0 then 'hintStyle']: mkId('hint'),
    };

    {
      [mkId('_root')]: root_rules + actions + fg_styles,
    } + fg_defines + hold_defines + hint_defines,
}
