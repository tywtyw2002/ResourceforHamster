{
  pick(source, fields)::
    {
      [k]: source[k]
      for k in fields
      if std.objectHas(source, k)
    },
}
