local btnFactory = import '../../funcs/button.libsonnet';
local alphabet_key = import '../../funcs/key_alphabet.libsonnet';
// local system_key = import '../../funcs/key_system.libsonnet';

local dark_config = import '../../config/theme_dark.jsonnet';
local lib_theme = import '../../funcs/theme.libsonnet';

local config_alphabet_26 = import '../../config/alphabet_26.json';

// mk theme.
local alphabet_theme = lib_theme.mkTheme('Talphabet', dark_config.alphabet, {});


// build alphabet_key
local btn = btnFactory(alphabet_theme[2]);
local mkKey(elem) =
  local spec = alphabet_key.BuildSpec(elem.value);
  btn.Button('kp_' + elem.key, spec, alphabet_theme[0], std.get(elem.value, 'overrides', {}));


{
  default()::
    local alphabet = std.foldl(
      function(acc, e) acc + mkKey(e),
      std.objectKeysValues(config_alphabet_26),
      {}
    );
    alphabet_theme[1] + alphabet,
}
