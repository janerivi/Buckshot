//   Copyright (c) 2012, John Evans & LUCA Studios LLC
//
//   http://www.lucastudios.com/contact
//   John: https://plus.google.com/u/0/115427174005651655317/about
//
//   Licensed under the Apache License, Version 2.0 (the "License");
//   you may not use this file except in compliance with the License.
//   You may obtain a copy of the License at
//
//       http://www.apache.org/licenses/LICENSE-2.0
//
//   Unless required by applicable law or agreed to in writing, software
//   distributed under the License is distributed on an "AS IS" BASIS,
//   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//   See the License for the specific language governing permissions and
//   limitations under the License.


class FrameworkAnimation
{
  FrameworkAnimation(){
    document.head.elements.add(new Element.html('<style id="__BuckshotStyle__">.luca_ui_textblock {font-size:30px;}</style>'));
  }
  
  static String _createXP(String declaration){
    if (!declaration.endsWith(';')) declaration += ';';
    
    StringBuffer s = new StringBuffer();
    s.add('-webkit-$declaration');
    s.add('-moz-$declaration');
    s.add('-o-$declaration');
    s.add('-ie-$declaration');
    s.add('declaration');
    return s.toString();
  }
}

aTest(){
  document.head.elements.add(new Element.html('<style id="__BuckshotStyle__">.luca_ui_textblock {font-size:30px;}</style>'));
  StyleElement test = document.head.query('#__BuckshotStyle__');
  test.innerHTML = ".luca_ui_textblock {font-size:10px;}";
  //document.head.elements.add(new Element.html('<style>.luca_ui_textblock {font-size:10px;}</style>'));
   //new CSSStyleDeclaration.css(".luca_ui_textblock {font-size:30px}");
}