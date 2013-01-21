Todo.Views.Items ||= {}

class Todo.Views.Items.ItemView extends Backbone.View
  template: JST["backbone/templates/items/item"]

  events:
    "dblclick label":	"edit"
    "blur .edit": "update"
    "submit .item_update": "update"
    "click .destroy" : "destroy"
    'click .toggle':	'toggleActive'
    'drop':	'dropItem'

  initialize: () ->
    @listenTo(@model, 'change', @render)
    @listenTo(@model, 'remove', @remove)
    @listenTo(@model, 'visible', @toggleVisible);

  tagName: "li"

  toggleActive: () ->
    @model.toggle();

  toggleVisible: () =>
    @$el.toggleClass('hidden', @isHidden())

  isHidden: () =>
    isCompleted = !@model.get('active')
    return (!isCompleted && @options.filter == 'completed') || (isCompleted && @options.filter == 'active')

  dropItem: (event, index) ->
    @$el.trigger('update-sort', [@model, index])

  destroy: () ->
    @model.destroy()
    return false

  edit: () ->
    @$el.addClass('editing')
    @$el.find('.edit').focus()

  update: (e) ->
    e.preventDefault()
    e.stopPropagation()

    value = @$el.find('.edit').val().trim()
    if value
      @model.save({ title: value })
    else
      @destroy()

    @$el.removeClass('editing')

  render: ->
    @$el.toggleClass('completed', !@model.get('active'))
    @$el.html(@template(@model.toJSON()))
    return this
