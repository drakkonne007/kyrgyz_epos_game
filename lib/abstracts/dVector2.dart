// Copyright (c) 2015, Google Inc. Please see the AUTHORS file for details.
// All rights reserved. Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.


import 'dart:typed_data';
import 'dart:math' as math;

import 'package:flame/components.dart';


class dVector2
{
  Float64x2 _v2storage;

  set x(double v){
    _v2storage = _v2storage.withX(v);
  }

  set y(double v){
    _v2storage = _v2storage.withY(v);
  }

  double get x => _v2storage.x;
  double get y => _v2storage.y;
  /// The components of the vector.
  List<double> get storage => <double>[_v2storage.x, _v2storage.y];

  /// Construct a new vector with the specified values.
  factory dVector2(double x, double y) => dVector2.zero()..setValues(x, y);

  /// Zero vector.
  dVector2.zero() : _v2storage = Float64x2(0,0);

  /// Splat [value] into all lanes of the vector.
  factory dVector2.all(double value) => dVector2.zero()..splat(value);

  /// Copy of [other].
  factory dVector2.copy(dVector2 other) => dVector2.zero()..setFrom(other);

  /// Constructs dVector2 with a given [Float64List] as [storage].

  /// Constructs dVector2 with a [storage] that views given [buffer] starting at
  /// [offset]. [offset] has to be multiple of [Float64List.bytesPerElement].

  /// Generate random vector in the range (0, 0) to (1, 1). You can
  /// optionally pass your own random number generator.
  factory dVector2.random([math.Random? rng]) {
    rng ??= math.Random();
    return dVector2(rng.nextDouble(), rng.nextDouble());
  }

  /// Set the values of the vector.
  void setValues(double x_, double y_) {
    _v2storage = Float64x2(x_, y_);
  }

  /// Zero the vector.
  void setZero() {
    _v2storage = Float64x2(0, 0);
  }

  /// Set the values by copying them from [other].
  void setFrom(dVector2 other) {
    final otherStorage = other._v2storage;
    _v2storage = otherStorage;
  }

  /// Splat [arg] into all lanes of the vector.
  void splat(double arg) {
    _v2storage = Float64x2(arg, arg);
  }

  /// Returns a printable string
  @override
  String toString() => '[$_v2storage]';

  dVector2 operator +(Object object)
  {
    if(object is Vector2){
      return dVector2(
          _v2storage.x + object.x, _v2storage.y + object.y);
    }else if(object is dVector2) {
      return dVector2(
          _v2storage.x + object.x, _v2storage.y + object.y);
    }
    throw UnsupportedError('unsupported operand type');
  }

  dVector2 operator -(Object object)
  {
    if(object is Vector2){
      return dVector2(
          _v2storage.x - object.x, _v2storage.y - object.y);
    }else if(object is dVector2) {
      return dVector2(
          _v2storage.x - object.x, _v2storage.y - object.y);
    }
    throw UnsupportedError('unsupported operand type');
  }

  Vector2 toVector2(){
    return Vector2(_v2storage.x, _v2storage.y);
  }

  dVector2 operator *(Object object)
  {
    if(object is Vector2){
      return dVector2(
          _v2storage.x * object.x, _v2storage.y * object.y);
    }else if(object is dVector2) {
      return dVector2(
          _v2storage.x * object.x, _v2storage.y * object.y);
    }else if(object is double) {
      return dVector2(_v2storage.x * object, _v2storage.y * object);
    }else if(object is int) {
      return dVector2(_v2storage.x * object, _v2storage.y * object);
    }
    throw UnsupportedError('unsupported operand type');
  }

  dVector2 operator /(Object object)
  {
    if(object is dVector2) {
      final otherStorage = object._v2storage;
      return dVector2(
          _v2storage.x / otherStorage.x, _v2storage.y / otherStorage.y);
    }else if(object is double) {
      return dVector2(_v2storage.x / object, _v2storage.y / object);
    }else if(object is int) {
      return dVector2(_v2storage.x / object, _v2storage.y / object);
    }
    throw UnsupportedError('unsupported operand type');
  }

  // dVector2 operator /(double other)
  // {
  //   final otherStorage = _v2storage;
  //   return dVector2(otherStorage.x / other, otherStorage.x / other);
  // }

  /// Check if two vectors are the same.
  @override
  bool operator ==(Object other) =>
      (other is dVector2) &&
          _v2storage == other._v2storage;

  @override
  int get hashCode => Object.hashAll([_v2storage.x, _v2storage.y]);

  double distanceTo(dVector2 arg) => math.sqrt(distanceToSquared(arg));

  /// Squared distance from this to [arg]
  double distanceToSquared(dVector2 arg) {
    final dx = x - arg.x;
    final dy = y - arg.y;

    return dx * dx + dy * dy;
  }
}
