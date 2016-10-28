初始化一个Git仓库，使用git init命令。

	创建一个版本库非常简单，首先，选择一个合适的地方，创建一个空目录：
	$ mkdir learngit
	$ cd learngit
	$ pwd
	C:/Users/lee/learngit
	pwd命令用于显示当前目录。在我的电脑上，这个仓库位于C:/Users/lee/learngit
	第二步，通过git init命令把这个目录变成Git可以管理的仓库：
	$ git init
	瞬间Git就把仓库建好了，而且告诉你是一个空的仓库（empty Git repository），细心的读者可以发现当前目录下多了一个.git的目录（隐藏文件):这个目录是Git来跟踪管理版本库的，没事千万不要手动修改这个目录里面的文件，不然改乱了，就把Git仓库给破坏了。

添加文件到Git仓库，分两步：

	第一步，使用命令git add <file>，注意，可反复多次使用，添加多个文件；eg: git add readme.txt
	第二步，使用命令git commit，完成。eg:git commit -m "任意起名"


git status
	此命令可以让我们时刻掌握仓库当前的状态，上面的命令告诉我们，readme.txt被修改过了，但还没有准备提交的修改。

git diff
	虽然Git告诉我们readme.txt被修改了，但如果能看看具体修改了什么内容，自然是很好的。比如你休假两周从国外回来，第一天上班时，已经记不清上次怎么修改的readme.txt，所以，需要用这个命令git diff看看：
	$ git diff readme.txt 
	git diff顾名思义就是查看difference，显示的格式正是Unix通用的diff格式，可以从上面的命令输出看到，我们在第一行添加了一个“distributed”单词。

	知道了对readme.txt作了什么修改后，再把它提交到仓库就放心多了，提交修改和提交新文件是一样的两步，第一步是git add：
	$ git add readme.txt
	同样没有任何输出。在执行第二步git commit之前，我们再运行git status看看当前仓库的状态：

	git status告诉我们，将要被提交的修改包括readme.txt，下一步，就可以放心地提交了：
	$ git commit -m "任意起名"

git reset --hard commit_id 时光机穿梭
	HEAD指向的版本就是当前版本，因此，Git允许我们在版本的历史之间穿梭，使用命令git reset --hard commit_id。
	在Git中，用HEAD表示当前版本，，上一个版本就是HEAD^，上上一个版本就是HEAD^^，当然往上100个版本写100个^比较容易数不过来，所以写成HEAD~100

	穿梭前，用git log可以查看提交历史，以便确定要回退到哪个版本。
	要重返未来，用git reflog查看命令历史，以便确定要回到未来的哪个版本。
	提交后，用git diff HEAD -- readme.txt命令可以查看工作区和版本库里面最新版本的区别：



出错修改
	场景1：当你改乱了工作区某个文件的内容，想直接丢弃工作区的修改时，用命令git checkout -- file。
	场景2：当你不但改乱了工作区某个文件的内容，还添加到了暂存区时，想丢弃修改，分两步，第一步用命令git reset HEAD file，就回到了场景1，第二步按场景1操作。
	场景3：已经提交了不合适的修改到版本库时，想要撤销本次提交，参考版本回退一节，不过前提是没有推送到远程库。



删除
	在Git中，删除也是一个修改操作，我们实战一下，先添加一个新文件test.txt到Git并且提交：
	一般情况下，你通常直接在文件管理器中把没用的文件删了，或者用rm命令删了：$ rm test.txt
	这个时候，Git知道你删除了文件，因此，工作区和版本库就不一致了，git status命令会立刻告诉你哪些文件被删除了：

现在你有两个选择:
	一是确实要从版本库中删除该文件，那就用命令git rm删掉，并且git commit：
	$ git rm test.txt
	$ git commit -m "remove test.txt"
	另一种情况是删错了，因为版本库里还有呢，所以可以很轻松地把误删的文件恢复到最新版本：
	$ git checkout -- test.txt



