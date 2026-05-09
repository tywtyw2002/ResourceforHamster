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
    // local rawLabel = std.get(obj, 'label', actionValue);
    // local label = if std.isString(rawLabel) then { text: rawLabel } else rawLabel;
    local hasLabel = std.objectHas(obj, 'label');
    local rawLabel = if hasLabel then obj.label else (
      if std.isString(actionValue) && std.length(actionValue) > 1 then null else actionValue
    );
    local label = if rawLabel == null then null else (if std.isString(rawLabel) then { text: rawLabel } else rawLabel);


    // process system action.
    local actionDC = if actionKey == 'action' then actionValue else { [actionKey]: actionValue };

    // 4. 构造输出对象
    {
      action: actionDC,
      label: label,
      // 如果有 style 字段则包含
      [if std.objectHas(obj, 'style') then 'style']: obj.style,
    },

  mkLayout(prefix, conf)::
    // 子函数 1: 生成 Cell 对象
    local mkCell(name) = { Cell: prefix + '_' + name };

    // 子函数 2: 生成一个标准的 HStack 行 (用于 views 模式下的嵌套)
    local mkRow(cellNames) = {
      HStack: {
        subviews: [mkCell(c) for c in cellNames],
      },
    };

    // 子函数 3: 处理配置中的每一个 item
    local processItem(item) =
      // 1. 归一化输入：将数组转换为对象格式
      local normalized = if std.isArray(item) then { cells: item } else item;

      // 2. 提取可选的 style 字段
      local styleObj = if std.objectHas(normalized, 'style') then { style: normalized.style } else {};

      // 3. 根据 cells 或 views 生成 subviews
      local subviews =
        if std.objectHas(normalized, 'cells') then
          [mkCell(c) for c in normalized.cells]
        else if std.objectHas(normalized, 'views') then
          [mkRow(row) for row in normalized.views]
        else [];

      // 4. 组装结果
      {
        HStack: styleObj { subviews: subviews },
      };

    { keyboardLayout: [processItem(i) for i in conf] },

  //END
}
