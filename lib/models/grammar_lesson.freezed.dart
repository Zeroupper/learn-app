// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'grammar_lesson.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$GrammarExample {

 String get en; String get hu;
/// Create a copy of GrammarExample
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$GrammarExampleCopyWith<GrammarExample> get copyWith => _$GrammarExampleCopyWithImpl<GrammarExample>(this as GrammarExample, _$identity);

  /// Serializes this GrammarExample to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is GrammarExample&&(identical(other.en, en) || other.en == en)&&(identical(other.hu, hu) || other.hu == hu));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,en,hu);

@override
String toString() {
  return 'GrammarExample(en: $en, hu: $hu)';
}


}

/// @nodoc
abstract mixin class $GrammarExampleCopyWith<$Res>  {
  factory $GrammarExampleCopyWith(GrammarExample value, $Res Function(GrammarExample) _then) = _$GrammarExampleCopyWithImpl;
@useResult
$Res call({
 String en, String hu
});




}
/// @nodoc
class _$GrammarExampleCopyWithImpl<$Res>
    implements $GrammarExampleCopyWith<$Res> {
  _$GrammarExampleCopyWithImpl(this._self, this._then);

  final GrammarExample _self;
  final $Res Function(GrammarExample) _then;

/// Create a copy of GrammarExample
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? en = null,Object? hu = null,}) {
  return _then(_self.copyWith(
en: null == en ? _self.en : en // ignore: cast_nullable_to_non_nullable
as String,hu: null == hu ? _self.hu : hu // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [GrammarExample].
extension GrammarExamplePatterns on GrammarExample {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _GrammarExample value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _GrammarExample() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _GrammarExample value)  $default,){
final _that = this;
switch (_that) {
case _GrammarExample():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _GrammarExample value)?  $default,){
final _that = this;
switch (_that) {
case _GrammarExample() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String en,  String hu)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _GrammarExample() when $default != null:
return $default(_that.en,_that.hu);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String en,  String hu)  $default,) {final _that = this;
switch (_that) {
case _GrammarExample():
return $default(_that.en,_that.hu);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String en,  String hu)?  $default,) {final _that = this;
switch (_that) {
case _GrammarExample() when $default != null:
return $default(_that.en,_that.hu);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _GrammarExample implements GrammarExample {
  const _GrammarExample({required this.en, required this.hu});
  factory _GrammarExample.fromJson(Map<String, dynamic> json) => _$GrammarExampleFromJson(json);

@override final  String en;
@override final  String hu;

/// Create a copy of GrammarExample
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$GrammarExampleCopyWith<_GrammarExample> get copyWith => __$GrammarExampleCopyWithImpl<_GrammarExample>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$GrammarExampleToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _GrammarExample&&(identical(other.en, en) || other.en == en)&&(identical(other.hu, hu) || other.hu == hu));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,en,hu);

@override
String toString() {
  return 'GrammarExample(en: $en, hu: $hu)';
}


}

/// @nodoc
abstract mixin class _$GrammarExampleCopyWith<$Res> implements $GrammarExampleCopyWith<$Res> {
  factory _$GrammarExampleCopyWith(_GrammarExample value, $Res Function(_GrammarExample) _then) = __$GrammarExampleCopyWithImpl;
@override @useResult
$Res call({
 String en, String hu
});




}
/// @nodoc
class __$GrammarExampleCopyWithImpl<$Res>
    implements _$GrammarExampleCopyWith<$Res> {
  __$GrammarExampleCopyWithImpl(this._self, this._then);

  final _GrammarExample _self;
  final $Res Function(_GrammarExample) _then;

/// Create a copy of GrammarExample
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? en = null,Object? hu = null,}) {
  return _then(_GrammarExample(
en: null == en ? _self.en : en // ignore: cast_nullable_to_non_nullable
as String,hu: null == hu ? _self.hu : hu // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}


/// @nodoc
mixin _$GrammarSection {

 String get headingHu; String get bodyHu; List<GrammarExample> get examples;
/// Create a copy of GrammarSection
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$GrammarSectionCopyWith<GrammarSection> get copyWith => _$GrammarSectionCopyWithImpl<GrammarSection>(this as GrammarSection, _$identity);

  /// Serializes this GrammarSection to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is GrammarSection&&(identical(other.headingHu, headingHu) || other.headingHu == headingHu)&&(identical(other.bodyHu, bodyHu) || other.bodyHu == bodyHu)&&const DeepCollectionEquality().equals(other.examples, examples));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,headingHu,bodyHu,const DeepCollectionEquality().hash(examples));

@override
String toString() {
  return 'GrammarSection(headingHu: $headingHu, bodyHu: $bodyHu, examples: $examples)';
}


}

/// @nodoc
abstract mixin class $GrammarSectionCopyWith<$Res>  {
  factory $GrammarSectionCopyWith(GrammarSection value, $Res Function(GrammarSection) _then) = _$GrammarSectionCopyWithImpl;
@useResult
$Res call({
 String headingHu, String bodyHu, List<GrammarExample> examples
});




}
/// @nodoc
class _$GrammarSectionCopyWithImpl<$Res>
    implements $GrammarSectionCopyWith<$Res> {
  _$GrammarSectionCopyWithImpl(this._self, this._then);

  final GrammarSection _self;
  final $Res Function(GrammarSection) _then;

/// Create a copy of GrammarSection
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? headingHu = null,Object? bodyHu = null,Object? examples = null,}) {
  return _then(_self.copyWith(
headingHu: null == headingHu ? _self.headingHu : headingHu // ignore: cast_nullable_to_non_nullable
as String,bodyHu: null == bodyHu ? _self.bodyHu : bodyHu // ignore: cast_nullable_to_non_nullable
as String,examples: null == examples ? _self.examples : examples // ignore: cast_nullable_to_non_nullable
as List<GrammarExample>,
  ));
}

}


/// Adds pattern-matching-related methods to [GrammarSection].
extension GrammarSectionPatterns on GrammarSection {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _GrammarSection value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _GrammarSection() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _GrammarSection value)  $default,){
final _that = this;
switch (_that) {
case _GrammarSection():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _GrammarSection value)?  $default,){
final _that = this;
switch (_that) {
case _GrammarSection() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String headingHu,  String bodyHu,  List<GrammarExample> examples)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _GrammarSection() when $default != null:
return $default(_that.headingHu,_that.bodyHu,_that.examples);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String headingHu,  String bodyHu,  List<GrammarExample> examples)  $default,) {final _that = this;
switch (_that) {
case _GrammarSection():
return $default(_that.headingHu,_that.bodyHu,_that.examples);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String headingHu,  String bodyHu,  List<GrammarExample> examples)?  $default,) {final _that = this;
switch (_that) {
case _GrammarSection() when $default != null:
return $default(_that.headingHu,_that.bodyHu,_that.examples);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _GrammarSection implements GrammarSection {
  const _GrammarSection({required this.headingHu, required this.bodyHu, final  List<GrammarExample> examples = const <GrammarExample>[]}): _examples = examples;
  factory _GrammarSection.fromJson(Map<String, dynamic> json) => _$GrammarSectionFromJson(json);

@override final  String headingHu;
@override final  String bodyHu;
 final  List<GrammarExample> _examples;
@override@JsonKey() List<GrammarExample> get examples {
  if (_examples is EqualUnmodifiableListView) return _examples;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_examples);
}


/// Create a copy of GrammarSection
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$GrammarSectionCopyWith<_GrammarSection> get copyWith => __$GrammarSectionCopyWithImpl<_GrammarSection>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$GrammarSectionToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _GrammarSection&&(identical(other.headingHu, headingHu) || other.headingHu == headingHu)&&(identical(other.bodyHu, bodyHu) || other.bodyHu == bodyHu)&&const DeepCollectionEquality().equals(other._examples, _examples));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,headingHu,bodyHu,const DeepCollectionEquality().hash(_examples));

