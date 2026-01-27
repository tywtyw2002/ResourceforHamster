{

  mkAction(inputR)::
    local input = if std.isNumber(inputR) then std.toString(inputR) else inputR;
    if input != null && std.length(input) > 0 then self._mkActionRaw(input) else {},

  _mkActionRaw(input)::
    // 1. 统一输入：如果是字符串，转为带默认 key 的对象
    local obj = if std.isString(input) then { character: input } else input;

    // 2. 提取业务 key (排除 label 和 style)
    local fields = std.objectFields(obj);
    local actionKeys = std.filter(function(k) k != 'label' && k != 'style', fields);
    local actionKey = if std.length(actionKeys) > 0 then actionKeys[0] else 'character';
    local actionValue = obj[actionKey];

    // 3. 处理 label 逻辑：优先取 label 字段，没有则取 actionValue
    local rawLabel = std.get(obj, 'label', actionValue);
    local label = if std.isString(rawLabel) then { text: rawLabel } else rawLabel;

    // process system action.
    local actionDC = if actionKey == 'action' then actionValue else { [actionKey]: actionValue };

    // 4. 构造输出对象
    {
      action: actionDC,
      label: label,
      // 如果有 style 字段则包含
      [if std.objectHas(obj, 'style') then 'style']: obj.style,
    },

}
