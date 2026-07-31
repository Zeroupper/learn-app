// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'evaluation_result.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$SentenceError {

 String get original; String get corrected; String get explanationHu;
/// Create a copy of SentenceError
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SentenceErrorCopyWith<SentenceError> get copyWith => _$SentenceErrorCopyWithImpl<SentenceError>(this as SentenceError, _$identity);

  /// Serializes this SentenceError to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SentenceError&&(identical(other.original, original) || other.original == original)&&(identical(other.corrected, corrected) || other.corrected == corrected)&&(identical(other.explanationHu, explanationHu) || other.explanationHu == explanationHu));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,original,corrected,explanationHu);

@override
String toString() {
  return 'SentenceError(original: $original, corrected: $corrected, explanationHu: $explanationHu)';
}


}

/// @nodoc
abstract mixin class $SentenceErrorCopyWith<$Res>  {
  factory $SentenceErrorCopyWith(SentenceError value, $Res Function(SentenceError) _then) = _$SentenceErrorCopyWithImpl;
@useResult
$Res call({
 String original, String corrected, String explanationHu
});




}
/// @nodoc
class _$SentenceErrorCopyWithImpl<$Res>
    implements $SentenceErrorCopyWith<$Res> {
  _$SentenceErrorCopyWithImpl(this._self, this._then);

  final SentenceError _self;
  final $Res Function(SentenceError) _then;

/// Create a copy of SentenceError
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? original = null,Object? corrected = null,Object? explanationHu = null,}) {
  return _then(_self.copyWith(
original: null == original ? _self.original : original // ignore: cast_nullable_to_non_nullable
as String,corrected: null == corrected ? _self.corrected : corrected // ignore: cast_nullable_to_non_nullable
as String,explanationHu: null == explanationHu ? _self.explanationHu : explanationHu // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [SentenceError].
extension SentenceErrorPatterns on SentenceError {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SentenceError value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SentenceError() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SentenceError value)  $default,){
final _that = this;
switch (_that) {
case _SentenceError():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SentenceError value)?  $default,){
final _that = this;
switch (_that) {
case _SentenceError() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String original,  String corrected,  String explanationHu)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SentenceError() when $default != null:
return $default(_that.original,_that.corrected,_that.explanationHu);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String original,  String corrected,  String explanationHu)  $default,) {final _that = this;
switch (_that) {
case _SentenceError():
return $default(_that.original,_that.corrected,_that.explanationHu);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String original,  String corrected,  String explanationHu)?  $default,) {final _that = this;
switch (_that) {
case _SentenceError() when $default != null:
return $default(_that.original,_that.corrected,_that.explanationHu);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _SentenceError implements SentenceError {
  const _SentenceError({this.original = '', this.corrected = '', this.explanationHu = ''});
  factory _SentenceError.fromJson(Map<String, dynamic> json) => _$SentenceErrorFromJson(json);

@override@JsonKey() final  String original;
@override@JsonKey() final  String corrected;
@override@JsonKey() final  String explanationHu;

/// Create a copy of SentenceError
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SentenceErrorCopyWith<_SentenceError> get copyWith => __$SentenceErrorCopyWithImpl<_SentenceError>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SentenceErrorToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SentenceError&&(identical(other.original, original) || other.original == original)&&(identical(other.corrected, corrected) || other.corrected == corrected)&&(identical(other.explanationHu, explanationHu) || other.explanationHu == explanationHu));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,original,corrected,explanationHu);

@override
String toString() {
  return 'SentenceError(original: $original, corrected: $corrected, explanationHu: $explanationHu)';
}


}

/// @nodoc
abstract mixin class _$SentenceErrorCopyWith<$Res> implements $SentenceErrorCopyWith<$Res> {
  factory _$SentenceErrorCopyWith(_SentenceError value, $Res Function(_SentenceError) _then) = __$SentenceErrorCopyWithImpl;
@override @useResult
$Res call({
 String original, String corrected, String explanationHu
});




}
/// @nodoc
class __$SentenceErrorCopyWithImpl<$Res>
    implements _$SentenceErrorCopyWith<$Res> {
  __$SentenceErrorCopyWithImpl(this._self, this._then);

  final _SentenceError _self;
  final $Res Function(_SentenceError) _then;

/// Create a copy of SentenceError
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? original = null,Object? corrected = null,Object? explanationHu = null,}) {
  return _then(_SentenceError(
original: null == original ? _self.original : original // ignore: cast_nullable_to_non_nullable
as String,corrected: null == corrected ? _self.corrected : corrected // ignore: cast_nullable_to_non_nullable
as String,explanationHu: null == explanationHu ? _self.explanationHu : explanationHu // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}


/// @nodoc
mixin _$SentenceEvaluation {

 int get score;// 0-100
 bool get isCorrect; String get corrected; List<SentenceError> get errors; String get explanationHu;
/// Create a copy of SentenceEvaluation
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SentenceEvaluationCopyWith<SentenceEvaluation> get copyWith => _$SentenceEvaluationCopyWithImpl<SentenceEvaluation>(this as SentenceEvaluation, _$identity);

  /// Serializes this SentenceEvaluation to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SentenceEvaluation&&(identical(other.score, score) || other.score == score)&&(identical(other.isCorrect, isCorrect) || other.isCorrect == isCorrect)&&(identical(other.corrected, corrected) || other.corrected == corrected)&&const DeepCollectionEquality().equals(other.errors, errors)&&(identical(other.explanationHu, explanationHu) || other.explanationHu == explanationHu));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,score,isCorrect,corrected,const DeepCollectionEquality().hash(errors),explanationHu);

@override
String toString() {
  return 'SentenceEvaluation(score: $score, isCorrect: $isCorrect, corrected: $corrected, errors: $errors, explanationHu: $explanationHu)';
}


}

/// @nodoc
abstract mixin class $SentenceEvaluationCopyWith<$Res>  {
  factory $SentenceEvaluationCopyWith(SentenceEvaluation value, $Res Function(SentenceEvaluation) _then) = _$SentenceEvaluationCopyWithImpl;
@useResult
$Res call({
 int score, bool isCorrect, String corrected, List<SentenceError> errors, String explanationHu
});




}
/// @nodoc
class _$SentenceEvaluationCopyWithImpl<$Res>
    implements $SentenceEvaluationCopyWith<$Res> {
  _$SentenceEvaluationCopyWithImpl(this._self, this._then);

  final SentenceEvaluation _self;
  final $Res Function(SentenceEvaluation) _then;

/// Create a copy of SentenceEvaluation
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? score = null,Object? isCorrect = null,Object? corrected = null,Object? errors = null,Object? explanationHu = null,}) {
  return _then(_self.copyWith(
score: null == score ? _self.score : score // ignore: cast_nullable_to_non_nullable
as int,isCorrect: null == isCorrect ? _self.isCorrect : isCorrect // ignore: cast_nullable_to_non_nullable
as bool,corrected: null == corrected ? _self.corrected : corrected // ignore: cast_nullable_to_non_nullable
as String,errors: null == errors ? _self.errors : errors // ignore: cast_nullable_to_non_nullable
as List<SentenceError>,explanationHu: null == explanationHu ? _self.explanationHu : explanationHu // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [SentenceEvaluation].
extension SentenceEvaluationPatterns on SentenceEvaluation {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SentenceEvaluation value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SentenceEvaluation() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SentenceEvaluation value)  $default,){
final _that = this;
switch (_that) {
case _SentenceEvaluation():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SentenceEvaluation value)?  $default,){
final _that = this;
switch (_that) {
case _SentenceEvaluation() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int score,  bool isCorrect,  String corrected,  List<SentenceError> errors,  String explanationHu)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SentenceEvaluation() when $default != null:
return $default(_that.score,_that.isCorrect,_that.corrected,_that.errors,_that.explanationHu);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int score,  bool isCorrect,  String corrected,  List<SentenceError> errors,  String explanationHu)  $default,) {final _that = this;
switch (_that) {
case _SentenceEvaluation():
return $default(_that.score,_that.isCorrect,_that.corrected,_that.errors,_that.explanationHu);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int score,  bool isCorrect,  String corrected,  List<SentenceError> errors,  String explanationHu)?  $default,) {final _that = this;
switch (_that) {
case _SentenceEvaluation() when $default != null:
return $default(_that.score,_that.isCorrect,_that.corrected,_that.errors,_that.explanationHu);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _SentenceEvaluation implements SentenceEvaluation {
  const _SentenceEvaluation({this.score = 0, this.isCorrect = false, this.corrected = '', final  List<SentenceError> errors = const <SentenceError>[], this.explanationHu = ''}): _errors = errors;
  factory _SentenceEvaluation.fromJson(Map<String, dynamic> json) => _$SentenceEvaluationFromJson(json);

@override@JsonKey() final  int score;
// 0-100
@override@JsonKey() final  bool isCorrect;
@override@JsonKey() final  String corrected;
 final  List<SentenceError> _errors;
@override@JsonKey() List<SentenceError> get errors {
  if (_errors is EqualUnmodifiableListView) return _errors;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_errors);
}

@override@JsonKey() final  String explanationHu;

/// Create a copy of SentenceEvaluation
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SentenceEvaluationCopyWith<_SentenceEvaluation> get copyWith => __$SentenceEvaluationCopyWithImpl<_SentenceEvaluation>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SentenceEvaluationToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SentenceEvaluation&&(identical(other.score, score) || other.score == score)&&(identical(other.isCorrect, isCorrect) || other.isCorrect == isCorrect)&&(identical(other.corrected, corrected) || other.corrected == corrected)&&const DeepCollectionEquality().equals(other._errors, _errors)&&(identical(other.explanationHu, explanationHu) || other.explanationHu == explanationHu));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,score,isCorrect,corrected,const DeepCollectionEquality().hash(_errors),explanationHu);

@override
String toString() {
  return 'SentenceEvaluation(score: $score, isCorrect: $isCorrect, corrected: $corrected, errors: $errors, explanationHu: $explanationHu)';
}


}

/// @nodoc
abstract mixin class _$SentenceEvaluationCopyWith<$Res> implements $SentenceEvaluationCopyWith<$Res> {
  factory _$SentenceEvaluationCopyWith(_SentenceEvaluation value, $Res Function(_SentenceEvaluation) _then) = __$SentenceEvaluationCopyWithImpl;
@override @useResult
$Res call({
 int score, bool isCorrect, String corrected, List<SentenceError> errors, String explanationHu
});




}
/// @nodoc
class __$SentenceEvaluationCopyWithImpl<$Res>
    implements _$SentenceEvaluationCopyWith<$Res> {
  __$SentenceEvaluationCopyWithImpl(this._self, this._then);

  final _SentenceEvaluation _self;
  final $Res Function(_SentenceEvaluation) _then;

/// Create a copy of SentenceEvaluation
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? score = null,Object? isCorrect = null,Object? corrected = null,Object? errors = null,Object? explanationHu = null,}) {
  return _then(_SentenceEvaluation(
score: null == score ? _self.score : score // ignore: cast_nullable_to_non_nullable
as int,isCorrect: null == isCorrect ? _self.isCorrect : isCorrect // ignore: cast_nullable_to_non_nullable
as bool,corrected: null == corrected ? _self.corrected : corrected // ignore: cast_nullable_to_non_nullable
as String,errors: null == errors ? _self._errors : errors // ignore: cast_nullable_to_non_nullable
as List<SentenceError>,explanationHu: null == explanationHu ? _self.explanationHu : explanationHu // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
