class Todo.Models.Item extends Backbone.Model
  paramRoot: 'item'

  defaults:
    title: null
    active: true
    position: 1

  toggle: ->
    this.save({ active: !this.get('active') })

  complete: (completed) ->
    this.save({ active: !completed })

class Todo.Collections.ItemsCollection extends Backbone.Collection
  model: Todo.Models.Item
  url: '/items'

  comparator: (model) ->
    return model.get('position')

  completed: ->
    return @filter (item) ->
      return !item.get('active')

  remaining: ->
    return @without.apply( this, @completed() )
