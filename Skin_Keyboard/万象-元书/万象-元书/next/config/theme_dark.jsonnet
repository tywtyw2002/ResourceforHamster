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
    size: { width: {percentage: 0.12 } },
    hold_insets: self.const.insets,
    hint_insets: self.const.insets,
  },

  bg: {
    insets: self.const.insets,
    cornerRadius: self.const.cornerRadius,
    normalColor: "BBBBBB66",
    highlightColor: "BBBBBB66",
    normalLowerEdgeColor: "00000099",
    highlightLowerEdgeColor: "00000099",
    borderSize: 0.2,
    normalBorderColor: "FFFFFF1A",
    highlightBorderColor: "FFFFFF1A",
  },

  fg: {
    normalColor: "ffffff",
    highlightColor: "ffffff",
    fontSize: "1.25em",
    center: {x: 0.5, y:0.85}
  },

  caps_fg: self.fg,
  upper_fg: self.fg,

  swipe_up_fg: {
    normalColor: "E5E5EA",
    highlightColor: "E5E5EA",
    fontSize: "0.625em",
    center: {x: 0.25, y:0.65}
  },

  swipe_down_fg: self.up + {
    center: {x: 0.75, y:0.65}
  },

  hint_fg: {
    fontSize: "1.5em",
    normalColor: "E5E5EA",
    center: { y:0.55}
  },

  hint_bg: {
    normalColor: "707070",
    borderColor: "6E6E6E",
    borderSize: 1
  },

  hold_fg: {
    fontSize: "1.5em",
    normalColor: "E5E5EA",
    center: { y:0.55}
  },

  hold_bg: {
    normalColor: "707070",
    borderColor: "6E6E6E",
    borderSize: 1
  },

  hold_select_bg: {
    normalColor: "0279FE",
    cornerRadius: self.const.cornerRadius,
  },
};