@override
String toString() {
  return 'GrammarSection(headingHu: $headingHu, bodyHu: $bodyHu, examples: $examples)';
}


}

/// @nodoc
abstract mixin class _$GrammarSectionCopyWith<$Res> implements $GrammarSectionCopyWith<$Res> {
  factory _$GrammarSectionCopyWith(_GrammarSection value, $Res Function(_GrammarSection) _then) = __$GrammarSectionCopyWithImpl;
@override @useResult
$Res call({
 String headingHu, String bodyHu, List<GrammarExample> examples
});




}
/// @nodoc
class __$GrammarSectionCopyWithImpl<$Res>
    implements _$GrammarSectionCopyWith<$Res> {
  __$GrammarSectionCopyWithImpl(this._self, this._then);

  final _GrammarSection _self;
  final $Res Function(_GrammarSection) _then;

/// Create a copy of GrammarSection
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? headingHu = null,Object? bodyHu = null,Object? examples = null,}) {
  return _then(_GrammarSection(
headingHu: null == headingHu ? _self.headingHu : headingHu // ignore: cast_nullable_to_non_nullable
as String,bodyHu: null == bodyHu ? _self.bodyHu : bodyHu // ignore: cast_nullable_to_non_nullable
as String,examples: null == examples ? _self._examples : examples // ignore: cast_nullable_to_non_nullable
as List<GrammarExample>,
  ));
}


}


