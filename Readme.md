# jaendic

日英・英日辞書。vim 上で日本語を英単語に、英単語を日本語に変換して出力するプラグイン。

## 必要条件

- vim が python3 でコンパイルされている。

## 使い方

- 関数 `jaendic#insert({word})` を呼び出すと、入力単語の変換結果をカレント行の下に挿入する。以下、例。

```vim
:call jaendic#insert('hi')
" こんにちは,やあ,どうも,おはよう,こんちゃ,バイバイ,今日は,moshi-moshi,やほー,よう,ホームインプルーブメント,ヨウかすいそ,ヨウ化水素,沃化水素,ようかすいそ,アロハ州,ハワイ,ハワイ州,ういっす,ちわっす,おは,おはよっす,押っ忍,押忍

:call jaendic#insert('こんにちは')
" hello,good afternoon,hi,good day,cheerio,howdy,compliments,good morning,greeting,greetings,hey,regards,so long,good evening,how-do-you-do,hullo
```

- 関数 `jaendic#echo({word})` を呼び出すと、入力単語の変換結果をコマンドラインに出力する。

## IMEの制御

上記の jaendic 関数を呼び出した後 IME を自動で OFF に戻したい場合、変数 `g:jaendic_ime_inactive_func` に IME の OFF を行う関数を設定する。以下、例。

```vim
" fcitxのIMEをOFFにする場合 (vimrcに書く)
let g:jaendic_ime_inactive_func = 'IME_inactive()'
function! IME_inactive()
  call system('fcitx-remote -c')
endfunction
```
