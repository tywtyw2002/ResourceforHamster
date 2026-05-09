local utils = import 'utils.libsonnet';
{
  BuildSpec(conf)::
    local actionKeys = ['action', 'caps', 'upper', 'repeat', 'preedit'];
    local swipeKeys = ['up', 'down', 'right', 'left'];
    local swipeConf = std.get(conf, 'swipe', {});

    // 合并基础动作和滑动动作的解析
    local actions = std.prune({
      [k]: utils.mkAction(std.get(conf, k))
      for k in actionKeys
    } + {
      ['swipe_' + k]: utils.mkAction(std.get(swipeConf, k))
      for k in swipeKeys
    });

    // 提取主要动作引用
    local mainAction = std.get(actions, 'action', {});
    local mainLabel = std.get(mainAction, 'label', { text: '' });

    // 需求 1: 处理额外的 labels
    local extraLabelsConf = std.get(conf, 'labels', {});
    local extraLabels = {
      ['ex_' + l_key]: {
        [attr]: utils.mkAction(extraLabelsConf[l_key][attr]).label
        for attr in std.objectFields(extraLabelsConf[l_key])
      }
      for l_key in std.objectFields(extraLabelsConf)
    };

    // 内部转换函数
    local genHoldActions(hold) = {
      actions: [utils.mkAction(a) for a in hold.actions],
      index: std.get(hold, 'select_index', 1),
    };

    local activeSwipeKeys = [k for k in swipeKeys if 'swipe_' + k in actions];

    // process preedit labels
    local hasPreedit = std.objectHas(std.get(actions, 'preedit', {}), 'label');

    // 构造 labels (包含原有逻辑 + 需求 1 的 extraLabels)
    local labels = {
      main:
        local hasCaps = std.objectHas(actions, 'caps');
        {
          fg: mainLabel,
          [if hasCaps then 'caps']: actions.caps.label,
          [if hasCaps then 'upper']: if std.objectHas(actions, 'upper') then actions.upper.label else self.caps,
        },
      [if hasPreedit then 'preedit']: {
        fg: actions.preedit.label,
      },
    } + {
      ['swipe_' + k]: { fg: actions['swipe_' + k].label }
      for k in activeSwipeKeys
      if std.objectHas(actions['swipe_' + k], 'label')
    } + extraLabels;

    // 需求 2: 构造 hint (基于 conf.hints)
    local hintsConf = std.get(conf, 'hints', {});
    local extraHintsConf = std.get(hintsConf, 'extra', {});
    local hint = std.prune({
      // 根据 hints.action 开关决定是否添加 fg
      [if std.get(hintsConf, 'action', false) then 'fg']: { label: mainLabel },
    } + {
      // 根据 hints.swipe_? 开关决定是否添加对应的滑动 hint
      [k]: if std.get(hintsConf, 'swipe_' + k, false) && std.objectHas(actions, 'swipe_' + k) then { label: actions['swipe_' + k].label }
      for k in swipeKeys
    } + {
      // 处理 hints.extra
      ['ex_' + xkey]: utils.mkAction(extraHintsConf[xkey]).label
      for xkey in std.objectFields(extraHintsConf)
    });

    // 返回最终对象
    {
      actions: {
        [e.key]: e.value.action
        for e in std.objectKeysValues(actions)
        if std.objectHas(e.value, 'action')
      },

      labels: labels,
      [if std.length(hint) > 0 then 'hint']: hint,
      [if std.objectHas(conf, 'hold') then 'hold']: genHoldActions(conf.hold),
    },
}
