## 01. 直接调用 CAD 原生命令的方法

2022-02-20

目前总结下来有两类，一类是不需要人机交互，直接把命令需要的参数全部传进去。

```
(defun CADLispCopyUtils (ss firstPoint secondPoint /)
  (CADLispCopyByOffsetUtils ss '(0 0 0) (GetTwoInsPtOffsetUtils secondPoint firstPoint))
)

; 2021-03-02
(defun CADLispCopyByOffsetUtils (ss firstPoint secondPoint /)
  (command "_.copy" ss firstPoint "" secondPoint "")
)
```

另一类需要人机交互，最简单的办法，其实只需把选择集传进去，后面再跟一个空字符串的参数。比如：

```
; 2022-02-20
(defun GsToBsEngineerGraphCopyMacro ()
  (prompt "\n批量选择要复制的非标条件蓝色图框：")
  (command "_.copy" (GetGsToBsEngineerGraphSS) "")
)
```