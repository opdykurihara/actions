# github Actions
## [github Actions](https://help.github.com/ja/actions)とは

>GitHub Actionsを使用すると、ワールドクラスのCI/CDですべてのソフトウェアワークフローを簡単に自動化できます。 
>GitHubから直接コードをビルド、テスト、デプロイでき、コードレビュー、ブランチ管理、問題のトリアージを希望どおりに機能させます。

* GitHub上のリポジトリやイシューに対するさまざまな操作をトリガーとしてあらかじめ定義しておいた処理を実行できる機能。
* GitHubが提供するサーバー上に用意された仮想マシン内で実行できるため、ユーザーが独自にサーバーなどを準備する必要はない点が最大のメリット

## 仮想マシン上で利用できるOS
* Linux（Ubuntu）
* Windows
* macOS

仮想マシン上にはOSだけでなく、さまざまな言語のコンパイラや各種ランタイム、主要ライブラリといったソフトウェア開発環境も標準でインストールされている。
→一般的なサーバー上で実行できるほとんどの処理を実行できる

## Actionはどこに作成するのか？
実行する処理とその処理を実行する条件をYAML形式で定義し、リポジトリ内の.github/workflowsディレクトリ内に保存するすることで実行できるようになる。
このファイルをワークフローと呼び、ワークフロー内ではシェル経由で任意のコマンドを実行できるほか、「Action」という、あらかじめ定義済みの処理を呼び出せるようになっている。

### GitHubが提供しているAction
| Action名 | 説明 |
| - | - |
| setup-node | Node.js環境のセットアップを行う |
| github-script | GitHub APIを使ってGitHubの各種機能にアクセスする |
| upload-artifact | 指定したファイルを「artifact」として保存する |
| cache | 生成物をキャッシュして処理を高速化する |
| checkout | リポジトリからファイルをチェックアウトする |
| setup-ruby | Ruby環境のセットアップを行う |
| setup-java | Java環境のセットアップを行う |
| setup-python | Python環境のセットアップを行う |
| upload-release-asset | GitHubのリリース機能を使ってファイルを公開する |
| setup-dotnet | .NET core環境のセットアップを行う |
| setup-elixir | Elixir環境のセットアップを行う |
| create-release | リリースを作成する |
| setup-go | Go環境のセットアップを行う |
| labeler | GitHub上でのラベルを管理する「.github/labeler.yml」ファイルを作成する |
| download-artifact | 「artifact」として保存されているファイルをダウンロードする |
| stale | 一定期間活動のないイシューやプルリクエストを閉じる処理を行う |
| first-interaction | 初めてプルリクエストやイシューを登録したユーザーに対しメッセージを出す |
| setup-haskell | Haskell環境のセットアップを行う |

