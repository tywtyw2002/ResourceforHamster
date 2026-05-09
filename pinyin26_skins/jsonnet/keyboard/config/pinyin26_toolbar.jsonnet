local dark_config = import '../../config/theme_dark.jsonnet';
local lib_theme = import '../../funcs/theme.libsonnet';

// mk theme.
local tb_theme = lib_theme.mkThemeTb('Ttoolbar', dark_config.toolbar, {});


local tb_keyboard_dismiss = {
  action: 'dismissKeyboard',
  label: { systemImageName: 'keyboard.chevron.compact.down.fill' },
};

local tb_float_setting = {
  action: { floatKeyboardType: 'float_panel' },
  label: { systemImageName: 'gearshape.fill' },
};

local tb_script = {
  action: { shortcutCommand: '#toggleScriptView' },
  label: { systemImageName: 'atom' },
};

local tb_clipboard = {
  action: { shortcutCommand: '#showPasteboardView' },
  label: { systemImageName: 'list.bullet.clipboard' },
};

local tb_phase = {
  action: { shortcutCommand: '#showPhraseView' },
  label: { systemImageName: 'note.text' },
};

// defined key
local config_keys = {
  dismiss: tb_keyboard_dismiss,
  setting: tb_float_setting,
  // script: tb_script,
  clipboard: tb_clipboard,
  phase: tb_phase,
};

// build alphabet_key
// local btn = btnFactory(tb_theme[2]);
local mkTbName(e) = 'tb_' + e;
local mkTbKey(elem) =
  local key_name = mkTbName(elem.key);
  local key_fg = key_name + 'FG';
  {
    [key_name]: {
      action: elem.value.action,
      backgroundStyle: tb_theme[0].bg,
      foregroundStyle: key_fg,
    },
    [key_fg]:
      elem.value.label + tb_theme[1][tb_theme[0].fg],
  };

local tb_layout = {
  backgroundStyle: tb_theme[0].root_bg,
  // primaryButtonStyle:,
  secondaryButtonStyle: [mkTbName(x) for x in ['dismiss', 'setting', 'clipboard', 'phase']],
  horizontalCandidateStyle: tb_theme[0].h_bg,
  verticalCandidateStyle: tb_theme[0].v_bg,
  // candidateContextMenu
};

local tb_config() =
  local tb_keys = std.foldl(
    function(acc, e) acc + mkTbKey(e),
    std.objectKeysValues(config_keys),
    {}
  );
  tb_theme[1] + tb_keys + { toolbar: tb_layout };

{
  default()::
    tb_config(),
}