/// @nodoc
mixin _$GrammarExercise {

 String get promptHu; List<String> get options; int get correctIndex; String get explanationHu;
/// Create a copy of GrammarExercise
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$GrammarExerciseCopyWith<GrammarExercise> get copyWith => _$GrammarExerciseCopyWithImpl<GrammarExercise>(this as GrammarExercise, _$identity);

  /// Serializes this GrammarExercise to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is GrammarExercise&&(identical(other.promptHu, promptHu) || other.promptHu == promptHu)&&const DeepCollectionEquality().equals(other.options, options)&&(identical(other.correctIndex, correctIndex) || other.correctIndex == correctIndex)&&(identical(other.explanationHu, explanationHu) || other.explanationHu == explanationHu));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,promptHu,const DeepCollectionEquality().hash(options),correctIndex,explanationHu);

@override
String toString() {
  return 'GrammarExercise(promptHu: $promptHu, options: $options, correctIndex: $correctIndex, explanationHu: $explanationHu)';
}


}

/// @nodoc
abstract mixin class $GrammarExerciseCopyWith<$Res>  {
  factory $GrammarExerciseCopyWith(GrammarExercise value, $Res Function(GrammarExercise) _then) = _$GrammarExerciseCopyWithImpl;
@useResult
$Res call({
 String promptHu, List<String> options, int correctIndex, String explanationHu
});




}
/// @nodoc
class _$GrammarExerciseCopyWithImpl<$Res>
    implements $GrammarExerciseCopyWith<$Res> {
  _$GrammarExerciseCopyWithImpl(this._self, this._then);

  final GrammarExercise _self;
  final $Res Function(GrammarExercise) _then;

/// Create a copy of GrammarExercise
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? promptHu = null,Object? options = null,Object? correctIndex = null,Object? explanationHu = null,}) {
  return _then(_self.copyWith(
promptHu: null == promptHu ? _self.promptHu : promptHu // ignore: cast_nullable_to_non_nullable
as String,options: null == options ? _self.options : options // ignore: cast_nullable_to_non_nullable
as List<String>,correctIndex: null == correctIndex ? _self.correctIndex : correctIndex // ignore: cast_nullable_to_non_nullable
as int,explanationHu: null == explanationHu ? _self.explanationHu : explanationHu // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [GrammarExercise].
extension GrammarExercisePatterns on GrammarExercise {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _GrammarExercise value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _GrammarExercise() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _GrammarExercise value)  $default,){
final _that = this;
switch (_that) {
case _GrammarExercise():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _GrammarExercise value)?  $default,){
final _that = this;
switch (_that) {
case _GrammarExercise() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String promptHu,  List<String> options,  int correctIndex,  String explanationHu)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _GrammarExercise() when $default != null:
return $default(_that.promptHu,_that.options,_that.correctIndex,_that.explanationHu);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String promptHu,  List<String> options,  int correctIndex,  String explanationHu)  $default,) {final _that = this;
switch (_that) {
case _GrammarExercise():
return $default(_that.promptHu,_that.options,_that.correctIndex,_that.explanationHu);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String promptHu,  List<String> options,  int correctIndex,  String explanationHu)?  $default,) {final _that = this;
switch (_that) {
case _GrammarExercise() when $default != null:
return $default(_that.promptHu,_that.options,_that.correctIndex,_that.explanationHu);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _GrammarExercise implements GrammarExercise {
  const _GrammarExercise({required this.promptHu, required final  List<String> options, required this.correctIndex, required this.explanationHu}): _options = options;
  factory _GrammarExercise.fromJson(Map<String, dynamic> json) => _$GrammarExerciseFromJson(json);

@override final  String promptHu;
 final  List<String> _options;
@override List<String> get options {
  if (_options is EqualUnmodifiableListView) return _options;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_options);
}

@override final  int correctIndex;
@override final  String explanationHu;

/// Create a copy of GrammarExercise
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$GrammarExerciseCopyWith<_GrammarExercise> get copyWith => __$GrammarExerciseCopyWithImpl<_GrammarExercise>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$GrammarExerciseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _GrammarExercise&&(identical(other.promptHu, promptHu) || other.promptHu == promptHu)&&const DeepCollectionEquality().equals(other._options, _options)&&(identical(other.correctIndex, correctIndex) || other.correctIndex == correctIndex)&&(identical(other.explanationHu, explanationHu) || other.explanationHu == explanationHu));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,promptHu,const DeepCollectionEquality().hash(_options),correctIndex,explanationHu);

@override
String toString() {
  return 'GrammarExercise(promptHu: $promptHu, options: $options, correctIndex: $correctIndex, explanationHu: $explanationHu)';
}


}

