" Load the project configuration
" @param config_path The path to the configuration file
" @return Whether the config was successfully loaded
function! project#load(config_path)
  if !filereadable(a:config_path)
    return v:false
  endif

  let config = readfile(a:config_path)
  let length = len(config) - 1

  for line in range(0, length)
    let [setting, value] = split(config[line], "=")
    let setting = trim(setting)
    let value = trim(value)

    if len(setting) == 0
      continue
    endif

    if setting ==# "repl"
      let g:project#repl = value
    elseif setting ==# "build"
      let g:project#build = value
    elseif setting ==# "reload"
      let g:project#reload = value
    else
      echoerr config_path . ":" . line . ": unknown setting '" . setting . "'"
    endif
  endfor

  return v:true
endfunction

" Modify a path string if needed such that it ends with a '/'
" @param path The path to modify
" @return The modified string path
function! s:Slash(path)
  return substitute(a:path, "/$", "", "") . "/"
endfunction

" Setup the project UI (The output terminal and the project root folder)
" @param path The path to the project
function! project#setup(path)
  execute "edit " . a:path . " | cd " . a:path

  if project#load(s:Slash(a:path) . g:project#config_path)
    if len(g:project#repl) > 0
      execute "vsplit | terminal"
      call feedkeys("\<c-w>wA" . substitute(g:project#repl, '\\n', "\n", "g") . "\n\<c-\>\<c-n>\<c-w>w", "n")
    elseif len(g:project#build) > 0 || len(g:project#reload) > 0
      execute "vsplit | terminal"
    endif

    wincmd w
  endif
endfunction

" Project specific reload function, used in repls for example.
function project#reload()
  if len(g:project#reload) > 0
    let command = g:project#reload
  elseif len(g:project#build) > 0
    let command = g:project#build
  else
    return
  endif

  call feedkeys("\<c-w>wA\<c-l>\<c-\>\<c-n>ztA" . g:project#reload . "\n\<c-\>\<c-n>\<c-w>w\<c-l>", "n")
endfunction

" Kill the terminal associated with the project
function! project#kill()
  if len(g:project#repl) > 0 || len(g:project#build) > 0 || len(g:project#reload) > 0
    call feedkeys("\<c-w>wA\<c-d>\<c-\>\<c-n>:bdelete!\<cr>\<c-l>", "n")
  endif
endfunction

" Go forward or backward an error from the project output window
" @param forward Whether the movement is forward
function! project#error(forward)
  if len(g:project#repl) > 0 || len(g:project#build) > 0 || len(g:project#reload) > 0
    wincmd w

    normal! 0
    if search('\f\+:\d\+\(:\d\+\)\?', "W" . (a:forward ? "" : "b")) == 0
      if search('\f\+:\d\+\(:\d\+\)\?', "cW" . (a:forward ? "" : "b")) == 0
        wincmd w
        return
      endif
    endif

    normal! zt
    let position = split(getline("."), ":")
    wincmd w

    if len(position) > 0 && fnamemodify(bufname(), ":p") !=# fnamemodify(position[0], ":p")
      silent! execute "edit " . position[0]
    endif

    if len(position) > 1
      silent! execute "normal! " . position[1] . "G0"
    endif

    if len(position) > 2 && str2nr(position[2]) > 1
      silent! execute "normal! " . (str2nr(position[2]) - 1) . "l"
    endif
  endif
endfunction

" Load a project from the directory of projects using `fzf`
function! project#fzf()
  if len(g:project#location) == 0
    echo "Set `g:project#location` to the directory where all the projects are located"
    return
  endif

  let location = s:Slash(fnamemodify(g:project#location, ":p"))

  if exists("g:loaded_fzf")
    call fzf#run(fzf#wrap({'source': 'ls ' . g:project#location, 'sink': {project -> project#setup(location . project)}}))
  else
    echo "Fzf is needed for this feature. See https://github.com/junegunn/fzf"
  endif
endfunction

" The entry point to the project functions
function! project#entry()
  let option = nr2char(getchar())

  if option == "s" || option == ""
    call project#fzf()
  elseif option == "r" || option == ""
    call project#reload()
  elseif option == "k" || option == ""
    call project#kill()
  elseif option == "n" || option == ""
    call project#error(v:true)
  elseif option == "p" || option == ""
    call project#error(v:true)
  elseif option == "f" || option == ""
    if exists("g:loaded_fzf_vim")
      GFiles
    else
      echo "The `fzf.vim` plugin is needed for this feature. See https://github.com/junegunn/fzf.vim"
    endif
  endif
endfunction