远程仓库
	在继续阅读后续内容前，请自行注册GitHub账号。由于你的本地Git仓库和GitHub仓库之间的传输是通过SSH加密的，所以，需要一点设置：
	第1步：创建SSH Key。在用户主目录下，看看有没有.ssh目录，如果有，再看看这个目录下有没有id_rsa和id_rsa.pub这两个文件，如果已经有了，可直接跳到下一步。如果没有，打开Shell（Windows下打开Git Bash），创建SSH Key：
	$ ssh-keygen -t rsa -C "youremail@example.com"
	你需要把邮件地址换成你自己的邮件地址，然后一路回车，使用默认值即可，由于这个Key也不是用于军事目的，所以也无需设置密码。
	如果一切顺利的话，可以在用户主目录里找到.ssh目录，里面有id_rsa和id_rsa.pub两个文件，这两个就是SSH Key的秘钥对，id_rsa是私钥，不能泄露出去，id_rsa.pub是公钥，可以放心地告诉任何人。
	第2步：登陆GitHub，打开“Account settings”，“SSH Keys”页面：
	然后，点“Add SSH Key”，填上任意Title，在Key文本框里粘贴id_rsa.pub文件的内容：
	点“Add Key”，你就应该看到已经添加的Key：


添加远程仓库
	现在的情景是，你已经在本地创建了一个Git仓库后，又想在GitHub创建一个Git仓库，并且让这两个仓库进行远程同步，这样，GitHub上的仓库既可以作为备份，又可以让其他人通过该仓库来协作，真是一举多得。
	首先，登陆GitHub，然后，在右上角找到“Create a new repo”按钮，创建一个新的仓库：
	在Repository name填入learngit，其他保持默认设置，点击“Create repository”按钮，就成功地创建了一个新的Git仓库：
	目前，在GitHub上的这个learngit仓库还是空的，GitHub告诉我们，可以从这个仓库克隆出新的仓库，也可以把一个已有的本地仓库与之关联，然后，把本地仓库的内容推送到GitHub仓库。

	现在，我们根据GitHub的提示，在本地的learngit仓库下运行命令：
	$ git remote add origin https://github.com/starlee261/learngit.git
	请千万注意，把上面的starlee261替换成你自己的GitHub账户名，否则，你在本地关联的就是我的远程库，关联没有问题，但是你以后推送是推不上去的，因为你的SSH Key公钥不在我的账户列表中。

	添加后，远程库的名字就是origin，这是Git默认的叫法，也可以改成别的，但是origin这个名字一看就知道是远程库。

	下一步，就可以把本地库的所有内容推送到远程库上：
	$ git push -u origin master
	把本地库的内容推送到远程，用git push命令，实际上是把当前分支master推送到远程。
	由于远程库是空的，我们第一次推送master分支时，加上了-u参数，Git不但会把本地的master分支内容推送的远程新的master分支，还会把本地的master分支和远程的master分支关联起来，在以后的推送或者拉取时就可以简化命令。
	推送成功后，可以立刻在GitHub页面中看到远程库的内容已经和本地一模一样：

	从现在起，只要本地作了提交，就可以通过命令：
	$ git push origin master
	把本地master分支的最新修改推送至GitHub，现在，你就拥有了真正的分布式版本库！

	当你第一次使用Git的clone或者push命令连接GitHub时，会得到一个警告：

	SSH警告
	The authenticity of host 'github.com (xx.xx.xx.xx)' can't be established.
	RSA key fingerprint is xx.xx.xx.xx.xx.
	Are you sure you want to continue connecting (yes/no)?
	这是因为Git使用SSH连接，而SSH连接在第一次验证GitHub服务器的Key时，需要你确认GitHub的Key的指纹信息是否真的来自GitHub的服务器，输入yes回车即可。
	Git会输出一个警告，告诉你已经把GitHub的Key添加到本机的一个信任列表里了：
	Warning: Permanently added 'github.com' (RSA) to the list of known hosts.
	这个警告只会出现一次，后面的操作就不会有任何警告了。
	如果你实在担心有人冒充GitHub服务器，输入yes前可以对照GitHub的RSA Key的指纹信息是否与SSH连接给出的一致。