local btnFactory = import 'button.libsonnet';
local key = import 'key_alphabet.libsonnet';

local dark = import '../config/theme_dark.jsonnet';
local t = import 'theme.libsonnet';

local data = import '../config/alphabet_26.json';

local test_key = {
  action: 'q',
  // repeat: '.',
  // preedit: '1',
  // caps: 'Z',

  swipe: {
    up: 1,
    down: '~',
  },

  hold: {
    actions: [
      'Q',
      'q',
      {
        symbol: '➊',
      },
    ],
    select_index: 0,
  },
};

local spec = {
  actions: {
    action: { character: 'z' },
    caps: { character: 'Z' },

    // repeat:  {character: "."},
    // preedit: {character : "1"},

    swipe_up: { character: '3' },
    swipe_down: { character: '#' },
  },

  labels: {
    main: { fg: { text: 'z' }, caps: { text: 'Z' }, upper: { text: 'Z' } },
    swipe_up: { fg: { text: '3' } },
    swipe_down: { fg: { text: '#' } },
  },

  hold: {
    actions: [
      { action: { character: '3' }, label: { text: 'z' } },
      { action: { symbol: '.' }, label: { text: '.' }, style: 'xxxxSTYLE' },
    ],
    index: 0,
  },

  hint: {
    fg: { label: { text: 'z' } },
    up: { label: { text: '.' }, style: 'xPPxSTYLE' },  // no style anymore.
  },
};


local theme = {
  size: { width: '168.75/1125' },

  bg: 'defaultBG',
  fg: 'defaultFG',

  caps: 'defaultFG_Caps',
  upper: 'defaultFG_Caps',

  fg_swipe_up: 'defaultFG_swipe_up',
  fg_swipe_down: 'defaultFG_swipe_up',

  hold_bg: 'holdBG',
  hold_select: 'holdSelectFG',
  hold_fg: 'holdFG',
  hold_insets: {},

  hint_bg: 'hintBG',
  hint_fg: 'hintFG',
  hint_insets: {},

};

// btn.Button('z', spec, theme, { bounds: { width: '112.5/168.75', alignment: 'right' }, hold_insets: { top: 6, bottom: 6, left: 8, right: 8 } })


// local x = key.BuildSpec(test_key);
// local nt = t.mkTheme('alphabet', dark.alphabet, {});
// btn.Button('z', x, nt[0])


local nt = t.mkTheme('alphabet', dark.alphabet, {});
local btn = btnFactory(nt[2]);
local mkKey(elem) =
  local spec = key.BuildSpec(elem.value);
  btn.Button('kp_' + elem.key, spec, nt[0], std.get(elem.value, 'overrides', {}));

local alphabet = std.foldl(
  function(acc, e) acc + mkKey(e),
  std.objectKeysValues(data),
  {}
);

nt[1] + alphabet
