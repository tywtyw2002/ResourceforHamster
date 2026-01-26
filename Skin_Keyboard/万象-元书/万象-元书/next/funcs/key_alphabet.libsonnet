local utils = import 'utils.libsonnet';

local isAlpha(c) =
  local lowerC = std.asciiLower(c);
  lowerC >= 'a' && lowerC <= 'z';

{
  BuildSpec(conf, autoCaps=true)::
    local actionKey = ['action', 'caps', 'repeat', 'preedit'];
    local swipeKey = ['up', 'down', 'right', 'left'];

    // parse actions
    local swipe = std.get(conf, 'swipe', {});
    local actions = std.prune({
      [k]: utils.mkAction(std.get(conf, k))
      for k in actionKey
    } + {
      ['swipe_' + k]: utils.mkAction(std.get(swipe, k))
      for k in swipeKey
    });

    // should do cap.
    local shouldCaps = autoCaps && isAlpha(std.get(actions.action.label, 'text', 1));

    // parse hold.
    local genHoldActions(hold) =
      local actions = [
        utils.mkAction(action)
        for action in hold.actions
      ];

      {
        actions: actions,
        index: std.get(hold, 'select_index', 1),
      };

    // process label
    local labels =
      local label = actions.action.label;
      {
        main: {
          fg: label,
          [if shouldCaps then 'caps']: { text: std.asciiUpper(label.text) },
          [if shouldCaps then 'upper']: self.caps,
        },
      } + {
        [key]: {
          fg: actions[key].label,
        }
        for k in swipeKey
        for key in ['swipe_' + k]
        if key in actions
      };

    // process hint
    local hint = {
      fg: { label: actions.action.label },
    } + {
      [k]: { label: actions[key].label }
      for k in swipeKey
      for key in ['swipe_' + k]
      if key in actions
    };

    // return
    {
      actions: {
        [e.key]: e.value.action
        for e in std.objectKeysValues(actions)
      } + {
        [if shouldCaps then 'caps']: {
          character: std.asciiUpper(actions.action.action.character),
        },
      },

      labels: labels,
      hint: hint,

      [if std.objectHas(conf, 'hold') then 'hold']: genHoldActions(conf.hold),
    },
}
