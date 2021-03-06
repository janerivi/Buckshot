
class AccordionItem extends Control implements IFrameworkContainer
{
  FrameworkProperty headerProperty;
  FrameworkProperty bodyProperty;

  AccordionItem()
  {
    Browser.appendClass(rawElement, "AccordionItem");

    _initAccordionItemProperties();

    stateBag[FrameworkObject.CONTAINER_CONTEXT] = bodyProperty;
  }

  AccordionItem.register() : super.register();
  makeMe() => new AccordionItem();

  get content => getValue(bodyProperty);

  void _initAccordionItemProperties(){
    headerProperty = new FrameworkProperty(this, 'header');
    bodyProperty = new FrameworkProperty(this, 'body');
  }

  get header => getValue(headerProperty);
  set header(value) => setValue(headerProperty, value);

  get body => getValue(bodyProperty);
  set body(value) => setValue(bodyProperty, value);

}
