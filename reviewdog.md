# Github Actionsでreviewdogを利用してCSSの構文チェックをしてみる
## [reviewdog](https://github.com/reviewdog/reviewdog)とは

各種linterの実行結果をプルリクエストのコメントで指摘してくれるツール。

![エラーイメージ](https://raw.githubusercontent.com/opdykurihara/actions/images/sample-01.png)

## workflowファイルの書き方

.github配下にymlを作成する。

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
