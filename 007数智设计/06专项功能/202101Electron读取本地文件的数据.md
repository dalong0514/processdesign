## 00. 问题记录

1、重复导出文件失败。

2021-04-15

Electron 每次读取文件获得项目信息的时候，window 里该文件应该还是后台打开着的。这就导致了，CAD 那边更新后无法直接重新导出。Electron 代码里有关闭文件的代码，也不知道文件为啥没关闭掉。

```js
    const line = await new Promise((resolve) => {
      readInterface.on('line', (line) => {
        readInterface.close()
        resolve(line)
      })
    })
```

CAD 端更好解决这个问题，每次重新导出数据前先直接把原来的旧文件删除掉即可。

```c
; refactored 2021-04-14
(defun ExportCADBlockDataUtils (fileName dataList / fileDir) 
  (setq fileDir (strcat "D:\\dataflowcad\\tempdata\\" fileName ".txt"))
  ; refactored 2021-04-15 - file is opening because electron read file, delete the file first
  (vl-file-delete fileDir)
  (WriteDataListToFileUtils 
    fileDir 
    (cons (DictListToJsonStringUtils (GetProjectInfoUtils)) dataList)) 
)
```

## 01. 读取文件夹下的所有文件

返回的是一个文件数组。

```js
  getSystemFiles = async () => {
    const dirPath = localStorage.getItem('GLOBAL_CAD_EXPORT_DIR_PATH') || ''
    if (!dirPath) return message.warn('请先设置文件夹路径')
    const files = await SystemSelector.getFilesInDirectoryByType(dirPath)

    let fileList: FileUpload[] = []
    // refactored at 2021-04-12
    if (!files.some(file => file.name === "GsEquipment.txt")) return message.warn('请先导出 CAD 数据')
    const buffer = await fs.readFile(path.join(dirPath, "GsEquipment.txt"))
    fileList.push({
      file: buffer,
      fileName: "GsEquipment.txt"
    })
    return fileList
  }
```

## 02. 读取整个文件的数据

[Reading files with Node.js](https://nodejs.dev/learn/reading-files-with-nodejs)

```js
    fs.readFile('/Users/Daglas/Downloads/testData/KsInstallMaterial.txt', 'utf8' , (err, data) => {
      if (err) {
        console.error(err)
        return
      }
      console.log(data)
    })
```

## 03. 逐行读取文件的数据

[Reading a File Line by Line in Node.js](https://stackabuse.com/reading-a-file-line-by-line-in-node-js/)

```js
    const readline = require('readline')
    const readInterface = readline.createInterface({
        input: fs.createReadStream('/Users/Daglas/Downloads/testData/KsInstallMaterial.txt'),
        output: process.stdout,
        console: false
    })
    readInterface.on('line', function(line) {
        console.log(line)
    })
```

上面的代码是逐行打印，次方法可以获取到一个所有行的数组对象。但如果只需要第一行的数据，先获取所有行的数据没必要。去找只读第一行的数据实现。

这个 Stack Overflow 帖子里获取了方法：[javascript - What is the most efficient way to read only the first line of a file in Node JS? - Stack Overflow](https://stackoverflow.com/questions/28747719/what-is-the-most-efficient-way-to-read-only-the-first-line-of-a-file-in-node-js)

[Readline | Node.js v15.14.0 Documentation](https://nodejs.org/api/readline.html#readline_event_line)

There's a built-in module almost for this case - readline. It avoids messing with chunks and so forth. The code would look like the following:

```js
    const line = await new Promise((resolve) => {
      readInterface.on('line', (line) => {
        readInterface.close()
        resolve(line)
      })
    })
```

这里涉及到承诺函数，`resolve` 的用法在忍者秘籍里看到过，相当于中断，上面的用法如果吃透用处很大。（2021-04-13）

读出来的首行数据是字符串，但因为是 CAD 导出来的，window 那边自动 BOM，其实字符串前面还有些什么字符，要剔除掉。实现方法是定位到 json 格式对应的 `{`，提取出 json 的字符串。

完成的代码：

```js
  getProjectInfo = async () => {
    const globalDirPath = this.getGlobalDirPath()

    const readline = require('readline')
    const readInterface = readline.createInterface({
        input: fs.createReadStream('/Users/Daglas/Downloads/testData/KsInstallMaterial.txt'),
        output: process.stdout,
        console: false
    })

    const line = await new Promise((resolve) => {
      readInterface.on('line', (line) => {
        readInterface.close()
        resolve(line)
      })
    })
    // do not know why line is not String
    const projectInfoStirng = String(line)    
    const projectInfo =  JSON.parse(
      projectInfoStirng.substring(projectInfoStirng.indexOf('{'))
    )
    console.log(projectInfo)

    this.projectNum = projectInfo.class
    this.monomerNum = projectInfo.material
  }
```