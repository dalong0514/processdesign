## 01. 开发属性块一键同步命令

2020-12-22

参考资料：

[Synchronize attributes of all blocks at once - Autodesk Community - AutoCAD](https://forums.autodesk.com/t5/autocad-forum/synchronize-attributes-of-all-blocks-at-once/td-p/2179776)

[Match Attributes | Lee Mac Programming](http://lee-mac.com/matchattribs.html)

[Lisp to Sync Attributes - AutoLISP, Visual LISP & DCL - AutoCAD Forums](https://www.cadtutor.net/forum/topic/26787-lisp-to-sync-attributes/)

获得了关键知识：CAD 自带命令 `ATTSYNC`，做一个宏。

## 02. 给排水消防立管自动生成的开发

2021-02-02

给排水消防立管自动生成的开发，关键技术难点在直角坐标转换为极坐标。

[polar (AutoLISP)](http://help.autodesk.com/view/OARX/2018/CHS/?guid=GUID-6A84BFD3-8788-45B1-AB52-5E83F0C5286E)

1、关键思想是把横坐标和纵坐标分开，横坐标保持不变，纵坐标即为「距离」作为函数 polar 的参数。

2、整个系统，最左下角的点必须是 `(0 0 0)`。目前的折中方案是自己拾取平面图里最左下侧的点，然后后台里所有点全部减掉该点的坐标，做一个虚拟的平移。

代码片段：

```c
(defun TranforCoordinateToPolarUtils (insPt /)
  (polar (list (car insPt) 0 0) 0.785398 (cadr insPt))
)
```