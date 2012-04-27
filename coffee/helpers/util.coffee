exports = 

  mix: () ->
    child = {}
    for arg in arguments
      for prop of arg
        if arg.hasOwnProperty prop
          child[prop] = arg[prop]
    return child
    