/// @nodoc
abstract mixin class _$GrammarExerciseCopyWith<$Res> implements $GrammarExerciseCopyWith<$Res> {
  factory _$GrammarExerciseCopyWith(_GrammarExercise value, $Res Function(_GrammarExercise) _then) = __$GrammarExerciseCopyWithImpl;
@override @useResult
$Res call({
 String promptHu, List<String> options, int correctIndex, String explanationHu
});




}
/// @nodoc
class __$GrammarExerciseCopyWithImpl<$Res>
    implements _$GrammarExerciseCopyWith<$Res> {
  __$GrammarExerciseCopyWithImpl(this._self, this._then);

  final _GrammarExercise _self;
  final $Res Function(_GrammarExercise) _then;

/// Create a copy of GrammarExercise
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? promptHu = null,Object? options = null,Object? correctIndex = null,Object? explanationHu = null,}) {
  return _then(_GrammarExercise(
promptHu: null == promptHu ? _self.promptHu : promptHu // ignore: cast_nullable_to_non_nullable
as String,options: null == options ? _self._options : options // ignore: cast_nullable_to_non_nullable
as List<String>,correctIndex: null == correctIndex ? _self.correctIndex : correctIndex // ignore: cast_nullable_to_non_nullable
as int,explanationHu: null == explanationHu ? _self.explanationHu : explanationHu // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}


/// @nodoc
mixin _$GrammarLessonMeta {

 String get id; String get file; String get titleHu; String get subtitleHu; CefrLevel get level;
/// Create a copy of GrammarLessonMeta
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$GrammarLessonMetaCopyWith<GrammarLessonMeta> get copyWith => _$GrammarLessonMetaCopyWithImpl<GrammarLessonMeta>(this as GrammarLessonMeta, _$identity);

  /// Serializes this GrammarLessonMeta to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is GrammarLessonMeta&&(identical(other.id, id) || other.id == id)&&(identical(other.file, file) || other.file == file)&&(identical(other.titleHu, titleHu) || other.titleHu == titleHu)&&(identical(other.subtitleHu, subtitleHu) || other.subtitleHu == subtitleHu)&&(identical(other.level, level) || other.level == level));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,file,titleHu,subtitleHu,level);

@override
String toString() {
  return 'GrammarLessonMeta(id: $id, file: $file, titleHu: $titleHu, subtitleHu: $subtitleHu, level: $level)';
}


}

/// @nodoc
abstract mixin class $GrammarLessonMetaCopyWith<$Res>  {
  factory $GrammarLessonMetaCopyWith(GrammarLessonMeta value, $Res Function(GrammarLessonMeta) _then) = _$GrammarLessonMetaCopyWithImpl;
@useResult
$Res call({
 String id, String file, String titleHu, String subtitleHu, CefrLevel level
});




}
/// @nodoc
class _$GrammarLessonMetaCopyWithImpl<$Res>
    implements $GrammarLessonMetaCopyWith<$Res> {
  _$GrammarLessonMetaCopyWithImpl(this._self, this._then);

  final GrammarLessonMeta _self;
  final $Res Function(GrammarLessonMeta) _then;

/// Create a copy of GrammarLessonMeta
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? file = null,Object? titleHu = null,Object? subtitleHu = null,Object? level = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,file: null == file ? _self.file : file // ignore: cast_nullable_to_non_nullable
as String,titleHu: null == titleHu ? _self.titleHu : titleHu // ignore: cast_nullable_to_non_nullable
as String,subtitleHu: null == subtitleHu ? _self.subtitleHu : subtitleHu // ignore: cast_nullable_to_non_nullable
as String,level: null == level ? _self.level : level // ignore: cast_nullable_to_non_nullable
as CefrLevel,
  ));
}

}


