local btnFactory = import '../../funcs/button.libsonnet';
local system_key = import '../../funcs/key_system.libsonnet';

local dark_config = import '../../config/theme_dark.jsonnet';
local lib_theme = import '../../funcs/theme.libsonnet';

// mk theme.
local system_theme = lib_theme.mkTheme('Tsystem', dark_config.system, {});

// system keys
local key_shift = {
  action: { action: 'shift', label: { systemImageName: 'shift' } },
  caps: { action: null, label: { systemImageName: 'capslock.fill' } },
  upper: { action: null, label: { systemImageName: 'shift.fill' } },
  swipe: {
    up: { character: "'", label: null },
    down: { character: '\\', label: null },
  },
  hold: {
    actions: [{ shortcutCommand: '#中英切换', label: '中英' }],
    select_index: 0,
  },
  overrides: {
    size: { width: 0.15 },
    bounds: { width: '151/168.75', alignment: 'left' },
  },
};

local key_backspace = {
  action: { action: 'backspace', label: { systemImageName: 'delete.left' } },
  repeat: { action: 'backspace' },
  swipe: {
    // left: { shortcutCommand: '#重输', label: null },
    up: { shortcutCommand: '#deleteText', label: null },
  },
  overrides: {
    size: { width: 0.15 },
    bounds: { width: '151/168.75', alignment: 'right' },
  },
};

local key_123 = {
  action: { keyboardType: 'numeric', label: '123' },
  swipe: {
    up: { shortcutCommand: '#RimeSwitcher' },
    right: { shortcutCommand: '#方案切换' },
  },
  hold: {
    actions: [
      { keyboardType: 'emoji', label: { systemImageName: 'face.dashed.fill' } },
      { keyboardType: 'symbolic', label: { systemImageName: 'ellipsis.curlybraces' } },
      { shortcutCommand: '#RimeSwitcher', label: { systemImageName: 'timeline.selection' } },
      { shortcutCommand: '#方案切换', label: { systemImageName: 'filemenu.and.selection' } },
    ],
    select_index: 0,
  },
  overrides: {
    size: { width: 0.12 },
  },
};

local key_zhen = {
  action: { keyboardType: 'alphabetic', label: { assetImageName: 'chineseState' } },
};


local key_comma = {
  action: { character: ',', label: '，' },
  repeat: ',',
  swipe: {
    up: { symbol: ',' },
  },
  hold: {
    actions: [{ action: 'nextKeyboard', label: '🌐︎' }],
    select_index: 0,
  },
};

local key_space = {
  action: { action: 'space', label: { systemImageName: 'space' } },
  swipe: {
    up: { shortcutCommand: '#次选上屏', label: null },
    down: { shortcutCommand: '#三选上屏', label: null },
    left: { sendKeys: 'Left', label: null },
    right: { sendKeys: 'Right', label: null },
  },
  overrides: {
    size: { width: 0.36 },
  },
};

local key_dot = {
  action: { character: '.', label: '。' },
  repeat: ',',
  swipe: {
    up: { symbol: '.' },
    right: { character: '!', label: null },
  },
};

local key_enter_bg_code = |||
  // JavaScript
  function getText() {
    let type = $getReturnKeyType();
    if (type === 1 || type === 4 || type === 7) {
      return "%s";
    }
    return "%s";
  }
||| % [system_theme[0].blue_bg, system_theme[0].bg];

local key_entry_label_code = |||
  // JavaScript
  function getText() {
    const type = $getReturnKeyType();
    switch (type) {
      case 1:
        return "前往";
      case 3:
        return "加入";
      case 4:
        return "前往";
      case 6:
        return "搜索"
      case 7:
        return "发送"
      case 9:
        return "完成";
      default:
        return "换行";
    }
  }
|||;

local key_enter = {
  action: { action: 'enter', label: { text: key_entry_label_code } },
  swipe: {
    up: { shortcutCommand: '#换行', label: null },
  },
  overrides: {
    size: { width: 0.22 },
    // bg: key_enter_bg_code,
  },
};


// defined key
local config_keys = {
  shift: key_shift,
  backspace: key_backspace,
  '123': key_123,
  zhen: key_zhen,
  comma: key_comma,
  space: key_space,
  dot: key_dot,
  enter: key_enter,
};

// build alphabet_key
local btn = btnFactory(system_theme[2]);
local mkKey(elem) =
  local spec = system_key.BuildSpec(elem.value);
  btn.Button('kp_' + elem.key, spec, system_theme[0], std.get(elem.value, 'overrides', {}));


local system_config() =
  local system = std.foldl(
    function(acc, e) acc + mkKey(e),
    std.objectKeysValues(config_keys),
    {}
  );
  system_theme[1] + system;


{
  pinyin()::
    system_config(),

  // alphabetic():: {

  // },
}
