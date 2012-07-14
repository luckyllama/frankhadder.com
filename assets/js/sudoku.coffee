(($) ->

  # helper logic taken from https://gist.github.com/927782

  ROWS = "ABCDEFGHI"
  COLS = "123456789"
  DIGITS = COLS

  cross = (A, B) ->
    results = []
    for a in A
      for b in B
        results.push a + b
    results

  uniq_and_remove = (duparr, ele) ->
    hash = {}
    for sq in duparr
      hash[sq] = 0
    arr = []
    for own key, value of hash
      arr.push(key) if key != ele
    arr

  squares = cross(ROWS, COLS)

  nine_squares = []
  for rs in ['ABC','DEF','GHI']
    for cs in ['123','456','789']
      nine_squares.push cross(rs,cs)
  
  unitlist = (cross(ROWS, c) for c in COLS).concat(cross(r, COLS) for r in ROWS).concat(nine_squares)

  units = {}
  for s in squares
    units[s] = []
    for u in unitlist
      units[s].push(u) if s in u

  peers = {}
  for s in squares
    peers[s] = []
    peers[s] = peers[s].concat(cross(ROWS, s[1])).concat(cross(s[0], COLS))
    for ns in nine_squares
      peers[s] = peers[s].concat(ns) if s in ns
    peers[s] = uniq_and_remove(peers[s],s)

  class SudokuGenerator
    FINISHED = 0
    INVALID = -1
    board: {}
    timesInitialized: 0

    constructor: ->
      console.time "sudoku generator" if console?
      @initializeBoard()

      randomSquare = @chooseUnsolvedSquare()
      while randomSquare isnt FINISHED
        if randomSquare is INVALID
          @initializeBoard()
          randomSquare = @chooseUnsolvedSquare()

        @solveSquare randomSquare
        @updateCandidates() 
        randomSquare = @chooseUnsolvedSquare()

      console.timeEnd "sudoku generator" if console?
      console.log "sudoku generator started #{@timesInitialized} times" if console?

    initializeBoard: -> 
      # To start, every square can be any digit; then assign values from the grid.
      @board[s] = { value: 0, candidates: [1..9] } for s in squares
      @timesInitialized++

    chooseUnsolvedSquare: ->
      keys = [[],[],[],[],[],[],[],[],[]]
      for own key, cell of @board when cell.value is 0
        return INVALID if cell.candidates.length is 0 
        keys[cell.candidates.length-1].push key
      
      for key in keys
        if key.length > 0
          return key[Math.floor(key.length * Math.random())]

      return FINISHED

    solveSquare: (randomSquare) ->
      candidates = @board[randomSquare].candidates
      randomCandidate = candidates[Math.floor(candidates.length * Math.random())]
      @board[randomSquare].value = randomCandidate
    
    updateCandidates: ->
      for key, cell of @board when cell.value isnt 0
        for peer in peers[key]
          @board[peer].candidates = @board[peer].candidates.filter (x) -> x isnt cell.value

  class SudokuView 
    board: {}
    constructor: (@$el) ->
      @board = new SudokuGenerator().board
      @render()

    render: ->
      for row in ROWS
        $row = $("<div>").addClass("row").addClass(row)
        for col in COLS
          s = "#{row}#{col}"
          $square = $("<div>").addClass("col #{s} col-#{col}")
            .append renderSquare(@board[s])
          $row.append $square
        @$el.append $row

    renderSquare = (s) ->
      if s.value is 0
        $candidates = $("<div>").addClass("candidates")
        for possibleDigit in [1..9]
          $candidate = $("<span>").addClass("candidate")
          $candidate.text possibleDigit if possibleDigit in s.candidates 
          $candidates.append $candidate
        $candidates
      else 
        $("<div>").addClass("value").text(s.value)

  $ ->
    board = new SudokuView $(".sudoku .board")

)(jQuery)
  