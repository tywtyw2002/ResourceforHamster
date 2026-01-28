local btn = import 'button.libsonnet';

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
      { action: { character: '3' }, labels: { text: 'z' } },
      { action: { symbol: '.' }, labels: { text: '.' }, style: 'xxxxSTYLE' },
    ],
    index: 0,
  },

  hint: {
    fg: { labels: { text: 'z' } },
    up: { labels: { text: '.' }, style: 'xPPxSTYLE' },
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

btn.Button('z', spec, theme, { bounds: { width: '112.5/168.75', alignment: 'right' } })
