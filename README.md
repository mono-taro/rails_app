# README

今日・明日出版される本
新規に出版された本をバッチ処理で蓄積
## 新規機能
会員機能
お気に入り→お気に入りからおすすめの本をだす（レコメンドなど)
その本を読んだかどうかチェック
本を探す


# 環境構築方法

1. 以下のコマンドを実行
```
docker-compose up --build
```
Could not find xxxx in any of the sources（Bundler::GemNotFound）だった場合は、`Gemfile.lock`を削除し再度実行

2. 以下のコマンドを実行
```
docker exec -it nuxt_client /bin/sh
```
フロントのコンテナに入り、以下のコマンドでサーバーを起動。

```
npm run dev
```

以上で環境構築完了。