if !exists('g:vim_views_config') | let g:vim_views_config = {} | endif | let s:c = g:vim_views_config 
" default action is using sp
let s:c['show_action'] = get(s:c,'show_action', 'sp')

fun! views#Escape(s)
  return escape(a:s, "[#,")
endf

" open a view of type type passing arguments args
fun! views#View(type, args, ...)
  let urlOnly = a:0 > 0 ? a:1 : 0
  if urlOnly
    return 'vim_view_'.a:type.'://'.views#Escape(string(a:args))
  else
    exec s:c['show_action'].' vim_view_'.a:type.'://'.views#Escape(string(a:args))
  endif
endf

fun! views#ViewType()
  let list = matchlist(expand('%'), 'vim_view_\([^:/]*\)://\(.*\)')
  let f = get(s:c, list[1], 'views#UnkownViewType')
  let args = eval(list[2])
  return [f,args]
endf

" helper function filling the buffer with contents defined by buffer url
fun! views#FillContents()
  let g:g=9
  let [f,args] = views#ViewType()

  try
    let contents = funcref#Call(f, args)
  catch /.*/
    let contents = "Exception:\n".v:exception
  endtry
  
  normal ggdG
  call append(0, split(contents,"\n"))
endf

fun! views#UnkownViewType(...)
  return "unkown view type, passed args: ".string(a:000)
endf

" implementation vim_view_exec
fun! views#ContentExec(...)
  return system(join(map(copy(a:000),"shellescape(v:val)"),' '))
endf

" implementation vim_view_fun
fun! views#ContentFun(...)
  return funcref#Call(funcref#Function(a:1), a:000[1:])
endf