/// Adds pattern-matching-related methods to [GrammarLessonMeta].
extension GrammarLessonMetaPatterns on GrammarLessonMeta {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _GrammarLessonMeta value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _GrammarLessonMeta() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _GrammarLessonMeta value)  $default,){
final _that = this;
switch (_that) {
case _GrammarLessonMeta():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _GrammarLessonMeta value)?  $default,){
final _that = this;
switch (_that) {
case _GrammarLessonMeta() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String file,  String titleHu,  String subtitleHu,  CefrLevel level)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _GrammarLessonMeta() when $default != null:
return $default(_that.id,_that.file,_that.titleHu,_that.subtitleHu,_that.level);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String file,  String titleHu,  String subtitleHu,  CefrLevel level)  $default,) {final _that = this;
switch (_that) {
case _GrammarLessonMeta():
return $default(_that.id,_that.file,_that.titleHu,_that.subtitleHu,_that.level);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String file,  String titleHu,  String subtitleHu,  CefrLevel level)?  $default,) {final _that = this;
switch (_that) {
case _GrammarLessonMeta() when $default != null:
return $default(_that.id,_that.file,_that.titleHu,_that.subtitleHu,_that.level);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _GrammarLessonMeta implements GrammarLessonMeta {
  const _GrammarLessonMeta({required this.id, required this.file, required this.titleHu, required this.subtitleHu, required this.level});
  factory _GrammarLessonMeta.fromJson(Map<String, dynamic> json) => _$GrammarLessonMetaFromJson(json);

@override final  String id;
@override final  String file;
@override final  String titleHu;
@override final  String subtitleHu;
@override final  CefrLevel level;

/// Create a copy of GrammarLessonMeta
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$GrammarLessonMetaCopyWith<_GrammarLessonMeta> get copyWith => __$GrammarLessonMetaCopyWithImpl<_GrammarLessonMeta>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$GrammarLessonMetaToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _GrammarLessonMeta&&(identical(other.id, id) || other.id == id)&&(identical(other.file, file) || other.file == file)&&(identical(other.titleHu, titleHu) || other.titleHu == titleHu)&&(identical(other.subtitleHu, subtitleHu) || other.subtitleHu == subtitleHu)&&(identical(other.level, level) || other.level == level));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,file,titleHu,subtitleHu,level);

@override
String toString() {
  return 'GrammarLessonMeta(id: $id, file: $file, titleHu: $titleHu, subtitleHu: $subtitleHu, level: $level)';
}


}