### Actionを独自に作成することも可能
ActionについてはNode.jsで記述できるほか、Dockerコンテナを利用して任意の処理を実行させるようなものも作成できる。ユーザー定義のActionを集めたマーケットプレイスもある
* [マーケットプレイス](https://github.com/marketplace?type=actions)

## ワークフロー作成のルールと書式

[ワークフローファイルのシンタックス](https://help.github.com/en/actions/reference/workflow-syntax-for-github-actions)

### 「on」と「runs-on」は必須

#### on要素について
ワークフローを起動するトリガーとなるイベント、もしくはワークフローを起動する時刻を記述するもの。  
onで定義できるイベントは[GitHubのWebhook機能で定義されているイベント](https://developer.github.com/webhooks/)と同様になっている。

例）リポジトリへのプッシュが行われた際にワークフローを起動したい場合 
`on: push`

例）リポジトリへのプッシュとdeleteの両方が行われた際にワークフローを起動したい場合 
`on: [push, delete]`

#### runs-on要素について
ワークフローを実行する仮想マシン環境を指定する

例）Windows Server 2019環境でワークフローを実行したい場合 
`runs-on: windows-latest`

| 仮想環境 | YAMLのワークフローラベル |
| - | - |
| Windows Server 2019 | windows-latest or windows-2019 |
| Ubuntu 18.04 | ubuntu-latestまたはubuntu-18.04 |
| Ubuntu 16.04 | ubuntu-16.04 |
| macOS Catalina 10.15 | macos-latestもしくはmacos-10.15 |
| ユーザーが独自に用意した実行環境 | self-hosted | 

### 実行する処理(job)の書式
定義されたジョブは基本的に並列に実行される

```
jobs:
  ＜ジョブID1＞:
    name: ＜ジョブ名＞
    ：
    ジョブの定義
    ：
  ＜ジョブID2＞:
    name: ＜ジョブ名＞
    ：
    ジョブの定義
    ：
  ：
```

####　特定の順序でジョブを実行したい場合「jobs.＜ジョブID＞.needs」要素を使う
例）「foo」というジョブの完了後に「bar」を実行したい場合
```
jobs:
  foo:
    name: job foo
  bar:
    name: job bar
    needs: foo　<-- ★
```

####　ジョブの中で指定された順序で処理を実行する場合はsteps要素を使う
```
jobs:
  ＜ジョブID1＞:
    name: ＜ジョブ名＞
    steps:
      - name: ＜ステップ1の名前＞
        run: ＜実行する処理＞
        ：
        ：
      - name: ＜ステップ2の名前＞
        run: ＜実行する処理＞
        ：
        ：
```

####　run要素で指定したコマンドはシェル経由で実行されるようになっている
実行環境が非Windowsプラットフォームの場合はbash（bashが存在しない場合はsh）、Windowsプラットフォームの場合はPowerShellがデフォルトのシェルとして使われるが、「shell」要素で明示的に使用するシェルを指定することもできる。
```
 - name: ＜ステップの名前＞
        run: ＜実行する処理＞
        shell: bash
```
| 指定できるシェル | 対応プラットフォーム | 備考 |
| - | - | - |
| bash | すべて |
| pwsh | すべて | PowerShellのクロスプラットフォーム対応版であるPowerShell Core |
| python | すべて | 任意のPythonコードを実行できる |
| sh | Linux、macOS |  |
| cmd | Windows | コマンドプロンプト |
| powershell | Windows | Windows PowerShell |


#### uses要素を利用して任意のAction実行やDockerコンテナ内で処理実行できる

steps以下ではrun要素ではなく「uses」要素を指定して、任意のAction実行や、指定したDockerコンテナを起動してその中で指定した処理を実行したりできる。  

##### Actionを指定する場合
「＜オーナー＞/＜リポジトリ＞/＜パス＞@＜タグ|ブランチ|リファレンス＞」の形で指定する（パスや@以下については省略可能）。  
Actionに与えるパラメータは「with」要素で指定する。
usesを指定する場合、「name」要素による名前の指定は省略されることが多い。その場合、Action名が名前として指定されたことになる。
```
- name: ＜ステップの名前＞
  uses: ＜オーナー＞/＜リポジトリ＞/＜パス＞@＜タグ|ブランチ|リファレンス＞
  with:
    ＜パラメータ1＞: ＜値＞
    ＜パラメータ2＞: ＜値＞
    ：
    ：
```

例）リポジトリからのチェックアウトを行う「actions/checkout」を利用して、リポジトリ内の「foo」というブランチをチェックアウトする場合
```
uses: actions/checkout@v2
with:
  ref: foo
```

##### Dockerを指定する場合
「docker://＜イメージ名＞:＜タグ＞」を指定する。　　
with要素の「entrypoint」要素や「args」要素でコンテナを実行する際のエントリーポイントや引数を指定できる。

```
- name: ＜ステップの名前＞
  uses: docker://＜イメージ名＞:＜タグ＞
  with:
    entrypoint: ＜コンテナのエントリーポイント＞
    args: ＜実行の際に与える引数＞
```
