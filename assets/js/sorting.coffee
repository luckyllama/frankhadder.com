(($) ->

  Array::shuffle = -> @sort -> 0.5 - Math.random()

  class SortingAlgorithm
    initList: [1..15]
    constructor: (initList) ->
      @initList = initList.slice()
      @solve()
    solve: -> # defined in implementing class
    @generateList: ->
      return [1..15].shuffle()

  class Bubblesort extends SortingAlgorithm
    log: []
    constructor: (initList) -> 
      super(initList)
      log = [initList]
    solve: ->
      list = @initList.slice()
      bound = list.length - 1
      while true
        t = 0
        for j in [0..bound]
          if list[j] > list[j+1]
            [list[j], list[j+1]] = [list[j+1], list[j]]
            @log.push list.slice()
            t = j 
        break if t is 0
        bound = t
      return

  class Heapsort extends SortingAlgorithm
    log: []
    constructor: (initList) ->
      super(initList)
      log = [initList]
    solve: ->
      # def heapsort(lst):
      #     start = (len(lst)/2)-1
      #     end = len(lst)-1
      #     while start >= 0:
      #         sift(lst, start, len(lst))
      #         start -= 1
      #     while end > 0:
      #         lst[end], lst[0] = lst[0], lst[end]
      #         lst.log()
      #         sift(lst, 0, end)
      #         end -= 1
      list = @initList.slice()
      start = (list.length / 2) - 1
      end = list.length - 1
      while start >= 0
        @sift list, start, list.length
        start--
      while end > 0
        [list[end], list[0]] = [list[0], list[end]]
        @log.push list.slice()
        @sift list, 0, end
        end--
      return
    sift: (list, start, count) ->
      #   def sift(lst, start, count):
      #     root = start
      #     while (root * 2) + 1 < count:
      #         child = (root * 2) + 1
      #         if child < (count-1) and lst[child] < lst[child+1]:
      #             child += 1
      #         if lst[root] < lst[child]:
      #             lst[root], lst[child] = lst[child], lst[root]
      #             lst.log()
      #             root = child
      #         else:
      #             return
      root = start 
      while (root * 2) + 1 < count
        child = (root * 2) + 1
        if child < (count - 1) and list[child] < list[child + 1]
          child++
        if list[root] < list[child]
          [list[root], list[child]] = [list[child], list[root]]
          @log.push list.splice()
          root = child
        else 
          return
      return

  class Insertionsort extends SortingAlgorithm
    log: []
    constructor: (initList) ->
      super(initList)
      log = [initList]
    solve: ->
      list = @initList.slice()
      # for i in [1..list.length]
      #   for j in [1..i]
      #     if list[i] < list[j]
      length = list.length
      i = -1
      while length--
        temp = list[++i]
        j = i
        while j-- and list[j] > temp
          list[j+1] = list[j]
        list[j+1] = temp
        @log.push list.slice()

    #         var len = arr.length, i = -1, j, tmp;
 
    # while (len--) {
    #     tmp = arr[++i];
    #     j = i;
    #     while (j-- && arr[j] > tmp) {
    #         arr[j + 1] = arr[j];
    #     }
    #     arr[j + 1] = tmp;
    # }
      # for i in range(1, len(lst)):
      #     for j in range(i):
      #         if lst[i] < lst[j]:
      #             x = lst.pop(i)
      #             lst.insert(j, x)
      #             lst.log()


  class SortingView
    canvas = undefined
    constructor: (@$el) -> 
      $visual = $(".visual", @$el)
      @canvas = $(".visual canvas", @$el)[0]
      @canvas.width = $visual.width()
      @canvas.height = $visual.height()

      if not @canvas.getContext
        $(".visual").append $("<p>").text("This feature is only supported on IE 9+, and most alternate browsers (e.g. Chome, Firefox).")
        return
      
      initList = SortingAlgorithm.generateList()
      algorithms = 
        bubblesort: new Bubblesort(initList)
        heapsort: new Heapsort(initList)
        insertionsort: new Insertionsort(initList)
      
      selectedAlgoritm = $(".controls .algorithm a.active", @$el).text()
      self = @
      $(".controls .algorithm a", @$el).on "click", -> self.render algorithms[$(@).text()].log
      
      @render algorithms[selectedAlgoritm].log

    toFullColorHex = (hex) -> "#11#{hex}#{hex}"

    render: (logs) ->
      return if logs.length is 0 # nothing to see here, move along

      context = @canvas.getContext("2d")
      context.clearRect 0,0,@canvas.width,@canvas.height
      stepWidth = @canvas.width / logs.length
      lineDistance = @canvas.height / logs[0].length
      context.lineWidth = 1

      for logIndex in [1..logs.length-1]
        context.beginPath()
        context.strokeStyle = "#eee"
        context.moveTo logIndex * stepWidth, 0
        context.lineTo logIndex * stepWidth, @canvas.height
        context.stroke()

      context.lineWidth = 5

      for logIndex in [0..logs.length-1]
        log = logs[logIndex]
        nextLog = logs[logIndex+1] if logIndex < logs.length-1
        nextLog = logs[logIndex] if logIndex is logs.length-1

        for elementIndex in [0..log.length-1]
          currentElementIndex = log.indexOf(elementIndex)
          nextElementIndex = nextLog.indexOf(elementIndex)

          context.beginPath()
          context.strokeStyle = toFullColorHex(Math.floor(elementIndex / log.length * 255).toString(16))
          context.moveTo logIndex * stepWidth, lineDistance * (currentElementIndex) + (lineDistance / 2)
          context.lineTo (logIndex + 1) * stepWidth, lineDistance * (nextElementIndex) + (lineDistance / 2)
          context.stroke()

      $(".facts .total-steps span", @$el).text logs.length
      return

  $ ->
    view = new SortingView($(".sorting"))

)(jQuery)