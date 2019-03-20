scriptencoding utf-8



let s:save_trans_text = ''



"
" Japanese-English translation
"
function! jaendic#translator(word)

if exists('g:jaendic_ime_inactive_func') | exe 'call ' . g:jaendic_ime_inactive_func | endif
let s:save_trans_text = ''

python3 << EOF

import vim
import unicodedata
import urllib.parse
import urllib.request
import re

def translate(word):

    if include_ja(word):
        from_lang = "ja"
        into_lang = "en"
        url = "https://glosbe.com/" + from_lang + "/" + into_lang + "/" + urllib.parse.quote(word)
        pattern = r'<strong class=" phr">(.+?)</strong>'
    else:
        from_lang = "en"
        into_lang = "ja"
        url = "https://glosbe.com/" + from_lang + "/" + into_lang + "/" + word
        pattern = r'<strong class="nobold phr">(.+?)</strong>'

    try:
        response = urllib.request.urlopen(url)
    except urllib.error.HTTPError as err:
#         print(err.code)
        return ""
    except urllib.error.URLError as err:
#        print(err.reason)
        return ""

    html = response.read().decode("utf-8")
    matched_list = re.findall(pattern, html)
    text = ",".join(matched_list)

    return text

def include_ja(word):
    if word.isdecimal():
        return True
    for w in word:
        name = unicodedata.name(w)
        if "CJK UNIFIED" in name \
        or "HIRAGANA" in name \
        or "KATAKANA" in name:
            return True
    return False

word = vim.eval("a:word")
text = translate(word)
vim.command("let s:save_trans_text='"+re.sub("'", "''", text)+"'")

EOF

endfunction



"
" get a translated text
"
function! jaendic#get_trans_text()
  return s:save_trans_text
endfunction



"
" insert a translated text after the current line
"
function! jaendic#insert(word) abort
  call jaendic#translator(a:word)
  if s:save_trans_text ==# ''
    return ''
  endif
  call append(line('.'), jaendic#get_trans_text())
  normal! j0
endfunction



"
" print a translated text on the command line
"
function! jaendic#echo(word) abort
  call jaendic#translator(a:word)
  if s:save_trans_text ==# ''
    return ''
  endif
  echo jaendic#get_trans_text()
endfunction



"
" insert a translated text after the current line
" and move the cursor to a delimiter position(,)
"
function! jaendic#insert_move(word) abort
  call jaendic#insert(a:word)
  if s:save_trans_text !=# ''
    if getline('.') =~# ','
      exe "normal! /,\<CR>"
    else
      normal! $
    endif
  endif
endfunction



"
" test
"

"call jaendic#echo('aa')
"call jaendic#insert('aa')
"inoremap @ <C-o>:call jaendic#insert_move('aa')<CR>

"call jaendic#echo('ああ')
"call jaendic#insert('ああ')
"inoremap @ <C-o>:call jaendic#insert_move('ああ')<CR>

"call jaendic#echo('aaaaaaaaaaaaaaaaaaaaa')
"call jaendic#insert('aaaaaaaaaaaaaaaaaaaaa')
"inoremap @ <C-o>:call jaendic#insert_move('aaaaaaaaaaaaaaaaaaaaa')<CR>
