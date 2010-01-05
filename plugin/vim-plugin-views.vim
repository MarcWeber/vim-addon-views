if !exists('g:vim_views_config') | let g:vim_views_config = {} | endif | let s:c = g:vim_views_config 

let s:c['exec'] = get(s:c,'exec', funcref#Function('views#ContentExec'))
let s:c['fun']  = get(s:c,'fun',  funcref#Function('views#ContentFun'))

augroup VIM_PLUGIN_VIEWS
  autocmd BufReadCmd vim_view_*://* call views#FillContents()
augroup end
