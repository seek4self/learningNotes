# SSR

## 安装

```sh
apt-get -y update && sudo apt-get -y install python-pip python-setuptools m2crypto shadowsocks
```

## 后台启动

```sh
nohup ssserver -s 0.0.0.0 -p 8000 -k "password"  -t 600 -m aes-256-cfb >~/log 2>&1 &
```

<h1 class="article-title"><a href="https://ssr.tools/780">SS/SSR服务器IP被墙 TCP阻断解决方案汇总</a></h1>
<p>服务器被墙分为几个级别，其中TCP阻断是目前较为主流的封锁方式。如何检测VPS是否被TCP阻断，可以<a href="https://ssr.tools/772" target="_blank" rel="noopener">点此查看</a>。</p>
<p><span style="color: #ff0000;">TCP阻断的表现形式：</span></p>
<ul>
<li>可以正常ping通（ICMP协议正常）。</li>
<li>不能正常SSH连接，换端口也不行。</li>
<li>不能正常使用SS/SSR服务，换端口也不行。</li>
<li>不能打开服务器上架设的网站。</li>
<li>在国外连接以上各项服务，一切正常。</li>

<h3>解决TCP阻断的思路</h3>
<p>在TCP阻断的封禁模式下，国外服务器上的所有TCP流量，都无法在国内正常连接。而SSH、HTTP流量、SS/SSR流量，走的恰好就是TCP流量。</p>
<p>在TCP流量被阻断的同时，其它协议，比如ICMP、UDP等流量，是可以正常连接的。</p>
<p>根据以上情况，我们可以将服务器上的Shadowsocks/ShadowsocksR使用的TCP流量，在服务器内部转化为UDP流量发出来。经过这样转化后，就可以正常在国内连接了。</p>
<p>&nbsp;</p>
<h3>解决TCP阻断的两种方法</h3>
<p>根据以上思路，下面我们提供两种具体方案：</p>
<h4>方案一：在VPS服务器上安装KCPTUN</h4>
<p>KCPTUN是一款服务器网络加速工具，加速效果极为明显，开发本意并不是用来解决IP被墙、服务器被TCP阻断的。</p>
<p>但是KCPTUN的一大特点，就是将服务器某个端口的TCP流量，转变为KCPTUN协议的UDP流量发出，所以正好可以用来解决TCP阻断问题。</p>
<p>KCPTUN的运行，需要分别使用服务器端和客户端，连接成功后，就可以突破TCP阻断，顺便享受网络加速效果。</p>
<p><span style="color: #ff0000;">KCPTUN服务器端一键安装：</span></p>
<p><a href="https://ssr.tools/588" target="_blank" rel="noopener">超级加速工具KCPTUN一键安装脚本 附100倍加速效果图</a></p>
<p>提示：KCPTUN在服务器上安装比较简单，并且不挑架构（OVZ/KVM），不挑系统（CentOS/Debian/Ubuntu）。</p>
<p>&nbsp;</p>
<p><span style="color: #ff0000;">KCPTUN各平台客户端下载：</span></p>
<p><a href="https://ssr.tools/637" target="_blank" rel="noopener">KCPTUN各平台客户端下载汇总 附KCPTUN搭建流程</a></p>
<p>&nbsp;</p>
<h4>方案二：在服务器上安装V2ray科学上网</h4>
<p>V2ray是科学上网领域的后起之秀，自带mkcp加速，可以选择流量以TCP协议发出，或是UDP协议发出。</p>
<p>由于以上特点，我们将V2ray设置为使用UDP流量，就可以解决服务器TCP阻断问题。</p>
<p><span style="color: #ff0000;">V2ray服务器端一键安装：</span></p>
<p><a href="https://ssr.tools/269" target="_blank" rel="noopener">V2Ray一键安装脚本 自带图形化界面控制面板</a></p>
<p>提示：在部分服务器系统版本中，可能会安装不成功，建议在纯净系统安装。</p>
<p>&nbsp;</p>
<p><span style="color: #ff0000;">V2ray各平台客户端下载：</span></p>
<p><a href="https://ssr.tools/314" target="_blank" rel="noopener">V2Ray各平台客户端下载汇总 带图形化界面！</a></p>
<p>&nbsp;</p>
<p><span style="color: #ff0000;">如何将V2ray流量以UDP协议发出：</span></p>
<p>以V2ray Windows客户端为例，将V2ray服务器连接参数中的如下两项：</p>
<ul>
<li>传输协议：选择kcp</li>
<li>伪装类型：任选其一</li>
</ul>
<p><img class="alignnone size-full wp-image-781" src="https://ssr.tools/wp-content/uploads/2018-12-25_152829.jpg" alt="" width="500" height="131" srcset="https://ssr.tools/wp-content/uploads/2018-12-25_152829.jpg 500w, https://ssr.tools/wp-content/uploads/2018-12-25_152829-300x79.jpg 300w" sizes="(max-width: 500px) 100vw, 500px" /></p>
<p>&nbsp;</p>
<p>以上为V2ray客户端设置，服务端也有传输协议设置，不要选择默认的TCP，可以设置为mkcp。</p>
<p>经过以上设置后，V2ray的流量，将以UDP的形式发出，也可以避开TCP阻断。</p>
<p>&nbsp;</p>
<h3>SSH端口还是无法连接？</h3>
<p>以上两种方案，只能解决SS/SSR所用端口的流量转换，并不能解决其它端口的TCP流量被阻断问题。</p>
<p>也就是说，设置之后，可以正常科学上网，但是直接SSH连接服务器，可能还是连不上，无法用<a href="https://ssr.tools/72" target="_blank" rel="noopener">Winscp/Putty</a>等工具对服务器进行管理。</p>
<p><span style="color: #ff0000;">如何解决：</span></p>
<p>VPS服务器可以正常科学上网后，可以采取<span style="color: #0000ff;"> 自己代理自己</span> 的方式，即通过相关设置，让Winscp/Putty，通过同一服务器上的SS/SSR/V2ray代理中转连接，连接成功后就可以正常使用了。</p>
<p>相关内容可以参考：</p>
<p><a href="https://ssr.tools/765" target="_blank" rel="noopener">为Winscp添加代理设置，通过SSR中转连接至服务器</a></p>
<p><a href="https://ssr.tools/749" target="_blank" rel="noopener">SSR端口转发 不借助其它工具使电脑任意软件走代理</a></p>
<p>&nbsp;</p>

