local system_key = import '../../funcs/key_system.libsonnet';

local dark_config = import '../../config/theme_dark.jsonnet';
local btnFactory = import '../../funcs/button.libsonnet';
local lib_theme = import '../../funcs/theme.libsonnet';

// mk theme.
local func_theme = lib_theme.mkTheme('Tfuncs', dark_config.func, {});


local key_left = {
  action: { shortcutCommand: '#左移', label: { systemImageName: 'arrowshape.turn.up.left.fill' } },
  repeat: { shortcutCommand: '#左移' },
  preedit: { sendKeys: '[', label: { systemImageName: 'square.filled.and.line.vertical.and.square' } },
  swipe: {
    up: { shortcutCommand: '#行首', label: null },
    down: { character: '[', label: null },
  },
};

local key_atom = {
  action: { shortcutCommand: '#toggleScriptView', label: { systemImageName: 'atom' } },
  preedit: { sendKeys: 'Control+Shift+Up', label: { systemImageName: 'arrowtriangle.up.fill' } },
  // hold: {
  //   actions: [
  //     { openURL: 'https://www.google.com/search?q=#pasteboardContent', label: { systemImageName: 'g.circle.fill' } },
  //     { openURL: '#pasteboardContent', label: { systemImageName: 'safari.fill' } },
  //   ],
  //   select_index: 0,
  // },
};

local key_rime = {
  action: { runTranslateScript: 'Translator', label: { systemImageName: 'bonjour' } },
  preedit: { character: '7', label: { systemImageName: 'arrow.right' } },
};


local key_cut = {
  action: { shortcutCommand: '#剪切', label: { systemImageName: 'scissors' } },
  preedit: { character: '8', label: { systemImageName: 'arrow.up.right' } },
};

local key_copy = {
  action: { shortcutCommand: '#复制', label: { systemImageName: 'arrow.up.doc.on.clipboard' } },
  preedit: { character: '9', label: { systemImageName: 'arrow.uturn.up' } },
};

local key_paste = {
  action: { shortcutCommand: '#粘贴', label: { systemImageName: 'doc.on.clipboard.fill' } },
  preedit: { character: '0', label: { systemImageName: 'arrow.down.right' } },
  hold: {
    actions: [
      { shortcutCommand: '#showPhraseView', label: { systemImageName: 'note.text' } },
      { shortcutCommand: '#showPasteboardView', label: { systemImageName: 'list.bullet.clipboard' } },
    ],
    select_index: 1,
  },
};

local key_select = {
  action: { shortcutCommand: '#selectText', label: { systemImageName: 'square.grid.3x3.fill' } },
  preedit: { sendKeys: 'Control+Shift+Down', label: { systemImageName: 'arrowtriangle.down.fill' } },
  hold: {
    actions: [
      { shortcutCommand: '#撤销', label: { systemImageName: 'arrow.uturn.left.circle.fill' } },
      { shortcutCommand: '#重做', label: { systemImageName: 'arrow.uturn.right.circle.fill' } },
    ],
    select_index: 0,
  },
};

local key_right = {
  action: { shortcutCommand: '#右移', label: { systemImageName: 'arrowshape.turn.up.right.fill' } },
  repeat: { shortcutCommand: '#右移' },
  preedit: { sendKeys: ']', label: { systemImageName: 'square.and.line.vertical.and.square.filled' } },
  swipe: {
    up: { shortcutCommand: '#行尾', label: null },
    down: { character: ']', label: null },
  },
};

// defined key
local config_keys = {
  left: key_left,
  atom: key_atom,
  rime: key_rime,
  cut: key_cut,
  copy: key_copy,
  paste: key_paste,
  select: key_select,
  right: key_right,
};

// build alphabet_key
local btn = btnFactory(func_theme[2]);
local mkKey(elem) =
  local spec = system_key.BuildSpec(elem.value);
  btn.Button('kp_' + elem.key, spec, func_theme[0], std.get(elem.value, 'overrides', {}));

local func_config() =
  local func_keys = std.foldl(
    function(acc, e) acc + mkKey(e),
    std.objectKeysValues(config_keys),
    {}
  );
  func_theme[1] + func_keys;

{
  pinyin()::
    func_config(),
}
