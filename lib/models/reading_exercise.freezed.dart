// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'reading_exercise.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ReadingQuestion {

 String get question; List<String> get options; int get correctIndex;
/// Create a copy of ReadingQuestion
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ReadingQuestionCopyWith<ReadingQuestion> get copyWith => _$ReadingQuestionCopyWithImpl<ReadingQuestion>(this as ReadingQuestion, _$identity);

  /// Serializes this ReadingQuestion to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ReadingQuestion&&(identical(other.question, question) || other.question == question)&&const DeepCollectionEquality().equals(other.options, options)&&(identical(other.correctIndex, correctIndex) || other.correctIndex == correctIndex));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,question,const DeepCollectionEquality().hash(options),correctIndex);

@override
String toString() {
  return 'ReadingQuestion(question: $question, options: $options, correctIndex: $correctIndex)';
}


}

/// @nodoc
abstract mixin class $ReadingQuestionCopyWith<$Res>  {
  factory $ReadingQuestionCopyWith(ReadingQuestion value, $Res Function(ReadingQuestion) _then) = _$ReadingQuestionCopyWithImpl;
@useResult
$Res call({
 String question, List<String> options, int correctIndex
});




}
/// @nodoc
class _$ReadingQuestionCopyWithImpl<$Res>
    implements $ReadingQuestionCopyWith<$Res> {
  _$ReadingQuestionCopyWithImpl(this._self, this._then);

  final ReadingQuestion _self;
  final $Res Function(ReadingQuestion) _then;

/// Create a copy of ReadingQuestion
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? question = null,Object? options = null,Object? correctIndex = null,}) {
  return _then(_self.copyWith(
question: null == question ? _self.question : question // ignore: cast_nullable_to_non_nullable
as String,options: null == options ? _self.options : options // ignore: cast_nullable_to_non_nullable
as List<String>,correctIndex: null == correctIndex ? _self.correctIndex : correctIndex // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [ReadingQuestion].
extension ReadingQuestionPatterns on ReadingQuestion {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ReadingQuestion value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ReadingQuestion() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ReadingQuestion value)  $default,){
final _that = this;
switch (_that) {
case _ReadingQuestion():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ReadingQuestion value)?  $default,){
final _that = this;
switch (_that) {
case _ReadingQuestion() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String question,  List<String> options,  int correctIndex)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ReadingQuestion() when $default != null:
return $default(_that.question,_that.options,_that.correctIndex);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String question,  List<String> options,  int correctIndex)  $default,) {final _that = this;
switch (_that) {
case _ReadingQuestion():
return $default(_that.question,_that.options,_that.correctIndex);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String question,  List<String> options,  int correctIndex)?  $default,) {final _that = this;
switch (_that) {
case _ReadingQuestion() when $default != null:
return $default(_that.question,_that.options,_that.correctIndex);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ReadingQuestion implements ReadingQuestion {
  const _ReadingQuestion({this.question = '', final  List<String> options = const <String>[], this.correctIndex = 0}): _options = options;
  factory _ReadingQuestion.fromJson(Map<String, dynamic> json) => _$ReadingQuestionFromJson(json);

@override@JsonKey() final  String question;
 final  List<String> _options;
@override@JsonKey() List<String> get options {
  if (_options is EqualUnmodifiableListView) return _options;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_options);
}

@override@JsonKey() final  int correctIndex;

/// Create a copy of ReadingQuestion
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ReadingQuestionCopyWith<_ReadingQuestion> get copyWith => __$ReadingQuestionCopyWithImpl<_ReadingQuestion>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ReadingQuestionToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ReadingQuestion&&(identical(other.question, question) || other.question == question)&&const DeepCollectionEquality().equals(other._options, _options)&&(identical(other.correctIndex, correctIndex) || other.correctIndex == correctIndex));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,question,const DeepCollectionEquality().hash(_options),correctIndex);

@override
String toString() {
  return 'ReadingQuestion(question: $question, options: $options, correctIndex: $correctIndex)';
}


}

