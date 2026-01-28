local utils = import 'utils.libsonnet';

// 优化 1: 增强 isAlpha 的健壮性
local isAlpha(c) =
  if std.type(c) != 'string' || std.length(c) == 0 then false
  else
    // local lowerC = std.asciiLower(c[0]);
    local lowerC = c[0];
    lowerC >= 'a' && lowerC <= 'z';

{
  BuildSpec(conf, autoCaps=true)::
    local actionKeys = ['action', 'caps', 'repeat', 'preedit'];
    local swipeKeys = ['up', 'down', 'right', 'left'];
    local swipeConf = std.get(conf, 'swipe', {});

    // 优化 2: 统一提取 Actions，减少重复逻辑
    // 合并基础动作和滑动动作的解析
    local actions = std.prune({
      [k]: utils.mkAction(std.get(conf, k))
      for k in actionKeys
    } + {
      ['swipe_' + k]: utils.mkAction(std.get(swipeConf, k))
      for k in swipeKeys
    });

    // 提取主要动作引用，方便后续调用
    local mainAction = std.get(actions, 'action', {});
    local mainLabel = std.get(mainAction, 'label', { text: '' });

    // 优化 3: 安全获取字符进行大小写判断
    local shouldCaps = autoCaps && isAlpha(std.get(mainLabel, 'text', ''));

    // 内部转换函数
    local genHoldActions(hold) = {
      actions: [utils.mkAction(a) for a in hold.actions],
      index: std.get(hold, 'select_index', 1),
    };

    // 优化 4: 提取活跃的滑动键列表，减少循环中的条件判断
    local activeSwipeKeys = [k for k in swipeKeys if 'swipe_' + k in actions];

    // 构造 labels
    local labels = {
      main: {
        fg: mainLabel,
        [if shouldCaps then 'caps']: { text: std.asciiUpper(mainLabel.text) },
        [if shouldCaps then 'upper']: self.caps,
      },
    } + {
      ['swipe_' + k]: { fg: actions['swipe_' + k].label }
      for k in activeSwipeKeys
    };

    // 构造 hint
    local hint = {
      fg: { label: mainLabel },
    } + {
      [k]: { label: actions['swipe_' + k].label }
      for k in activeSwipeKeys
    };

    // 返回最终对象
    {
      actions: {
        [e.key]: e.value.action
        for e in std.objectKeysValues(actions)
      } + (
        if shouldCaps && std.objectHasAll(mainAction, 'action') then {
          caps: { character: std.asciiUpper(mainAction.action.character) },
        } else {}
      ),

      labels: labels,
      hint: hint,

      [if std.objectHas(conf, 'hold') then 'hold']: genHoldActions(conf.hold),
    },
}
