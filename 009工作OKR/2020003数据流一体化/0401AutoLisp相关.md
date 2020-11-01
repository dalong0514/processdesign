# 0401. AutoLisp相关

## 问题记录

### 01

文件名的输入做成了弹窗，自己电脑里跑是没有问题的，但在其他人的电脑上跑就不行，一直找不到原因。（2020-09-14）

Lisp 源码里去掉 `(action_tile "cancel" "(exit)")` 相关代码后，在孙伟昌电脑里可以跑，但在陈李荔电脑里跑不了。

DCL 源码如下：

```c
// DCL code
dataflow :dialog {
  label = "¹¤ÒÕ×¨Òµµ¼³öÊý¾ÝµÄÎÄ¼þÃû";
  :edit_box {
    label = "ÄâÊä³öµÄÎÄ¼þÃû£¨ÎÞÐèÀ©Õ¹Ãû£©£¬Êä³öÎÄ¼þ×Ô¶¯´æ·ÅÔÚ CAD ÎÄ¼þÍ¬Ò»¸öÎÄ¼þ¼ÐÄÚ";
    mnemonic = "N";
    key = "filename";
    alignment = centered;
    edit_limit = 50;
    edit_width = 50;
    value = "";
  }
  :button {
    key = "accept";
    label = "µ¼³öÊý¾Ý";
    is_default = true;
    fixed_width = true;
    alignment = centered;
  }
  cancel_button;
}
```

AutoLisp 源码如下：

```c
; get the current file direction
(defun getFileDir (/ dcl_id fn currentDir)
  (setq dcl_id (load_dialog "dataflow.dcl"))
  (if (not (new_dialog "dataflow" dcl_id))
    (exit)
  )
  (action_tile "cancel" "(exit)")
  (set_tile "filename" "FileName");
  (mode_tile "filename" 2)
  (action_tile "filename" "(setq filename $value)")
  (action_tile "accept" "(done_dialog)")
  (start_dialog)
  (unload_dialog dcl_id)
  (setq fn filename)
  (setq currentDir (getvar "dwgprefix"))
  (setq fn (strcat currentDir fn ".txt"))
)
```