<h1 class="article-title"><a href="https://ssr.tools/202">安全使用SSR的一些注意事项 避免VPS服务器被墙</a></h1>

<p>下面根据众多网友的反馈，列出一些在使用SSR过程中需要注意的事项，希望能降低大家被封的几率。</p>
<p>&nbsp;</p>
<h3>注意事项之服务器篇</h3>
<p><span style="color: #ff0000;">1.选择VPS服务器时，可以避开一些热门城市，选择比较冷门的。</span></p>
<p>一般来说，美国西海岸城市，如洛杉矶、旧金山等，因为对国内连接速度相对较快，所以也是大量国内用户扎堆的地区。这样的后果是：除了晚高峰可能会出现一定拥堵外，SS特征也更加明显，更容易被发现。另外在批量封禁一批服务器IP时，更可能被无辜牵连。</p>
<p><span style="color: #ff0000;">2.建议在服务器端安装SSR，即ShadowsocksR。</span></p>
<p>因为有网友反馈，原版SS，即Shadowsocks更容易被发现。</p>
<p><span style="color: #ff0000;">3.安装SSR时，协议一项（protocol），建议选择auth_chain开头的几个。</span></p>
<p>另外混淆一项（obfs），建议不要选择TLS开头的，因为加密强度较高，除了影响网速外，特征可能也会更加明显。</p>
<p><span style="color: #ff0000;">4.SSR搭建完成后，尽量避免多用户、多客户端同时连接使用，这样会更容易被封。</span></p>
<p>&nbsp;</p>
<h3>注意事项之客户端篇</h3>
<p>国内各大科技厂商，窥探隐私的欲望比较强烈，有鉴于此：</p>
<p><span style="color: #ff0000;">1.无论是电脑还是手机科学上网，建议不要安装国产杀毒软件。</span></p>
<p>比如360杀毒、**卫士等，可以用国外杀毒软件代替，免费的有AVAST、小红伞等，可选择的有很多。</p>
<p><span style="color: #ff0000;">2.不要使用国产浏览器科学上网。</span></p>
<p>比如360浏览器、QQ浏览器、百度浏览器、UC浏览器等，另外Opera浏览器已被360收购，也不推荐。</p>
<p>Windows端可用浏览器：Firefox、Chrome、Vivaldi等。</p>
<p>安卓端可用浏览器：Firefox、Chrome、Via等。</p>
<p><span style="color: #ff0000;">3.尽量不要使用国产知名输入法，最好使用一些小众又好用的，或者禁用输入法的联网权限。</span></p>
<p>大数据时代，云输入泛滥，带来方便的同时，也有负面效果：大部分输入法会收集你的隐私数据。</p>
<p>有没有体验过前脚在某个手机APP搜索要买的产品，后脚进另一个APP就会出现相应广告？很大程度上就是因为输入法收集了你的关键词，之后数据被卖给其它商家，最后出现精准广告投放。</p>
<p><span style="color: #ff0000;">4.尽量避免使用SSR客户端的全局代理模式上网。</span></p>
<p>如果你的所有流量都指向一个国外IP，这是非常可疑的。电脑端推荐设置为GFWList模式，或者国外IP走代理。手机端推荐设置为分应用代理，比如只让浏览器走代理。</p>
<p><span style="color: #ff0000;">5.尽量避免在安卓手机上长时间、大流量科学上网，毕竟国内各大手机厂商的系统基本都会收集个人数据。</span></p>
<p>&nbsp;</p>
<p>做到以上几点，并不保证你的VPS服务器一定安全，但是被封几率应该会明显降低。</p>
