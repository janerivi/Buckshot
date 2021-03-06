// Copyright (c) 2012, John Evans
// https://github.com/prujohn/Buckshot
// See LICENSE file for Apache 2.0 licensing information.

#library('accordion.controls.buckshotui.org');

#import('dart:html');
#import('package:buckshot/buckshot.dart');
#import('package:dartnet_event_model/events.dart');
#import('package:buckshot/web/web.dart');

#source('accordion_item.dart');

class Accordion extends Control implements IFrameworkContainer
{
  FrameworkProperty accordionItemsProperty;
  FrameworkProperty backgroundProperty;
  FrameworkProperty selectionModeProperty;

  var _currentSelected;

  Accordion()
  {
    Browser.appendClass(rawElement, "Accordion");

    _initializeAccordionProperties();

    stateBag[FrameworkObject.CONTAINER_CONTEXT] =
        getValue(accordionItemsProperty);
  }

  Accordion.register() : super.register(){
    registerElement(new AccordionItem.register());
  }
  makeMe() => new Accordion();

  void _initializeAccordionProperties(){
    accordionItemsProperty = new FrameworkProperty(this, 'accordionItems',
        defaultValue: new ObservableList<FrameworkObject>());

    backgroundProperty = new FrameworkProperty(this, 'background',
        defaultValue: new SolidColorBrush(new Color.predefined(Colors.White)),
        converter: const StringToSolidColorBrushConverter());

    selectionModeProperty = new FrameworkProperty(this, 'selectionMode',
        propertyChangedCallback: (_){
          if (!isLoaded) return;
          _invalidate();
        },
        defaultValue: SelectionMode.multi,
        converter: const StringToSelectionModeConverter());
  }

  get content => getValue(accordionItemsProperty);

  SelectionMode get selectionMode => getValue(selectionModeProperty);
  set selectionMode(SelectionMode mode) =>
      setValue(selectionModeProperty, mode);

  ObservableList<FrameworkObject> get accordionItems =>
      getValue(accordionItemsProperty);

  void onFirstLoad(){

    _invalidate();

    // Invalidate on any changes to the list after first load.
    accordionItems.listChanged + (_, __) => _invalidate();

    super.onFirstLoad();

  }

  void _invalidate(){
    if (accordionItems.isEmpty()) return;

    final pc = (Template.findByName('__ac_presenter__', template)
        as CollectionPresenter)
        .presentationPanel
        .children;

    int i = 0;

    pc.forEach((e){
      final ai = accordionItems[i++];

      final header = Template.findByName('__accordion_header__', e);
      final body = Template.findByName('__accordion_body__', e);

      assert(header != null && body != null);

      //TODO Need a better way to handle the event cycle as this will clobber
      // any user hooked events.
      header.click.handlers.clear();

      if (selectionMode == SelectionMode.multi || accordionItems.length == 1){
        body.visibility = ai.visibility;

        header.click + (_, __){
          body.visibility = (body.visibility == null
              || body.visibility == Visibility.visible )
              ? Visibility.collapsed
                  : Visibility.visible;
        };
      }else{
        // first item visible if nothing selected
        if (_currentSelected == null && pc.indexOf(e) == 0){
          _currentSelected = header;
          body.visibility = Visibility.visible;
        }else{
          if (header == _currentSelected){
            body.visibility = Visibility.visible;
          }else{
            body.visibility = Visibility.collapsed;
          }
        }

        header.click + (_, __){
          _currentSelected = header;
          _invalidate();
        };
      }
    });
  }

  String get defaultControlTemplate {
    return
'''
<controltemplate controlType='${this.templateName}'>
  <template>
    <border background='{template background}' valign='{template vAlign}' 
            halign='{template hAlign}' height='{template height}' 
            width='{template width}'
            cursor='Arrow'>
      <collectionpresenter halign='stretch' name='__ac_presenter__' collection='{template accordionItems}'>
         <itemstemplate>
            <stack halign='stretch'>
              $headerTemplate
              $bodyTemplate
            </stack>
         </itemstemplate>
      </collectionpresenter>
    </border>
  </template>
</controltemplate>
''';
  }

  /**
   * Override this template if you want to customize the look and feel of the
   * Accordion header.
   */
  String get headerTemplate =>
'''
 <border name='__accordion_header__' 
         padding='{resource theme_border_padding}' 
         borderthickness='{resource theme_accordion_header_border_thickness}' 
         bordercolor='{resource theme_border_color}' 
         background='{resource theme_accordion_header_background_brush}' 
         halign='stretch'>
    <actions>
      <setproperty event='mouseEnter' property='background' value='{resource theme_accordion_background_hover_brush}' />
      <setproperty event='mouseLeave' property='background' value='{resource theme_accordion_header_background_brush}' />
      <setproperty event='mouseDown' property='background' value='{resource theme_accordion_background_mouse_down_brush}' />
      <setproperty event='mouseUp' property='background' value='{resource theme_accordion_background_hover_brush}' />
    </actions>
    <contentpresenter halign='stretch' content='{data header}' />                   
 </border>
''';

  /**
   * Override this template if you want to customize the look and feel of the
   * Accordion body.
   */
  String get bodyTemplate =>
'''
 <border name='__accordion_body__' halign='stretch' background='{resource theme_accordion_body_background_brush}'>
   <contentpresenter halign='stretch' content='{data body}' />
 </border>
''';

}

class SelectionMode
{
  final _str;

  const SelectionMode(this._str);

  static const single = const SelectionMode('single');
  static const multi = const SelectionMode('multi');
}

class StringToSelectionModeConverter implements IValueConverter
{

  const StringToSelectionModeConverter();

  Dynamic convert(Dynamic value, [Dynamic parameter]){
    if (!(value is String)) return value;

    switch(value){
      case "single":
        return SelectionMode.single;
      case "multi":
        return SelectionMode.multi;
      default:
        throw const BuckshotException("Invalid SelectionMode value.");
      }
  }
}

