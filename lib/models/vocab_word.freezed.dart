// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'vocab_word.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$VocabWord {

 int get id; String get en;/// Extra accepted English answers (HU->EN).
 List<String> get enAccepted;/// Accepted Hungarian answers (EN->HU).
 List<String> get hu; CefrLevel get level; String get pos; String? get exampleEn; String? get exampleHu;
/// Create a copy of VocabWord
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$VocabWordCopyWith<VocabWord> get copyWith => _$VocabWordCopyWithImpl<VocabWord>(this as VocabWord, _$identity);

  /// Serializes this VocabWord to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is VocabWord&&(identical(other.id, id) || other.id == id)&&(identical(other.en, en) || other.en == en)&&const DeepCollectionEquality().equals(other.enAccepted, enAccepted)&&const DeepCollectionEquality().equals(other.hu, hu)&&(identical(other.level, level) || other.level == level)&&(identical(other.pos, pos) || other.pos == pos)&&(identical(other.exampleEn, exampleEn) || other.exampleEn == exampleEn)&&(identical(other.exampleHu, exampleHu) || other.exampleHu == exampleHu));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,en,const DeepCollectionEquality().hash(enAccepted),const DeepCollectionEquality().hash(hu),level,pos,exampleEn,exampleHu);

@override
String toString() {
  return 'VocabWord(id: $id, en: $en, enAccepted: $enAccepted, hu: $hu, level: $level, pos: $pos, exampleEn: $exampleEn, exampleHu: $exampleHu)';
}


}

/// @nodoc
abstract mixin class $VocabWordCopyWith<$Res>  {
  factory $VocabWordCopyWith(VocabWord value, $Res Function(VocabWord) _then) = _$VocabWordCopyWithImpl;
@useResult
$Res call({
 int id, String en, List<String> enAccepted, List<String> hu, CefrLevel level, String pos, String? exampleEn, String? exampleHu
});




}
/// @nodoc
class _$VocabWordCopyWithImpl<$Res>
    implements $VocabWordCopyWith<$Res> {
  _$VocabWordCopyWithImpl(this._self, this._then);

  final VocabWord _self;
  final $Res Function(VocabWord) _then;

/// Create a copy of VocabWord
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? en = null,Object? enAccepted = null,Object? hu = null,Object? level = null,Object? pos = null,Object? exampleEn = freezed,Object? exampleHu = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,en: null == en ? _self.en : en // ignore: cast_nullable_to_non_nullable
as String,enAccepted: null == enAccepted ? _self.enAccepted : enAccepted // ignore: cast_nullable_to_non_nullable
as List<String>,hu: null == hu ? _self.hu : hu // ignore: cast_nullable_to_non_nullable
as List<String>,level: null == level ? _self.level : level // ignore: cast_nullable_to_non_nullable
as CefrLevel,pos: null == pos ? _self.pos : pos // ignore: cast_nullable_to_non_nullable
as String,exampleEn: freezed == exampleEn ? _self.exampleEn : exampleEn // ignore: cast_nullable_to_non_nullable
as String?,exampleHu: freezed == exampleHu ? _self.exampleHu : exampleHu // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [VocabWord].
extension VocabWordPatterns on VocabWord {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _VocabWord value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _VocabWord() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _VocabWord value)  $default,){
final _that = this;
switch (_that) {
case _VocabWord():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _VocabWord value)?  $default,){
final _that = this;
switch (_that) {
case _VocabWord() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  String en,  List<String> enAccepted,  List<String> hu,  CefrLevel level,  String pos,  String? exampleEn,  String? exampleHu)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _VocabWord() when $default != null:
return $default(_that.id,_that.en,_that.enAccepted,_that.hu,_that.level,_that.pos,_that.exampleEn,_that.exampleHu);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  String en,  List<String> enAccepted,  List<String> hu,  CefrLevel level,  String pos,  String? exampleEn,  String? exampleHu)  $default,) {final _that = this;
switch (_that) {
case _VocabWord():
return $default(_that.id,_that.en,_that.enAccepted,_that.hu,_that.level,_that.pos,_that.exampleEn,_that.exampleHu);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  String en,  List<String> enAccepted,  List<String> hu,  CefrLevel level,  String pos,  String? exampleEn,  String? exampleHu)?  $default,) {final _that = this;
switch (_that) {
case _VocabWord() when $default != null:
return $default(_that.id,_that.en,_that.enAccepted,_that.hu,_that.level,_that.pos,_that.exampleEn,_that.exampleHu);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _VocabWord implements VocabWord {
  const _VocabWord({required this.id, required this.en, final  List<String> enAccepted = const <String>[], required final  List<String> hu, required this.level, this.pos = '', this.exampleEn, this.exampleHu}): _enAccepted = enAccepted,_hu = hu;
  factory _VocabWord.fromJson(Map<String, dynamic> json) => _$VocabWordFromJson(json);

@override final  int id;
@override final  String en;
/// Extra accepted English answers (HU->EN).
 final  List<String> _enAccepted;
/// Extra accepted English answers (HU->EN).
@override@JsonKey() List<String> get enAccepted {
  if (_enAccepted is EqualUnmodifiableListView) return _enAccepted;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_enAccepted);
}

/// Accepted Hungarian answers (EN->HU).
 final  List<String> _hu;
/// Accepted Hungarian answers (EN->HU).
@override List<String> get hu {
  if (_hu is EqualUnmodifiableListView) return _hu;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_hu);
}

@override final  CefrLevel level;
@override@JsonKey() final  String pos;
@override final  String? exampleEn;
@override final  String? exampleHu;

/// Create a copy of VocabWord
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$VocabWordCopyWith<_VocabWord> get copyWith => __$VocabWordCopyWithImpl<_VocabWord>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$VocabWordToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _VocabWord&&(identical(other.id, id) || other.id == id)&&(identical(other.en, en) || other.en == en)&&const DeepCollectionEquality().equals(other._enAccepted, _enAccepted)&&const DeepCollectionEquality().equals(other._hu, _hu)&&(identical(other.level, level) || other.level == level)&&(identical(other.pos, pos) || other.pos == pos)&&(identical(other.exampleEn, exampleEn) || other.exampleEn == exampleEn)&&(identical(other.exampleHu, exampleHu) || other.exampleHu == exampleHu));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,en,const DeepCollectionEquality().hash(_enAccepted),const DeepCollectionEquality().hash(_hu),level,pos,exampleEn,exampleHu);

