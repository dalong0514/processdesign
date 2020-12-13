// DCL code
dataflow :dialog {
  label = "工艺专业导出数据的文件名";
  :edit_box {
    label = "拟输出的文件名（无需扩展名），输出文件自动存放在 CAD 文件同一个文件夹内";
    mnemonic = "N";
    key = "filename";
    alignment = centered;
    edit_limit = 50;
    edit_width = 50;
    value = "";
  }
  :button {
    key = "accept";
    label = "导出数据";
    is_default = true;
    fixed_width = true;
    alignment = centered;
  }
  cancel_button;
}
