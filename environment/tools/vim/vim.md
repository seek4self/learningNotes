# vim

## 常用命令

- 清空文件内容
  - gg 光标跳至第一行
  - dG 删除从光标到最后一行
- 跳到文件结尾
  - G 光标跳至最后一行
- 查看行号
  - ：set number 显示行号
  - ：set nonumber 不显示行号

## 打开多个文件

1. 如果没有打开vim
   - 横向分割显示：  
    `$ vim -o filename1 filename2`
   - 纵向分割显示：  
    `$ vim -O filename1 filename2`
2. 如果已经打开vim
   - 横向分割显示：  
    `:vs filename`
   - 纵向分割显示：  
    `:sp filename`
   - 其中，vs可以用vsplit替换，sp可以用split替换。
3. 切换窗口  
   打开了多个窗口，需要在窗口之间切换时：
   `ctrl + w w`
   即按住ctrl键，再按两下w键。
   或者 `ctrl + w <h|j|k|l>`
   即按住ctrl键，按一次w键，再按一次表示方向的h或j或k或l，则光标会切换到当前窗口的 左｜下｜上｜右 侧的窗口