/// @nodoc
abstract mixin class _$GrammarLessonMetaCopyWith<$Res> implements $GrammarLessonMetaCopyWith<$Res> {
  factory _$GrammarLessonMetaCopyWith(_GrammarLessonMeta value, $Res Function(_GrammarLessonMeta) _then) = __$GrammarLessonMetaCopyWithImpl;
@override @useResult
$Res call({
 String id, String file, String titleHu, String subtitleHu, CefrLevel level
});




}
/// @nodoc
class __$GrammarLessonMetaCopyWithImpl<$Res>
    implements _$GrammarLessonMetaCopyWith<$Res> {
  __$GrammarLessonMetaCopyWithImpl(this._self, this._then);

  final _GrammarLessonMeta _self;
  final $Res Function(_GrammarLessonMeta) _then;

/// Create a copy of GrammarLessonMeta
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? file = null,Object? titleHu = null,Object? subtitleHu = null,Object? level = null,}) {
  return _then(_GrammarLessonMeta(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,file: null == file ? _self.file : file // ignore: cast_nullable_to_non_nullable
as String,titleHu: null == titleHu ? _self.titleHu : titleHu // ignore: cast_nullable_to_non_nullable
as String,subtitleHu: null == subtitleHu ? _self.subtitleHu : subtitleHu // ignore: cast_nullable_to_non_nullable
as String,level: null == level ? _self.level : level // ignore: cast_nullable_to_non_nullable
as CefrLevel,
  ));
}


}


/// @nodoc
mixin _$GrammarLesson {

 String get id; String get titleHu; String get subtitleHu; CefrLevel get level; List<GrammarSection> get sections; List<GrammarExercise> get exercises;
/// Create a copy of GrammarLesson
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$GrammarLessonCopyWith<GrammarLesson> get copyWith => _$GrammarLessonCopyWithImpl<GrammarLesson>(this as GrammarLesson, _$identity);

  /// Serializes this GrammarLesson to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is GrammarLesson&&(identical(other.id, id) || other.id == id)&&(identical(other.titleHu, titleHu) || other.titleHu == titleHu)&&(identical(other.subtitleHu, subtitleHu) || other.subtitleHu == subtitleHu)&&(identical(other.level, level) || other.level == level)&&const DeepCollectionEquality().equals(other.sections, sections)&&const DeepCollectionEquality().equals(other.exercises, exercises));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,titleHu,subtitleHu,level,const DeepCollectionEquality().hash(sections),const DeepCollectionEquality().hash(exercises));

@override
String toString() {
  return 'GrammarLesson(id: $id, titleHu: $titleHu, subtitleHu: $subtitleHu, level: $level, sections: $sections, exercises: $exercises)';
}


}

/// @nodoc
abstract mixin class $GrammarLessonCopyWith<$Res>  {
  factory $GrammarLessonCopyWith(GrammarLesson value, $Res Function(GrammarLesson) _then) = _$GrammarLessonCopyWithImpl;
@useResult
$Res call({
 String id, String titleHu, String subtitleHu, CefrLevel level, List<GrammarSection> sections, List<GrammarExercise> exercises
});




}
/// @nodoc
class _$GrammarLessonCopyWithImpl<$Res>
    implements $GrammarLessonCopyWith<$Res> {
  _$GrammarLessonCopyWithImpl(this._self, this._then);

  final GrammarLesson _self;
  final $Res Function(GrammarLesson) _then;

/// Create a copy of GrammarLesson
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? titleHu = null,Object? subtitleHu = null,Object? level = null,Object? sections = null,Object? exercises = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,titleHu: null == titleHu ? _self.titleHu : titleHu // ignore: cast_nullable_to_non_nullable
as String,subtitleHu: null == subtitleHu ? _self.subtitleHu : subtitleHu // ignore: cast_nullable_to_non_nullable
as String,level: null == level ? _self.level : level // ignore: cast_nullable_to_non_nullable
as CefrLevel,sections: null == sections ? _self.sections : sections // ignore: cast_nullable_to_non_nullable
as List<GrammarSection>,exercises: null == exercises ? _self.exercises : exercises // ignore: cast_nullable_to_non_nullable
as List<GrammarExercise>,
  ));
}

}


