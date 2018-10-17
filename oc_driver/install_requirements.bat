

IF EXIST py_virtual_env (
   .\py_virtual_env\Scripts\pip.exe install -r .\requirements.txt
) ELSE (
  virtual_env py_virtual_env
)


