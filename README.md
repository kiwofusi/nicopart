# ニコニコ動画のpart数ごとの動画件数を調べる

## きっかけ
サッカーを全く知らないオレがサッカーチームを作ってみた　part1
http://www.nicovideo.jp/watch/sm4816674
この動画の「ニコ動長寿シリーズ」タグをみて。

## 使い方
ruby part_num_checker.rb (ニコ動メアド) (ニコ動パス) (検索文字列・前) (part数from) (part数to) (検索文字列・後)

例：「part10」から「part100」までの動画数を調べる
ruby part_num_checker.rb (ニコ動メアド) (ニコ動パス) part 10 100

例：「第1話」から「第10話」までの動画数を調べる
ruby part_num_checker.rb (ニコ動メアド) (ニコ動パス) 第 1 10 話

## 実行結果
part1-559の動画数グラフ
https://docs.google.com/spreadsheet/ccc?key=0AtLZy6KOY5-zdGVOMVNnQmlSYUFNbGtfUVdhMGhtR2c&usp=sharing

## 参考
rubyでニコニコ動画のコメントを取得する
http://hai3.net/blog/2011/07/21/ruby-niconico/

ニコニコ動画に動画検索APIができたらしいので取り急ぎScalaで
http://www.trinity-site.net/blog/?p=201

## メモ
2013-05-23時点の"part"最大数: 約560