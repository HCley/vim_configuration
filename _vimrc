" Vim with all enhancements
source $VIMRUNTIME/vimrc_example.vim

" --- Diff helper (keep as-is) ---
if &diffopt !~# 'internal'
  set diffexpr=MyDiff()
endif
function! MyDiff()
  let opt = '-a --binary '
  if &diffopt =~ 'icase'  | let opt .= '-i ' | endif
  if &diffopt =~ 'iwhite' | let opt .= '-b ' | endif

  let arg1 = substitute(v:fname_in,  '!', '\!', 'g')
  let arg2 = substitute(v:fname_new, '!', '\!', 'g')
  let arg3 = substitute(v:fname_out, '!', '\!', 'g')

  if arg1 =~ ' ' | let arg1 = '"' . arg1 . '"' | endif
  if arg2 =~ ' ' | let arg2 = '"' . arg2 . '"' | endif
  if arg3 =~ ' ' | let arg3 = '"' . arg3 . '"' | endif

  if $VIMRUNTIME =~ ' '
    if &sh =~ '\<cmd'
      if empty(&shellxquote)
        let l:shxq_sav = ''
        set shellxquote&
      endif
      let cmd = '"' . $VIMRUNTIME . '\diff"'
    else
      let cmd = substitute($VIMRUNTIME, ' ', '" ', '') . '\diff"'
    endif
  else
    let cmd = $VIMRUNTIME . '\diff'
  endif

  let cmd = substitute(cmd, '!', '\!', 'g')
  silent execute '!' . cmd . ' ' . opt . arg1 . ' ' . arg2 . ' > ' . arg3

  if exists('l:shxq_sav')
    let &shellxquote = l:shxq_sav
  endif
endfunction

" --- Editor basics ---
syntax on
set number
set hidden
set mouse=a
set smartindent

" Tabs/indent
set tabstop=4
set shiftwidth=4
set softtabstop=4
set expandtab

set backspace=indent,eol,start
let g:vim_json_syntax_conceal = 0
set autoread

" --- Red column on the right ---
" If you DON'T want it, comment the next line or set it to 0.
" set colorcolumn=80
set colorcolumn=0

" --- GUI-only settings (avoid "Press ENTER" in terminal Vim) ---
if has('gui_running')
  set guioptions-=m  " remove menu bar
  set guioptions-=T  " remove toolbar
  set guioptions-=r  " remove right scroll bar
  set guioptions-=L  " remove left scroll bar
  " Avoid absurd sizes; you can adjust
  set lines=50 columns=160
endif

" --- Temp/backup/swap in Windows Temp ---
" Prefer %TEMP% / %TMP% if present; fallback to C:\Windows\Temp
let s:tmp = empty($TEMP) ? (empty($TMP) ? 'C:\Windows\Temp' : $TMP) : $TEMP
let s:tmp = substitute(s:tmp, '/', '\', 'g')

" Put swap/backup files there. Trailing // helps avoid name collisions.
set backup
execute 'set backupdir=' . fnameescape(s:tmp) . '\//'
execute 'set directory=' . fnameescape(s:tmp) . '\//'

" Optional: keep Vim from making extra backup copies during write
set nowritebackup