@override
String toString() {
  return 'VocabWord(id: $id, en: $en, enAccepted: $enAccepted, hu: $hu, level: $level, pos: $pos, exampleEn: $exampleEn, exampleHu: $exampleHu)';
}


}

/// @nodoc
abstract mixin class _$VocabWordCopyWith<$Res> implements $VocabWordCopyWith<$Res> {
  factory _$VocabWordCopyWith(_VocabWord value, $Res Function(_VocabWord) _then) = __$VocabWordCopyWithImpl;
@override @useResult
$Res call({
 int id, String en, List<String> enAccepted, List<String> hu, CefrLevel level, String pos, String? exampleEn, String? exampleHu
});




}
/// @nodoc
class __$VocabWordCopyWithImpl<$Res>
    implements _$VocabWordCopyWith<$Res> {
  __$VocabWordCopyWithImpl(this._self, this._then);

  final _VocabWord _self;
  final $Res Function(_VocabWord) _then;

/// Create a copy of VocabWord
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? en = null,Object? enAccepted = null,Object? hu = null,Object? level = null,Object? pos = null,Object? exampleEn = freezed,Object? exampleHu = freezed,}) {
  return _then(_VocabWord(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,en: null == en ? _self.en : en // ignore: cast_nullable_to_non_nullable
as String,enAccepted: null == enAccepted ? _self._enAccepted : enAccepted // ignore: cast_nullable_to_non_nullable
as List<String>,hu: null == hu ? _self._hu : hu // ignore: cast_nullable_to_non_nullable
as List<String>,level: null == level ? _self.level : level // ignore: cast_nullable_to_non_nullable
as CefrLevel,pos: null == pos ? _self.pos : pos // ignore: cast_nullable_to_non_nullable
as String,exampleEn: freezed == exampleEn ? _self.exampleEn : exampleEn // ignore: cast_nullable_to_non_nullable
as String?,exampleHu: freezed == exampleHu ? _self.exampleHu : exampleHu // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