/// Adds pattern-matching-related methods to [GrammarLesson].
extension GrammarLessonPatterns on GrammarLesson {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _GrammarLesson value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _GrammarLesson() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _GrammarLesson value)  $default,){
final _that = this;
switch (_that) {
case _GrammarLesson():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _GrammarLesson value)?  $default,){
final _that = this;
switch (_that) {
case _GrammarLesson() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String titleHu,  String subtitleHu,  CefrLevel level,  List<GrammarSection> sections,  List<GrammarExercise> exercises)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _GrammarLesson() when $default != null:
return $default(_that.id,_that.titleHu,_that.subtitleHu,_that.level,_that.sections,_that.exercises);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String titleHu,  String subtitleHu,  CefrLevel level,  List<GrammarSection> sections,  List<GrammarExercise> exercises)  $default,) {final _that = this;
switch (_that) {
case _GrammarLesson():
return $default(_that.id,_that.titleHu,_that.subtitleHu,_that.level,_that.sections,_that.exercises);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String titleHu,  String subtitleHu,  CefrLevel level,  List<GrammarSection> sections,  List<GrammarExercise> exercises)?  $default,) {final _that = this;
switch (_that) {
case _GrammarLesson() when $default != null:
return $default(_that.id,_that.titleHu,_that.subtitleHu,_that.level,_that.sections,_that.exercises);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _GrammarLesson implements GrammarLesson {
  const _GrammarLesson({required this.id, required this.titleHu, required this.subtitleHu, required this.level, required final  List<GrammarSection> sections, required final  List<GrammarExercise> exercises}): _sections = sections,_exercises = exercises;
  factory _GrammarLesson.fromJson(Map<String, dynamic> json) => _$GrammarLessonFromJson(json);

@override final  String id;
@override final  String titleHu;
@override final  String subtitleHu;
@override final  CefrLevel level;
 final  List<GrammarSection> _sections;
@override List<GrammarSection> get sections {
  if (_sections is EqualUnmodifiableListView) return _sections;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_sections);
}

 final  List<GrammarExercise> _exercises;
@override List<GrammarExercise> get exercises {
  if (_exercises is EqualUnmodifiableListView) return _exercises;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_exercises);
}


/// Create a copy of GrammarLesson
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$GrammarLessonCopyWith<_GrammarLesson> get copyWith => __$GrammarLessonCopyWithImpl<_GrammarLesson>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$GrammarLessonToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _GrammarLesson&&(identical(other.id, id) || other.id == id)&&(identical(other.titleHu, titleHu) || other.titleHu == titleHu)&&(identical(other.subtitleHu, subtitleHu) || other.subtitleHu == subtitleHu)&&(identical(other.level, level) || other.level == level)&&const DeepCollectionEquality().equals(other._sections, _sections)&&const DeepCollectionEquality().equals(other._exercises, _exercises));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,titleHu,subtitleHu,level,const DeepCollectionEquality().hash(_sections),const DeepCollectionEquality().hash(_exercises));

@override
String toString() {
  return 'GrammarLesson(id: $id, titleHu: $titleHu, subtitleHu: $subtitleHu, level: $level, sections: $sections, exercises: $exercises)';
}


}

/// @nodoc
abstract mixin class _$GrammarLessonCopyWith<$Res> implements $GrammarLessonCopyWith<$Res> {
  factory _$GrammarLessonCopyWith(_GrammarLesson value, $Res Function(_GrammarLesson) _then) = __$GrammarLessonCopyWithImpl;
@override @useResult
$Res call({
 String id, String titleHu, String subtitleHu, CefrLevel level, List<GrammarSection> sections, List<GrammarExercise> exercises
});




}
/// @nodoc
class __$GrammarLessonCopyWithImpl<$Res>
    implements _$GrammarLessonCopyWith<$Res> {
  __$GrammarLessonCopyWithImpl(this._self, this._then);

  final _GrammarLesson _self;
  final $Res Function(_GrammarLesson) _then;

/// Create a copy of GrammarLesson
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? titleHu = null,Object? subtitleHu = null,Object? level = null,Object? sections = null,Object? exercises = null,}) {
  return _then(_GrammarLesson(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,titleHu: null == titleHu ? _self.titleHu : titleHu // ignore: cast_nullable_to_non_nullable
as String,subtitleHu: null == subtitleHu ? _self.subtitleHu : subtitleHu // ignore: cast_nullable_to_non_nullable
as String,level: null == level ? _self.level : level // ignore: cast_nullable_to_non_nullable
as CefrLevel,sections: null == sections ? _self._sections : sections // ignore: cast_nullable_to_non_nullable
as List<GrammarSection>,exercises: null == exercises ? _self._exercises : exercises // ignore: cast_nullable_to_non_nullable
as List<GrammarExercise>,
  ));
}


}

// dart format on
