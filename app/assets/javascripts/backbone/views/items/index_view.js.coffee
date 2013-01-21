Todo.Views.Items ||= {}

class Todo.Views.Items.IndexView extends Backbone.View
  template: JST["backbone/templates/items/index"]
  statsTemplate: JST["backbone/templates/items/stats"]

  events:
    "click #clear-completed": "clearCompleted"
    "click #toggle-all": "toggleAllComplete"
    "submit #new-item": "save"
    "update-sort": "updateSort"

  initialize: () ->
    @collection.on('reset', @addAll, this)
    @collection.on('add', @addOne, this)
    @collection.on({ 'add' : @updateStats, 'remove' : @updateStats, 'change' : @updateStats }, this)
    @collection.on('filter', @filterAll, this);

  updateStats: () =>
    remaining = @collection.remaining().length
    completed = @collection.completed().length
    @$('#footer').html(@statsTemplate(remaining: remaining, completed: completed))
    @$('#filters li a').removeClass('selected').filter('[href="#/' + ( @options.filter || '' ) + '"]').addClass('selected')

  updateSort: (event, model, position) ->
    model.save({ position: position })
    @collection.remove(model)
    @collection.each((model_item, index) ->
      ordinal = index
      if (index >= position)
        ordinal += 1
      model_item.save({ position: ordinal })
    )
    @collection.add(model, {at: position})
    @render()

  filterAll: () =>
    @collection.each(@filterOne, this);

  filterOne: (item) =>
    item.trigger('visible');

  addAll: () =>
    @collection.each(@addOne)
    @$("#todo-list").sortable({
      placeholder: "placeholder"
    })
    @$("#todo-list").on("sortstop", (event, ui) ->
      ui.item.trigger('drop', ui.item.index())
    )

  addOne: (item) =>
    view = new Todo.Views.Items.ItemView({model : item, filter: @options.filter})
    @$("ul#todo-list").append(view.render().el)

  clearCompleted: ->
    _.invoke(@collection.completed(), 'destroy');

  toggleAllComplete: ->
    completed = this.$('#toggle-all').is(':checked')
    _(@collection.models).each (item) -> item.complete(completed)

  save: (e) ->
    e.preventDefault()
    e.stopPropagation()

    @model = new @collection.model()
    @model.set("title", $('#new-todo').val())

    @collection.create(@model.toJSON(),
      wait: true
      success: (item) =>
        @model = item
        $('#new-item')[0].reset()

      error: (item, jqXHR) =>
        @model.set({errors: $.parseJSON(jqXHR.responseText)})
    )

  render: =>
    @$el.html(@template(items: @collection.toJSON()))
    @addAll()
    @updateStats()

    return this