/// @nodoc
abstract mixin class _$ReadingQuestionCopyWith<$Res> implements $ReadingQuestionCopyWith<$Res> {
  factory _$ReadingQuestionCopyWith(_ReadingQuestion value, $Res Function(_ReadingQuestion) _then) = __$ReadingQuestionCopyWithImpl;
@override @useResult
$Res call({
 String question, List<String> options, int correctIndex
});




}
/// @nodoc
class __$ReadingQuestionCopyWithImpl<$Res>
    implements _$ReadingQuestionCopyWith<$Res> {
  __$ReadingQuestionCopyWithImpl(this._self, this._then);

  final _ReadingQuestion _self;
  final $Res Function(_ReadingQuestion) _then;

/// Create a copy of ReadingQuestion
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? question = null,Object? options = null,Object? correctIndex = null,}) {
  return _then(_ReadingQuestion(
question: null == question ? _self.question : question // ignore: cast_nullable_to_non_nullable
as String,options: null == options ? _self._options : options // ignore: cast_nullable_to_non_nullable
as List<String>,correctIndex: null == correctIndex ? _self.correctIndex : correctIndex // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}


/// @nodoc
mixin _$GlossaryEntry {

 String get en; String get hu;
/// Create a copy of GlossaryEntry
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$GlossaryEntryCopyWith<GlossaryEntry> get copyWith => _$GlossaryEntryCopyWithImpl<GlossaryEntry>(this as GlossaryEntry, _$identity);

  /// Serializes this GlossaryEntry to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is GlossaryEntry&&(identical(other.en, en) || other.en == en)&&(identical(other.hu, hu) || other.hu == hu));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,en,hu);

@override
String toString() {
  return 'GlossaryEntry(en: $en, hu: $hu)';
}


}

/// @nodoc
abstract mixin class $GlossaryEntryCopyWith<$Res>  {
  factory $GlossaryEntryCopyWith(GlossaryEntry value, $Res Function(GlossaryEntry) _then) = _$GlossaryEntryCopyWithImpl;
@useResult
$Res call({
 String en, String hu
});




}
/// @nodoc
class _$GlossaryEntryCopyWithImpl<$Res>
    implements $GlossaryEntryCopyWith<$Res> {
  _$GlossaryEntryCopyWithImpl(this._self, this._then);

  final GlossaryEntry _self;
  final $Res Function(GlossaryEntry) _then;

/// Create a copy of GlossaryEntry
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? en = null,Object? hu = null,}) {
  return _then(_self.copyWith(
en: null == en ? _self.en : en // ignore: cast_nullable_to_non_nullable
as String,hu: null == hu ? _self.hu : hu // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [GlossaryEntry].
extension GlossaryEntryPatterns on GlossaryEntry {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _GlossaryEntry value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _GlossaryEntry() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _GlossaryEntry value)  $default,){
final _that = this;
switch (_that) {
case _GlossaryEntry():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _GlossaryEntry value)?  $default,){
final _that = this;
switch (_that) {
case _GlossaryEntry() when $default != null:
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
case _GlossaryEntry() when $default != null:
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
case _GlossaryEntry():
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
case _GlossaryEntry() when $default != null:
return $default(_that.en,_that.hu);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _GlossaryEntry implements GlossaryEntry {
  const _GlossaryEntry({this.en = '', this.hu = ''});
  factory _GlossaryEntry.fromJson(Map<String, dynamic> json) => _$GlossaryEntryFromJson(json);

@override@JsonKey() final  String en;
@override@JsonKey() final  String hu;

/// Create a copy of GlossaryEntry
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$GlossaryEntryCopyWith<_GlossaryEntry> get copyWith => __$GlossaryEntryCopyWithImpl<_GlossaryEntry>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$GlossaryEntryToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _GlossaryEntry&&(identical(other.en, en) || other.en == en)&&(identical(other.hu, hu) || other.hu == hu));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,en,hu);

@override
String toString() {
  return 'GlossaryEntry(en: $en, hu: $hu)';
}


}

/// @nodoc
abstract mixin class _$GlossaryEntryCopyWith<$Res> implements $GlossaryEntryCopyWith<$Res> {
  factory _$GlossaryEntryCopyWith(_GlossaryEntry value, $Res Function(_GlossaryEntry) _then) = __$GlossaryEntryCopyWithImpl;
@override @useResult
$Res call({
 String en, String hu
});




}
/// @nodoc
class __$GlossaryEntryCopyWithImpl<$Res>
    implements _$GlossaryEntryCopyWith<$Res> {
  __$GlossaryEntryCopyWithImpl(this._self, this._then);

  final _GlossaryEntry _self;
  final $Res Function(_GlossaryEntry) _then;

/// Create a copy of GlossaryEntry
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? en = null,Object? hu = null,}) {
  return _then(_GlossaryEntry(
en: null == en ? _self.en : en // ignore: cast_nullable_to_non_nullable
as String,hu: null == hu ? _self.hu : hu // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}


/// @nodoc
mixin _$ReadingExercise {

 String get title; String get text; List<ReadingQuestion> get questions; List<GlossaryEntry> get glossary;
/// Create a copy of ReadingExercise
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ReadingExerciseCopyWith<ReadingExercise> get copyWith => _$ReadingExerciseCopyWithImpl<ReadingExercise>(this as ReadingExercise, _$identity);

  /// Serializes this ReadingExercise to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ReadingExercise&&(identical(other.title, title) || other.title == title)&&(identical(other.text, text) || other.text == text)&&const DeepCollectionEquality().equals(other.questions, questions)&&const DeepCollectionEquality().equals(other.glossary, glossary));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,title,text,const DeepCollectionEquality().hash(questions),const DeepCollectionEquality().hash(glossary));

@override
String toString() {
  return 'ReadingExercise(title: $title, text: $text, questions: $questions, glossary: $glossary)';
}


}

/// @nodoc
abstract mixin class $ReadingExerciseCopyWith<$Res>  {
  factory $ReadingExerciseCopyWith(ReadingExercise value, $Res Function(ReadingExercise) _then) = _$ReadingExerciseCopyWithImpl;
@useResult
$Res call({
 String title, String text, List<ReadingQuestion> questions, List<GlossaryEntry> glossary
});




}
/// @nodoc
class _$ReadingExerciseCopyWithImpl<$Res>
    implements $ReadingExerciseCopyWith<$Res> {
  _$ReadingExerciseCopyWithImpl(this._self, this._then);

  final ReadingExercise _self;
  final $Res Function(ReadingExercise) _then;

/// Create a copy of ReadingExercise
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? title = null,Object? text = null,Object? questions = null,Object? glossary = null,}) {
  return _then(_self.copyWith(
title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,text: null == text ? _self.text : text // ignore: cast_nullable_to_non_nullable
as String,questions: null == questions ? _self.questions : questions // ignore: cast_nullable_to_non_nullable
as List<ReadingQuestion>,glossary: null == glossary ? _self.glossary : glossary // ignore: cast_nullable_to_non_nullable
as List<GlossaryEntry>,
  ));
}

}


/// Adds pattern-matching-related methods to [ReadingExercise].
extension ReadingExercisePatterns on ReadingExercise {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ReadingExercise value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ReadingExercise() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ReadingExercise value)  $default,){
final _that = this;
switch (_that) {
case _ReadingExercise():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ReadingExercise value)?  $default,){
final _that = this;
switch (_that) {
case _ReadingExercise() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String title,  String text,  List<ReadingQuestion> questions,  List<GlossaryEntry> glossary)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ReadingExercise() when $default != null:
return $default(_that.title,_that.text,_that.questions,_that.glossary);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String title,  String text,  List<ReadingQuestion> questions,  List<GlossaryEntry> glossary)  $default,) {final _that = this;
switch (_that) {
case _ReadingExercise():
return $default(_that.title,_that.text,_that.questions,_that.glossary);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String title,  String text,  List<ReadingQuestion> questions,  List<GlossaryEntry> glossary)?  $default,) {final _that = this;
switch (_that) {
case _ReadingExercise() when $default != null:
return $default(_that.title,_that.text,_that.questions,_that.glossary);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ReadingExercise implements ReadingExercise {
  const _ReadingExercise({this.title = '', this.text = '', final  List<ReadingQuestion> questions = const <ReadingQuestion>[], final  List<GlossaryEntry> glossary = const <GlossaryEntry>[]}): _questions = questions,_glossary = glossary;
  factory _ReadingExercise.fromJson(Map<String, dynamic> json) => _$ReadingExerciseFromJson(json);

@override@JsonKey() final  String title;
@override@JsonKey() final  String text;
 final  List<ReadingQuestion> _questions;
@override@JsonKey() List<ReadingQuestion> get questions {
  if (_questions is EqualUnmodifiableListView) return _questions;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_questions);
}

 final  List<GlossaryEntry> _glossary;
@override@JsonKey() List<GlossaryEntry> get glossary {
  if (_glossary is EqualUnmodifiableListView) return _glossary;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_glossary);
}


/// Create a copy of ReadingExercise
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ReadingExerciseCopyWith<_ReadingExercise> get copyWith => __$ReadingExerciseCopyWithImpl<_ReadingExercise>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ReadingExerciseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ReadingExercise&&(identical(other.title, title) || other.title == title)&&(identical(other.text, text) || other.text == text)&&const DeepCollectionEquality().equals(other._questions, _questions)&&const DeepCollectionEquality().equals(other._glossary, _glossary));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,title,text,const DeepCollectionEquality().hash(_questions),const DeepCollectionEquality().hash(_glossary));

@override
String toString() {
  return 'ReadingExercise(title: $title, text: $text, questions: $questions, glossary: $glossary)';
}


}

