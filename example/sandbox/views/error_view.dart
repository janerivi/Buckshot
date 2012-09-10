// Copyright (c) 2012, John Evans
// https://github.com/prujohn/Buckshot
// See LICENSE file for Apache 2.0 licensing information.

class ErrorView extends View
{
  ErrorView() : super.fromResource('#error')
  {
    ready.then((t){
      rootVisual = t;
    });
  }
}
