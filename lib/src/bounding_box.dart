// Copyright (c) 2016, SlickTech. All rights reserved. Use of this source code
// is governed by a MIT license that can be found in the LICENSE file.

class BoundingBox {
  double _x;
  double _y;
  double _width;
  double _height;

  BoundingBox(this._x, this._y, this._width, this._height);

  @override
  bool operator ==(rhs) {
    return rhs is BoundingBox &&
        _x == rhs._x &&
        _y == rhs._y &&
        _width == rhs._width &&
        _height == rhs._height;
  }

  @override
  int get hashCode {
    var hash = 17;
    hash = 31 * hash + _x.hashCode;
    hash = 31 * hash + _y.hashCode;
    hash = 31 * hash + _width.hashCode;
    hash = 31 * hash + _height.hashCode;
    return hash;
  }

  @override
  String toString() {
    return 'x: $_x, y: $_y, width: $_width, height: $_height';
  }

  BoundingBox round([int numberOfDecimal = 0]) {
    if (numberOfDecimal == 0) {
      _x = _x.truncate().toDouble();
      _y = _y.truncate().toDouble();
      _width = _width.truncate().toDouble();
      _height = _height.truncate().toDouble();
    } else {
      _x = double.parse(_x.toStringAsFixed(numberOfDecimal));
      _y = double.parse(_y.toStringAsFixed(numberOfDecimal));
      _width = double.parse(_width.toStringAsFixed(numberOfDecimal));
      _height = double.parse(_height.toStringAsFixed(numberOfDecimal));
    }
    return this;
  }

  double get x => _x;
  double get y => _y;
  double get width => _width;
  double get height => _height;
}
