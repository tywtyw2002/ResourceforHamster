local lib_theme = import '../funcs/theme.libsonnet';
local utils = import '../funcs/utils.libsonnet';

// mk theme.
local dark_config = import '../config/theme_dark.jsonnet';
local tb_theme = lib_theme.mkThemeTb('Tkeyboard', dark_config.keyboard, {});

local k_alphabetic = import './config/pinyin26_alphabetic.jsonnet';
local k_func = import './config/pinyin26_func.jsonnet';
local k_system = import './config/pinyin26_system.jsonnet';
local k_toolbar = import './config/pinyin26_toolbar.jsonnet';


// hard code for layout.
local layout = [
  { style: tb_theme[0].row_style, cells: ['left', 'atom', 'rime', 'cut', 'copy', 'paste', 'select', 'right'] },
  { style: tb_theme[0].keyboard_style, views: [
    ['q', 'w', 'e', 'r', 't', 'y', 'u', 'i', 'o', 'p'],
    ['a', 's', 'd', 'f', 'g', 'h', 'j', 'k', 'l'],
    ['shift', 'z', 'x', 'c', 'v', 'b', 'n', 'm', 'backspace'],
    ['123', 'zhen', 'comma', 'space', 'dot', 'enter'],
  ] },
];

local keyboard_extra = {
  preeditHeight: 15,  // 25
  toolbarHeight: 42,  // 35
  keyboardHeight: '28vh',  // 216
  preedit: tb_theme[1][tb_theme[0].preedit],
};

local keyboard_layout = utils.mkLayout('key', layout);

local _all = [
  keyboard_layout,
  keyboard_extra,
  tb_theme[1],  // keyboard styles.
  k_alphabetic.default(),
  k_func.default(),
  // k_system.pinyin(),
  k_toolbar.default(),
];

local mkOut(x) = std.foldl(
  function(acc, e) acc + e,
  _all + x,
  {}
);

{
  pinyin_26_portrait: mkOut(k_system.pinyin()),
  alphabetic_26_portrait: mkOut(k_system.alphabetic()),
}
