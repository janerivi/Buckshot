// Copyright (c) 2012, John Evans
// https://github.com/prujohn/Buckshot
// See LICENSE file for Apache 2.0 licensing information.

//TODO add mouse state template properties

#library('listbox.controls.buckshotui.org');

#import('package:buckshot/buckshot.dart');
#import('package:dartnet_event_model/events.dart');
#import('package:buckshot/web/web.dart');


/**
* A control that provides a scrollable list of selectable items.
*/
class ListBox extends Control implements IFrameworkContainer
{
  FrameworkProperty<bool> horizontalScrollEnabled;
  FrameworkProperty<bool> verticalScrollEnabled;
  FrameworkProperty<Dynamic> selectedItem;
  /// Represents the [Panel] element which will contain the generated UI for
  /// each element of the collection.
  FrameworkProperty<Panel> presentationPanel;

  /// Represents the UI that will display for each item in the collection.
  FrameworkProperty<String> itemsTemplate;

  FrameworkProperty<Color> borderColor;
  FrameworkProperty<Thickness> borderThickness;
  FrameworkProperty<Brush> highlightBrush;
  FrameworkProperty<Brush> selectBrush;

  CollectionPresenter _presenter;
  Border _border;

  int _selectedIndex = -1;

  final FrameworkEvent<SelectedItemChangedEventArgs> selectionChanged =
      new FrameworkEvent<SelectedItemChangedEventArgs>();

  int get selectedIndex => _selectedIndex;

  ListBox()
  {
    Browser.appendClass(rawElement, "listbox");

    _initListBoxProperties();

    //applyVisualTemplate() is called before the constructor
    //so we expect template to be assigned

    _presenter = Template.findByName("__buckshot_listbox_presenter__", template);
    _border = Template.findByName("__buckshot_listbox_border__", template);

    if (_presenter == null)
      throw const BuckshotException('element not found in control template');

    _presenter.itemCreated + _OnItemCreated;

    registerEvent('selectionchanged', selectionChanged);
  }

  ListBox.register() : super.register();
  makeMe() => new ListBox();

  String get defaultControlTemplate {
    return
    '''<controltemplate controlType="${this.templateName}">
          <template>
            <border bordercolor="{template borderColor}" 
                    borderthickness="{template borderThickness}" 
                    horizontalScrollEnabled="{template horizontalScrollEnabled}" 
                    verticalScrollEnabled="{template verticalScrollEnabled}"
                    name="__buckshot_listbox_border__"
                    cursor="Arrow">
                <collectionPresenter name="__buckshot_listbox_presenter__" 
                                      halign='stretch'>
                </collectionPresenter>
            </border>
          </template>
        </controltemplate>
    ''';
  }

  void _OnItemCreated(sender, ItemCreatedEventArgs args){
    FrameworkElement item = args.itemCreated;

    item.click + (_, __) {

      _selectedIndex = _presenter.presentationPanel.value.children.indexOf(item);

      selectedItem.value = item.stateBag[CollectionPresenter.SBO];

      selectionChanged.invoke(this, new SelectedItemChangedEventArgs(item.stateBag[CollectionPresenter.SBO]));

    };

    item.mouseEnter + (_, __) => onItemMouseEnter(item);

    item.mouseLeave + (_, __) => onItemMouseLeave(item);

    item.mouseDown + (_, __) => onItemMouseDown(item);

    item.mouseUp + (_, __) => onItemMouseUp(item);
  }

  get containerContent => template;

  /// Override this method to implement your own mouse over behavior for items in
  /// the ListBox.
  void onItemMouseDown(item){
    if (item.hasProperty("background")){
      item.background.value = selectBrush.value;
    }
  }

  /// Override this method to implement your own mouse over behavior for items in
  /// the ListBox.
  void onItemMouseUp(item){
    if (item.hasProperty("background")){
      item.background.value = highlightBrush.value;
    }
  }

  /// Override this method to implement your own mouse over behavior for items in
  /// the ListBox.
  void onItemMouseEnter(item){
    if (item.hasProperty("background")){
      item.stateBag["__lb_item_bg_brush__"] = item.background.value;
      item.background.value = highlightBrush.value;
    }
  }

  /// Override this method to implement your own mouse out behavior for items in
  /// the ListBox.
  void onItemMouseLeave(item){
    if (item.stateBag.containsKey("__lb_item_bg_brush__")){
      item.background.value = item.stateBag["__lb_item_bg_brush__"];
    }
  }


  void _initListBoxProperties(){

    highlightBrush = new FrameworkProperty(this, "highlightColor", (_){
    }, new SolidColorBrush(new Color.predefined(Colors.PowderBlue)),
    converter:const StringToSolidColorBrushConverter());

    selectBrush = new FrameworkProperty(this, "selectColor", (_){
    }, new SolidColorBrush(new Color.predefined(Colors.SkyBlue)),
    converter:const StringToSolidColorBrushConverter());

    borderColor = new FrameworkProperty(
        this,
        'borderColor',
        propertyChangedCallback: (Color c){
          if (_border == null) return;
          _border.borderColor.value = c;
        },
        defaultValue: new Color.predefined(Colors.Black),
        converter:const StringToColorConverter());


    borderThickness= new FrameworkProperty(this, "borderThickness", (v){
    }, new Thickness(1), converter:const StringToThicknessConverter());

    selectedItem = new FrameworkProperty(this, "selectedItem", (_){});

    presentationPanel = new FrameworkProperty(this, "presentationPanel",
    (Panel p){
      if (_presenter == null) return;
      _presenter.presentationPanel.value = p;
    });

    itemsTemplate = new FrameworkProperty(this, "itemsTemplate", (value){
      if (_presenter == null) return;
      _presenter.itemsTemplate.value = value;
    });

    horizontalScrollEnabled = new FrameworkProperty(this,
        "horizontalScrollEnabled",
        defaultValue:false,
        converter:const StringToBooleanConverter());

    verticalScrollEnabled = new FrameworkProperty(this,
        "verticalScrollEnabled",
        defaultValue:true,
        converter:const StringToBooleanConverter());
  }
}
