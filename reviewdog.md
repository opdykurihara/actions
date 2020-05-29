# Github Actions+reviewdog+stylelintを利用してCSSの構文チェックをしてみる
## [reviewdog](https://github.com/reviewdog/reviewdog)とは？
各種linterの実行結果をプルリクエストのコメントで指摘してくれるツール。

## [stylelint](https://github.com/stylelint/stylelint)とは？
CSSの構文チェックをしてくれるツール。

## プルリクエストが作成されたら、自動でCSSの構文チェックをしてくれるワークフローを作成する

### stylelintの設定ファイルを用意する
以下の設定ではstylelint-config-recess-orderを利用しているが、
必要なモジュールがpackage.jsonに記述されていなとGithub Actions側で利用できないので注意する。

```
module.exports = {
  // stylelint-config-recess-order:ポジション, ボックスモデル関連、その他の順番でプロパティを整列させ
  extends: "stylelint-config-recess-order",
  rules: {
    // インデントなし
    "indentation": 0,
    // 16進数表記が正しいか
    "color-no-invalid-hex":true,
    // 16進数の色は小文字になっているか
    "color-hex-case": "lower",
    // ダブルクォート
    "string-quotes": "double",
    // calc()の表記が間違っていないか
    "function-calc-no-invalid":true,
    // 1未満の数の表記は0を省略しているか
    "number-leading-zero": "never",
    // 1.0など数字が0で終わっていないか
    "number-no-trailing-zeros": true,
    // 正しい単位が使われているか
    "unit-no-unknown":true,
    // プロパティの重複がないか
    // "declaration-block-no-duplicate-properties":true,
    // コロンの前に空白を許可しない
    "declaration-colon-space-after": "never",
    // プロパティの前の空行を許可しない
    "declaration-empty-line-before": "never",
    // セレクタ指定内にプロパティがない場合にエラー
    "block-no-empty":true,
    // 「{」の前にホワイトスペースを許可しない
    "block-opening-brace-space-before": "never",
    // 擬似クラスの名前があっているか
    "selector-pseudo-class-no-unknown":true,
    // 擬似要素の名前があっているか
    "selector-pseudo-element-no-unknown":true,
    // 存在しないHTML要素を指定していないか
    "selector-type-no-unknown":true,
    // セレクタリストのカンマの後に改行があるか
    "selector-list-comma-newline-after":"always",
    // セレクタの組み合わせの前にスペースがあるか
    "selector-combinator-space-before":"always",
    // 存在しないプロパティが使われていないか
    "property-no-unknown":true,
    // ルールの前に空行を許可しない
    "rule-empty-line-before": "never",
    // @で始まる指定が正しいかどうか
    "at-rule-no-unknown":true,
    // @で始まる指定の前に空行があるか
    "at-rule-empty-line-before":"always",
    // 空のコメントがないか
    "comment-no-empty":true,
    // コメントの前の空行は必須でコメント後に空行を入れない
    "comment-empty-line-before":["always",{
      "except":"first-nested",
      "ignore":"after-comment"
    }],
    // プロパティの順番（仮でサンプル入れているだけ）
    "order/properties-order": [
    ]
  }
}
```

### workflowファイルを作成する

.github配下にymlを作成する

```
name: reviewdog
on: [pull_request]

jobs:
  stylelint:
    name: check_stylelint_error
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v1
      - name: yarn install
        run: yarn install
      - name: stylelint review
        uses: reviewdog/action-stylelint@v1
        with:
          github_token: ${{ secrets.github_token }}
          reporter: github-pr-review
          stylelint_input: './src/**/*.{css,scss}'
      - name: stylelint
        run: yarn lint:css
```

プルリクを作成し、エラーがある場合には下記のようにreviewdogがコメントを残してくれる。
![エラーイメージ](https://raw.githubusercontent.com/opdykurihara/actions/images/sample-01.png)