/// @nodoc
abstract mixin class _$ReadingExerciseCopyWith<$Res> implements $ReadingExerciseCopyWith<$Res> {
  factory _$ReadingExerciseCopyWith(_ReadingExercise value, $Res Function(_ReadingExercise) _then) = __$ReadingExerciseCopyWithImpl;
@override @useResult
$Res call({
 String title, String text, List<ReadingQuestion> questions, List<GlossaryEntry> glossary
});




}
/// @nodoc
class __$ReadingExerciseCopyWithImpl<$Res>
    implements _$ReadingExerciseCopyWith<$Res> {
  __$ReadingExerciseCopyWithImpl(this._self, this._then);

  final _ReadingExercise _self;
  final $Res Function(_ReadingExercise) _then;

/// Create a copy of ReadingExercise
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? title = null,Object? text = null,Object? questions = null,Object? glossary = null,}) {
  return _then(_ReadingExercise(
title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,text: null == text ? _self.text : text // ignore: cast_nullable_to_non_nullable
as String,questions: null == questions ? _self._questions : questions // ignore: cast_nullable_to_non_nullable
as List<ReadingQuestion>,glossary: null == glossary ? _self._glossary : glossary // ignore: cast_nullable_to_non_nullable
as List<GlossaryEntry>,
  ));
}


}

// dart format on
