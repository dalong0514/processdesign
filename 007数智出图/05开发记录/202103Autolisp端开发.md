## 01. 锁定特定的图层

20210301

成品代码如下：

```c
; 2021-03-01
(defun c:switchLayerLock(/ acadObj doc lockStatus lockStatusMsg)
  (setq acadObj (vlax-get-acad-object))
  (setq doc (vla-get-ActiveDocument acadObj))
  (mapcar '(lambda (x) 
              ;; Create the new layer
              (setq layerObj (vla-Add (vla-get-Layers doc) x))
              ;; Toggle the status of the Lock property for the layer
              (vla-put-Lock layerObj (if (= (vla-get-Lock layerObj) :vlax-true) :vlax-false :vlax-true)) 
              ;; Display the Lock status of the new layer
              (if (= (vla-get-Lock layerObj) :vlax-true)
                  (setq lockStatus 0)
                  (setq lockStatus 1)
              ) 
           ) 
    '("WALL-MOVE" "WINDOW" "WALL" "COLUMN" "STAIR" "EVTR" "DOOR_FIRE")
  ) 
  (setq lockStatusMsg '("建筑底图锁定" "建筑底图解锁"))
  (alert (nth lockStatus lockStatusMsg))
)

; 2021-03-01
(defun c:lockJSDrawLayer(/ acadObj doc lockStatus lockStatusMsg)
  (setq acadObj (vlax-get-acad-object))
  (setq doc (vla-get-ActiveDocument acadObj))
  (mapcar '(lambda (x) 
              ;; Create the new layer
              (setq layerObj (vla-Add (vla-get-Layers doc) x))
              ;; Display the Lock status of the new layer
              (if (/= (vla-get-Lock layerObj) :vlax-true)
                  ;; Toggle the status of the Lock property for the layer
                  (vla-put-Lock layerObj (if (= (vla-get-Lock layerObj) :vlax-true) :vlax-false :vlax-true)) 
              ) 
           ) 
    '("WALL-MOVE" "WINDOW" "WALL" "COLUMN" "STAIR" "EVTR" "DOOR_FIRE")
  ) 
  (alert "建筑底图锁定")
)

; 2021-03-01
(defun c:unlockJSDrawLayer(/ acadObj doc lockStatus lockStatusMsg)
  (setq acadObj (vlax-get-acad-object))
  (setq doc (vla-get-ActiveDocument acadObj))
  (mapcar '(lambda (x) 
              ;; Create the new layer
              (setq layerObj (vla-Add (vla-get-Layers doc) x))
              ;; Display the Lock status of the new layer
              (if (= (vla-get-Lock layerObj) :vlax-true)
                  ;; Toggle the status of the Lock property for the layer
                  (vla-put-Lock layerObj (if (= (vla-get-Lock layerObj) :vlax-true) :vlax-false :vlax-true)) 
              ) 
           ) 
    '("WALL-MOVE" "WINDOW" "WALL" "COLUMN" "STAIR" "EVTR" "DOOR_FIRE")
  ) 
  (alert "建筑底图解锁")
)
```

参考的官方文档：

[Lock Property (ActiveX)](http://help.autodesk.com/view/OARX/2018/CHS/?guid=GUID-49CA344E-0F8C-4AB2-8336-9E696F8BD5D7)

## 02. 实现了在选择集上直接加载 CAD 自带的命令

20210302

源码如下：

```c
(defun CADLispMove (ss firstPoint secondPoint /)
  (command "_.move" ss firstPoint "" secondPoint "")
)

(defun CADLispCopy (ss firstPoint secondPoint /)
  (command "_.copy" ss firstPoint "" secondPoint "")
)
```

参考资料：

[已解决: lisp to selection set after command - Autodesk Community - AutoCAD](https://forums.autodesk.com/t5/visual-lisp-autolisp-and-general/lisp-to-selection-set-after-command/m-p/8327357#M375363)

书籍「2019116AutoCAD-Platform-Customization0210」里也有相关源码。

## 03. 自动插入外部文件里的块

20210302

[已解决: Insert block from external dwg - Autodesk Community - AutoCAD](https://forums.autodesk.com/t5/visual-lisp-autolisp-and-general/insert-block-from-external-dwg/m-p/8884063#M386988)

[Steal from Drawing | Lee Mac Programming](http://www.lee-mac.com/steal.html)

## 04. 流程图设备数据迁移至设备布置图

20210309

```c
; 2021-03-09
(defun GetAllMarkedDataByTypeUtils (dataType /) 
  (cons dataType 
        (GetBlockAllPropertyDictUtils (GetEntityNameListBySSUtils (GetAllBlockSSByDataTypeUtils dataType)))
  )
)

; 2021-03-09
(defun GetAllMarkedDataListByTypeListUtils (dataTypeList /) 
  (mapcar '(lambda (x) 
             (GetAllMarkedDataByTypeUtils x)
           ) 
    dataTypeList
  )
)

; 2021-03-09
(defun GetAllMarkedEquipDataListByTypeListUtils () 
  (GetAllMarkedDataListByTypeListUtils (GetGsLcEquipTypeList))
)
```

这里有一个反常识的意外收获。`GetAllMarkedDataByTypeUtils` 只是获取到一个点对数据集，那么按理说 `mapcar` 函数对每个设备类型进行映射处理，即使每个设备都形成一个数据集，按以前的理解，返回的结果应该仅仅是一个设备类型的数据集，没想到返回的是所有设备类型数据集的一个列表。意外之喜，否则自己还要用 `append` 函数去拼接多个设备的数据集。走到这里，那么之前迁移建筑底图的代码应该是绕远了，当时用的是 `append` 拼接，其实没必要。有空的时候再去确认一下，然后重构。（2021-03-09）