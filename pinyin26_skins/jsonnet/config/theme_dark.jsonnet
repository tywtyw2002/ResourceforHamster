// fix variables
// local theme_bg_failback = {
//   insets: { top: 5, left: 3, bottom: 5, right: 3 },
//   normalColor: "707070",
//   highlightColor: "4C4C4C",
//   cornerRadius: 7,
//   borderSize: 0.2,
//   normalBorderColor: "FFFFFF1A",
//   highlightBorderColor: "FFFFFF1A",
//   normalLowerEdgeColor: "1E1E1E",
//   highlightLowerEdgeColor: "1D1D1D",
//   // normalShadowColor: "",
//   // highlightShadowColor: "",
//   // shadowRadius: "",
//   // shadowOffset: "",
//   // animation: "",
// };

// local theme_fg_failback = {
//   normalColor: "ffffff",
//   highlightColor: "ffffff",
//   fontSize: "1.25em",
//   // fontWeight: "regular",
//   // center: {}
// };

local helper = import '../funcs/helper.libsonnet';

// alphabet color
local theme_config_alphabet = {
  // 只要不是bg 都是要注入的，
  // bg 带有 type: original

  // shared
  const: {
    insets: { top: 5, left: 3, bottom: 5, right: 3 },
    cornerRadius: 7,
  },

  mixin: {
    size: { width: { percentage: 0.12 } },
    hold_insets: { top: 3, bottom: 3, left: 8, right: 8 },
    hint_insets: $.const.insets,
  },

  bg: {
    insets: $.const.insets,
    cornerRadius: $.const.cornerRadius,
    normalColor: 'BBBBBB66',
    highlightColor: 'BBBBBB66',
    normalLowerEdgeColor: '00000099',
    highlightLowerEdgeColor: '00000099',
    borderSize: 0.2,
    normalBorderColor: 'FFFFFF1A',
    highlightBorderColor: 'FFFFFF1A',
  },

  fg: {
    normalColor: 'ffffff',
    highlightColor: 'ffffff',
    fontSize: '1.25em',
    center: { x: 0.5, y: 0.85 },
  },

  caps_fg: self.fg,
  upper_fg: self.fg,

  swipe_up_fg: {
    normalColor: 'E5E5EA',
    highlightColor: 'E5E5EA',
    fontSize: '0.625em',
    center: { x: 0.25, y: 0.65 },
  },

  swipe_down_fg: self.swipe_up_fg {
    center: { x: 0.75, y: 0.65 },
  },

  hint_fg: {
    fontSize: '1.5em',
    normalColor: 'E5E5EA',
    center: { y: 0.55 },
  },

  hint_bg: {
    normalColor: '707070',
    borderColor: '6E6E6E',
    borderSize: 1,
  },

  hold_fg: {
    fontSize: '1.5em',
    normalColor: 'E5E5EA',
    center: { y: 0.55 },
  },

  hold_bg: {
    normalColor: '707070',
    borderColor: '6E6E6E',
    borderSize: 1,
  },

  hold_select_bg: {
    normalColor: '0279FE',
    cornerRadius: $.const.cornerRadius,
  },
};


local theme_config_system = {
  mixin: {
    size: { width: { percentage: 0.1 } },
    hold_insets: { top: 3, bottom: 3, left: 8, right: 8 },
  },

  bg: {
    insets: { top: 6, left: 3, bottom: 6, right: 3 },
    cornerRadius: 5,
    normalColor: '474747',
    highlightColor: '707070',
    normalLowerEdgeColor: '1D1D1D',
    highlightLowerEdgeColor: '1E1E1E',
    borderSize: 0.2,
    normalBorderColor: 'FFFFFF1A',
    highlightBorderColor: 'FFFFFF1A',
  },

  blue_bg: $.bg {
    normalColor: '0279FE',
    normalLowerEdgeColor: '191716',
  },

  fg: {
    normalColor: 'ffffff',
    highlightColor: 'ffffff',
    fontSize: 16,
    center: { y: 0.8 },
  },
} + helper.pick(theme_config_alphabet, [
  'hold_bg',
  'hold_select_bg',
  'hold_fg',
]);


