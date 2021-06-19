## 01. 对齐标注和旋转标注

2021-06-16

大收获。

1、标准的类型。

之前对标注的概念是不清晰的，工程图只会那种「斜」标注，比如水平标准，两个端点必须在水平方向上，标注出来的才是水平的。对应于 CAD 命令里的「对其标准」（Dimaligened）。自己一直想要那种不管两端点是否水品，标出来的都是水平的那种。对应于 CAD 命令里的「线性标准」（Dimalinear）。

今天无意中用函数「VlaGetEntityPropertyAndMethodBySelectUtils」看到了线性标注其本质是旋转标注「AcDbRotatedDimension」。那么沿用之前「AcDbAlignedDimension」实现逻辑，在结合官方文档，实现了绝对水平标注。

[帮助 | AddDimRotated Method (ActiveX) | Autodesk](https://help.autodesk.com/view/OARX/2018/CHS/?guid=GUID-FE41C4DC-4717-41AC-9C07-6531CB9332E2)

2、标准全局比例。

标注是可以设置全局比例的，那么正好把工程图方框的缩放比例作为标准的全局比例，标准文字就固定设置为 3。

```c
; AcDbAlignedDimension
; AcDbRotatedDimension
; 2021-04-19
(defun InsertAlignedDimensionUtils (scaleFactor firstInsPt secondInsPt textInsPt layerName dimensionStyleName textOverrideContent textHeight / 
                                    acadObj curDoc first3DInsPt second3DInsPt text3DInsPt modelSpace dimObj)
  (setq acadObj (vlax-get-acad-object))
  (setq curDoc (vla-get-activedocument acadObj)) 
  (setq first3DInsPt (vlax-3d-point firstInsPt) 
        second3DInsPt (vlax-3d-point secondInsPt)
        text3DInsPt (vlax-3d-point textInsPt)
  )
  (setq modelSpace (vla-get-ModelSpace curDoc))
  ;; Create an aligned dimension object in model space
  (setq dimObj (vla-AddDimAligned modelSpace first3DInsPt second3DInsPt text3DInsPt))
  (vlax-put-property dimObj 'Layer layerName)
  (vlax-put-property dimObj 'StyleName dimensionStyleName)
  (vlax-put-property dimObj 'TextOverride textOverrideContent)
  (vlax-put-property dimObj 'TextHeight textHeight)
  ; scaleFactor must put the last, do not know why 2021-06-16
  (vlax-put-property dimObj 'ScaleFactor scaleFactor)
  ; (VlaGetObjectPropertyAndMethodUtils dimObj)
  ; (VlaGetEntityPropertyAndMethodBySelectUtils)
)

; 2021-06-16
(defun InsertRotatedDimensionUtils (scaleFactor dimensioRotate firstInsPt secondInsPt textInsPt layerName dimensionStyleName textOverrideContent textHeight / 
                                    acadObj curDoc first3DInsPt second3DInsPt text3DInsPt modelSpace dimObj)
  (setq acadObj (vlax-get-acad-object))
  (setq curDoc (vla-get-activedocument acadObj)) 
  (setq first3DInsPt (vlax-3d-point firstInsPt) 
        second3DInsPt (vlax-3d-point secondInsPt)
        text3DInsPt (vlax-3d-point textInsPt)
  )
  (setq modelSpace (vla-get-ModelSpace curDoc))
  ;; Create an aligned dimension object in model space
  (setq dimObj (vla-AddDimRotated modelSpace first3DInsPt second3DInsPt text3DInsPt dimensioRotate))
  (vlax-put-property dimObj 'ScaleFactor scaleFactor)
  (vlax-put-property dimObj 'Layer layerName)
  (vlax-put-property dimObj 'StyleName dimensionStyleName)
  (vlax-put-property dimObj 'TextOverride textOverrideContent)
  (vlax-put-property dimObj 'TextHeight textHeight)
  ; scaleFactor must put the last, do not know why 2021-06-16
  (vlax-put-property dimObj 'ScaleFactor scaleFactor)
  ; (VlaGetObjectPropertyAndMethodUtils dimObj)
)

; 2021-06-16
(defun InsertHorizontalRotatedDimensionUtils (scaleFactor firstInsPt secondInsPt textInsPt layerName dimensionStyleName textOverrideContent textHeight /)
  (InsertRotatedDimensionUtils scaleFactor 0 firstInsPt secondInsPt textInsPt layerName dimensionStyleName textOverrideContent textHeight)
)

; 2021-06-16
(defun InsertVerticalRotatedDimensionUtils (scaleFactor firstInsPt secondInsPt textInsPt layerName dimensionStyleName textOverrideContent textHeight /)
  (InsertRotatedDimensionUtils scaleFactor (* PI 0.5) firstInsPt secondInsPt textInsPt layerName dimensionStyleName textOverrideContent textHeight)
)
```

工程图使用处的代码：

```c
; 2021-04-19
; refactored at 2021-06-16
(defun InsertBsGCTAlignedDimension (firstInsPt secondInsPt textInsPt textOverrideContent /)
  (InsertAlignedDimensionUtils 5 firstInsPt secondInsPt textInsPt "0DataFlow-BsDimension" "DataFlow-BsGCT" textOverrideContent 3)
)

; 2021-06-16
(defun InsertBsGCTHorizontalRotatedDimension (scaleFactor firstInsPt secondInsPt textInsPt textOverrideContent /)
  (InsertHorizontalRotatedDimensionUtils scaleFactor firstInsPt secondInsPt textInsPt "0DataFlow-BsDimension" "DataFlow-BsGCT" textOverrideContent 3)
)

; 2021-06-16
(defun InsertBsGCTVerticalRotatedDimension (scaleFactor firstInsPt secondInsPt textInsPt textOverrideContent /)
  (InsertVerticalRotatedDimensionUtils scaleFactor firstInsPt secondInsPt textInsPt "0DataFlow-BsDimension" "DataFlow-BsGCT" textOverrideContent 3)
)
```