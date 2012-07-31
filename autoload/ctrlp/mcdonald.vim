if exists('g:loaded_ctrlp_mcdonald') && g:loaded_ctrlp_mcdonald
	finish
endif
let g:loaded_ctrlp_mcdonald = 1

let s:mcdonald_var = {
\  'init':   'ctrlp#mcdonald#init()',
\  'exit':   'ctrlp#mcdonald#exit()',
\  'accept': 'ctrlp#mcdonald#accept',
\  'lname':  'mcdonald',
\  'sname':  'mcdonald',
\  'type':   'feed',
\  'sort':   0,
\}

if exists('g:ctrlp_ext_vars') && !empty(g:ctrlp_ext_vars)
	let g:ctrlp_ext_vars = add(g:ctrlp_ext_vars, s:mcdonald_var)
else
	let g:ctrlp_ext_vars = [s:mcdonald_var]
endif

function! ctrlp#mcdonald#init()
  let html = webapi#http#get("http://www.mcdonalds.co.jp/menu/regular/index.html").content
  let dom = webapi#html#parse(iconv(html, "utf-8", &encoding))
  let s:menu = []
	for div in dom.findAll('div', {'class': 'column'})
    call add(s:menu, [div.findAll('img')[1].attr['alt'], 'http://www.mcdonalds.co.jp/'.div.find('a').attr['href']])
  endfor
	return map(copy(s:menu), 'v:val[0]')
endfunc

function! ctrlp#mcdonald#accept(mode, str)
	silent call openbrowser#open(filter(copy(s:menu), 'v:val[0] == a:str')[0][1])
	call ctrlp#exit()
endfunction

function! ctrlp#mcdonald#exit()
  if exists('s:feed')
    unlet! s:feed
  endif
endfunction

let s:id = g:ctrlp_builtins + len(g:ctrlp_ext_vars)
function! ctrlp#mcdonald#id()
	return s:id
endfunction

" vim:fen:fdl=0:ts=2:sw=2:sts=2