local theme_config_func = {
  mixin: {
    size: { width: { percentage: 0.125 } },
    hold_insets: { top: 3, bottom: 3, left: 8, right: 8 },
  },
  fg: {
    normalColor: 'ffffff',
    highlightColor: 'ffffff',
    fontSize: '1.125em',
    center: { x: 0.5, y: 0.5 },
  },
} + helper.pick(theme_config_alphabet, [
  'bg',
  'hold_bg',
  'hold_select_bg',
  'hold_fg',
]);

local theme_config_toolbar = {
  fg: {
    normalColor: 'E5E5EA',
    highlightColor: 'E5E5EA',
    fontSize: '1.125em',
    // center: { x: 0.5, y: 0.5 },
  },
  bg: {
    normalColor: '00000000',
    highlightColor: '00000000',
  },

  root_bg: {
    type: 'original',
    normalColor: '2C2C2C03',
  },
  // horizontalCandidateStyle
  h_bg: {
    _kmap: { candidateStateButtonStyle: 'h_state' },
    insets: { left: 3, bottom: 1, top: 3 },
    highlightBackgroundColor: '00000033',
    preferredBackgroundColor: '00000033',
    preferredIndexColor: 'ffffff',
    preferredTextColor: 'ffffff',
    preferredCommentColor: 'ffffff',
    indexColor: 'ffffff',
    textColor: 'ffffff',
    commentColor: 'ffffff',
    indexFontSize: 10,
    //  indexFontWeight: regular
    textFontSize: 18,
    //  textFontWeight: regular
    commentFontSize: 10,
  },
  h_state: {
    _kmap: { backgroundStyle: 'bg', foregroundStyle: 'h_state_fg' },
  },
  h_state_fg: $.fg {
    systemImageName: 'chevron.down',
  },
  // verticalCandidateStyle
  v_bg: {
    _kmap: {
      backgroundStyle: 'root_bg',
      candidateStyle: 'vc_fg',
      pageUpButtonStyle: 'vc_p_up',
      pageDownButtonStyle: 'vc_p_down',
      returnButtonStyle: 'vc_p_return',
      backspaceButtonStyle: 'vc_p_bs',
    },
    insets: { top: 3, bottom: 3, left: 4, right: 4 },
    bottomRowHeight: 50,
  },
  vc_fg: {
    insets: { top: 8, bottom: 8, left: 8, right: 8 },
    backgroundColor: 'ffffff00',
    separatorColor: '383838',
    highlightBackgroundColor: '00000000',
    preferredBackgroundColor: '00000000',
    preferredIndexColor: '1a73e9',
    preferredTextColor: '1a73e9',
    preferredCommentColor: '1a73e9',
    indexColor: 'ffffff',
    textColor: 'ffffff',
    commentColor: 'ffffff',
    indexFontSize: 8,
    //  indexFontWeight: regular
    textFontSize: 18,
    //  textFontWeight: regular
    commentFontSize: 8,
    //  commentFontWeight: regular
  },
  vc_p_bg: theme_config_alphabet.bg,
  vc_p_up: {
    _kmap: { backgroundStyle: 'vc_p_bg', foregroundStyle: 'vc_p_up_fg' },
  },
  // vc_p_up_fg,
  vc_p_up_fg: $.fg {
    systemImageName: 'chevron.up',
    fontSize: '1em',
  },

  vc_p_down: {
    _kmap: { backgroundStyle: 'vc_p_bg', foregroundStyle: 'vc_p_down_fg' },
  },
  vc_p_down_fg: $.fg {
    systemImageName: 'chevron.down',
    fontSize: '1em',
  },

  vc_p_return: {
    _kmap: { backgroundStyle: 'vc_p_bg', foregroundStyle: 'vc_p_return_fg' },
  },
  vc_p_return_fg: $.fg {
    systemImageName: 'return',
    fontSize: '1em',
  },

  vc_p_bs: {
    _kmap: { backgroundStyle: 'vc_p_bg', foregroundStyle: 'vc_p_bs_fg' },
  },
  vc_p_bs_fg: $.fg {
    systemImageName: 'delete.left',
    fontSize: '1em',
  },
  // candidateContextMenuStyle
};

{
  alphabet: theme_config_alphabet,
  system: theme_config_system,
  func: theme_config_func,
  toolbar: theme_config_toolbar,
}
