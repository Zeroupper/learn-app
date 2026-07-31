// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'exam.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ExamQuestion {

 String get id; String get prompt; List<String> get options; int get correctIndex;
/// Create a copy of ExamQuestion
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ExamQuestionCopyWith<ExamQuestion> get copyWith => _$ExamQuestionCopyWithImpl<ExamQuestion>(this as ExamQuestion, _$identity);

  /// Serializes this ExamQuestion to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ExamQuestion&&(identical(other.id, id) || other.id == id)&&(identical(other.prompt, prompt) || other.prompt == prompt)&&const DeepCollectionEquality().equals(other.options, options)&&(identical(other.correctIndex, correctIndex) || other.correctIndex == correctIndex));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,prompt,const DeepCollectionEquality().hash(options),correctIndex);

@override
String toString() {
  return 'ExamQuestion(id: $id, prompt: $prompt, options: $options, correctIndex: $correctIndex)';
}


}

/// @nodoc
abstract mixin class $ExamQuestionCopyWith<$Res>  {
  factory $ExamQuestionCopyWith(ExamQuestion value, $Res Function(ExamQuestion) _then) = _$ExamQuestionCopyWithImpl;
@useResult
$Res call({
 String id, String prompt, List<String> options, int correctIndex
});




}
/// @nodoc
class _$ExamQuestionCopyWithImpl<$Res>
    implements $ExamQuestionCopyWith<$Res> {
  _$ExamQuestionCopyWithImpl(this._self, this._then);

  final ExamQuestion _self;
  final $Res Function(ExamQuestion) _then;

/// Create a copy of ExamQuestion
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? prompt = null,Object? options = null,Object? correctIndex = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,prompt: null == prompt ? _self.prompt : prompt // ignore: cast_nullable_to_non_nullable
as String,options: null == options ? _self.options : options // ignore: cast_nullable_to_non_nullable
as List<String>,correctIndex: null == correctIndex ? _self.correctIndex : correctIndex // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [ExamQuestion].
extension ExamQuestionPatterns on ExamQuestion {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ExamQuestion value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ExamQuestion() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ExamQuestion value)  $default,){
final _that = this;
switch (_that) {
case _ExamQuestion():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ExamQuestion value)?  $default,){
final _that = this;
switch (_that) {
case _ExamQuestion() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String prompt,  List<String> options,  int correctIndex)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ExamQuestion() when $default != null:
return $default(_that.id,_that.prompt,_that.options,_that.correctIndex);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String prompt,  List<String> options,  int correctIndex)  $default,) {final _that = this;
switch (_that) {
case _ExamQuestion():
return $default(_that.id,_that.prompt,_that.options,_that.correctIndex);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String prompt,  List<String> options,  int correctIndex)?  $default,) {final _that = this;
switch (_that) {
case _ExamQuestion() when $default != null:
return $default(_that.id,_that.prompt,_that.options,_that.correctIndex);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ExamQuestion extends ExamQuestion {
  const _ExamQuestion({this.id = '', this.prompt = '', final  List<String> options = const <String>[], this.correctIndex = -1}): _options = options,super._();
  factory _ExamQuestion.fromJson(Map<String, dynamic> json) => _$ExamQuestionFromJson(json);

@override@JsonKey() final  String id;
@override@JsonKey() final  String prompt;
 final  List<String> _options;
@override@JsonKey() List<String> get options {
  if (_options is EqualUnmodifiableListView) return _options;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_options);
}

@override@JsonKey() final  int correctIndex;

/// Create a copy of ExamQuestion
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ExamQuestionCopyWith<_ExamQuestion> get copyWith => __$ExamQuestionCopyWithImpl<_ExamQuestion>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ExamQuestionToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ExamQuestion&&(identical(other.id, id) || other.id == id)&&(identical(other.prompt, prompt) || other.prompt == prompt)&&const DeepCollectionEquality().equals(other._options, _options)&&(identical(other.correctIndex, correctIndex) || other.correctIndex == correctIndex));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,prompt,const DeepCollectionEquality().hash(_options),correctIndex);

@override
String toString() {
  return 'ExamQuestion(id: $id, prompt: $prompt, options: $options, correctIndex: $correctIndex)';
}


}

/// @nodoc
abstract mixin class _$ExamQuestionCopyWith<$Res> implements $ExamQuestionCopyWith<$Res> {
  factory _$ExamQuestionCopyWith(_ExamQuestion value, $Res Function(_ExamQuestion) _then) = __$ExamQuestionCopyWithImpl;
@override @useResult
$Res call({
 String id, String prompt, List<String> options, int correctIndex
});




}
/// @nodoc
class __$ExamQuestionCopyWithImpl<$Res>
    implements _$ExamQuestionCopyWith<$Res> {
  __$ExamQuestionCopyWithImpl(this._self, this._then);

  final _ExamQuestion _self;
  final $Res Function(_ExamQuestion) _then;

/// Create a copy of ExamQuestion
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? prompt = null,Object? options = null,Object? correctIndex = null,}) {
  return _then(_ExamQuestion(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,prompt: null == prompt ? _self.prompt : prompt // ignore: cast_nullable_to_non_nullable
as String,options: null == options ? _self._options : options // ignore: cast_nullable_to_non_nullable
as List<String>,correctIndex: null == correctIndex ? _self.correctIndex : correctIndex // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}


/// @nodoc
mixin _$ExamPart {

// An unknown section name must not sink the whole exam.
@JsonKey(unknownEnumValue: ExamSection.grammar) ExamSection get section; String get instructionsHu;/// Reading text, or the script read aloud for listening. Empty otherwise.
 String get passageTitle; String get passage; List<ExamQuestion> get questions;
/// Create a copy of ExamPart
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ExamPartCopyWith<ExamPart> get copyWith => _$ExamPartCopyWithImpl<ExamPart>(this as ExamPart, _$identity);

  /// Serializes this ExamPart to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ExamPart&&(identical(other.section, section) || other.section == section)&&(identical(other.instructionsHu, instructionsHu) || other.instructionsHu == instructionsHu)&&(identical(other.passageTitle, passageTitle) || other.passageTitle == passageTitle)&&(identical(other.passage, passage) || other.passage == passage)&&const DeepCollectionEquality().equals(other.questions, questions));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,section,instructionsHu,passageTitle,passage,const DeepCollectionEquality().hash(questions));

@override
String toString() {
  return 'ExamPart(section: $section, instructionsHu: $instructionsHu, passageTitle: $passageTitle, passage: $passage, questions: $questions)';
}


}

/// @nodoc
abstract mixin class $ExamPartCopyWith<$Res>  {
  factory $ExamPartCopyWith(ExamPart value, $Res Function(ExamPart) _then) = _$ExamPartCopyWithImpl;
@useResult
$Res call({
@JsonKey(unknownEnumValue: ExamSection.grammar) ExamSection section, String instructionsHu, String passageTitle, String passage, List<ExamQuestion> questions
});




}
/// @nodoc
class _$ExamPartCopyWithImpl<$Res>
    implements $ExamPartCopyWith<$Res> {
  _$ExamPartCopyWithImpl(this._self, this._then);

  final ExamPart _self;
  final $Res Function(ExamPart) _then;

/// Create a copy of ExamPart
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? section = null,Object? instructionsHu = null,Object? passageTitle = null,Object? passage = null,Object? questions = null,}) {
  return _then(_self.copyWith(
section: null == section ? _self.section : section // ignore: cast_nullable_to_non_nullable
as ExamSection,instructionsHu: null == instructionsHu ? _self.instructionsHu : instructionsHu // ignore: cast_nullable_to_non_nullable
as String,passageTitle: null == passageTitle ? _self.passageTitle : passageTitle // ignore: cast_nullable_to_non_nullable
as String,passage: null == passage ? _self.passage : passage // ignore: cast_nullable_to_non_nullable
as String,questions: null == questions ? _self.questions : questions // ignore: cast_nullable_to_non_nullable
as List<ExamQuestion>,
  ));
}

}


/// Adds pattern-matching-related methods to [ExamPart].
extension ExamPartPatterns on ExamPart {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ExamPart value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ExamPart() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ExamPart value)  $default,){
final _that = this;
switch (_that) {
case _ExamPart():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ExamPart value)?  $default,){
final _that = this;
switch (_that) {
case _ExamPart() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(unknownEnumValue: ExamSection.grammar)  ExamSection section,  String instructionsHu,  String passageTitle,  String passage,  List<ExamQuestion> questions)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ExamPart() when $default != null:
return $default(_that.section,_that.instructionsHu,_that.passageTitle,_that.passage,_that.questions);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(unknownEnumValue: ExamSection.grammar)  ExamSection section,  String instructionsHu,  String passageTitle,  String passage,  List<ExamQuestion> questions)  $default,) {final _that = this;
switch (_that) {
case _ExamPart():
return $default(_that.section,_that.instructionsHu,_that.passageTitle,_that.passage,_that.questions);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(unknownEnumValue: ExamSection.grammar)  ExamSection section,  String instructionsHu,  String passageTitle,  String passage,  List<ExamQuestion> questions)?  $default,) {final _that = this;
switch (_that) {
case _ExamPart() when $default != null:
return $default(_that.section,_that.instructionsHu,_that.passageTitle,_that.passage,_that.questions);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ExamPart implements ExamPart {
  const _ExamPart({@JsonKey(unknownEnumValue: ExamSection.grammar) this.section = ExamSection.grammar, this.instructionsHu = '', this.passageTitle = '', this.passage = '', final  List<ExamQuestion> questions = const <ExamQuestion>[]}): _questions = questions;
  factory _ExamPart.fromJson(Map<String, dynamic> json) => _$ExamPartFromJson(json);

// An unknown section name must not sink the whole exam.
@override@JsonKey(unknownEnumValue: ExamSection.grammar) final  ExamSection section;
@override@JsonKey() final  String instructionsHu;
/// Reading text, or the script read aloud for listening. Empty otherwise.
@override@JsonKey() final  String passageTitle;
@override@JsonKey() final  String passage;
 final  List<ExamQuestion> _questions;
@override@JsonKey() List<ExamQuestion> get questions {
  if (_questions is EqualUnmodifiableListView) return _questions;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_questions);
}


/// Create a copy of ExamPart
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ExamPartCopyWith<_ExamPart> get copyWith => __$ExamPartCopyWithImpl<_ExamPart>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ExamPartToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ExamPart&&(identical(other.section, section) || other.section == section)&&(identical(other.instructionsHu, instructionsHu) || other.instructionsHu == instructionsHu)&&(identical(other.passageTitle, passageTitle) || other.passageTitle == passageTitle)&&(identical(other.passage, passage) || other.passage == passage)&&const DeepCollectionEquality().equals(other._questions, _questions));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,section,instructionsHu,passageTitle,passage,const DeepCollectionEquality().hash(_questions));

@override
String toString() {
  return 'ExamPart(section: $section, instructionsHu: $instructionsHu, passageTitle: $passageTitle, passage: $passage, questions: $questions)';
}


}

/// @nodoc
abstract mixin class _$ExamPartCopyWith<$Res> implements $ExamPartCopyWith<$Res> {
  factory _$ExamPartCopyWith(_ExamPart value, $Res Function(_ExamPart) _then) = __$ExamPartCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(unknownEnumValue: ExamSection.grammar) ExamSection section, String instructionsHu, String passageTitle, String passage, List<ExamQuestion> questions
});




}
/// @nodoc
class __$ExamPartCopyWithImpl<$Res>
    implements _$ExamPartCopyWith<$Res> {
  __$ExamPartCopyWithImpl(this._self, this._then);

  final _ExamPart _self;
  final $Res Function(_ExamPart) _then;

/// Create a copy of ExamPart
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? section = null,Object? instructionsHu = null,Object? passageTitle = null,Object? passage = null,Object? questions = null,}) {
  return _then(_ExamPart(
section: null == section ? _self.section : section // ignore: cast_nullable_to_non_nullable
as ExamSection,instructionsHu: null == instructionsHu ? _self.instructionsHu : instructionsHu // ignore: cast_nullable_to_non_nullable
as String,passageTitle: null == passageTitle ? _self.passageTitle : passageTitle // ignore: cast_nullable_to_non_nullable
as String,passage: null == passage ? _self.passage : passage // ignore: cast_nullable_to_non_nullable
as String,questions: null == questions ? _self._questions : questions // ignore: cast_nullable_to_non_nullable
as List<ExamQuestion>,
  ));
}


}


/// @nodoc
mixin _$Exam {

 String get level; List<ExamPart> get parts;
/// Create a copy of Exam
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ExamCopyWith<Exam> get copyWith => _$ExamCopyWithImpl<Exam>(this as Exam, _$identity);

  /// Serializes this Exam to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Exam&&(identical(other.level, level) || other.level == level)&&const DeepCollectionEquality().equals(other.parts, parts));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,level,const DeepCollectionEquality().hash(parts));

@override
String toString() {
  return 'Exam(level: $level, parts: $parts)';
}


}

/// @nodoc
abstract mixin class $ExamCopyWith<$Res>  {
  factory $ExamCopyWith(Exam value, $Res Function(Exam) _then) = _$ExamCopyWithImpl;
@useResult
$Res call({
 String level, List<ExamPart> parts
});




}
/// @nodoc
class _$ExamCopyWithImpl<$Res>
    implements $ExamCopyWith<$Res> {
  _$ExamCopyWithImpl(this._self, this._then);

  final Exam _self;
  final $Res Function(Exam) _then;

/// Create a copy of Exam
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? level = null,Object? parts = null,}) {
  return _then(_self.copyWith(
level: null == level ? _self.level : level // ignore: cast_nullable_to_non_nullable
as String,parts: null == parts ? _self.parts : parts // ignore: cast_nullable_to_non_nullable
as List<ExamPart>,
  ));
}

}


/// Adds pattern-matching-related methods to [Exam].
extension ExamPatterns on Exam {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Exam value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Exam() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Exam value)  $default,){
final _that = this;
switch (_that) {
case _Exam():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Exam value)?  $default,){
final _that = this;
switch (_that) {
case _Exam() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String level,  List<ExamPart> parts)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Exam() when $default != null:
return $default(_that.level,_that.parts);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String level,  List<ExamPart> parts)  $default,) {final _that = this;
switch (_that) {
case _Exam():
return $default(_that.level,_that.parts);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String level,  List<ExamPart> parts)?  $default,) {final _that = this;
switch (_that) {
case _Exam() when $default != null:
return $default(_that.level,_that.parts);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Exam extends Exam {
  const _Exam({this.level = 'a1', final  List<ExamPart> parts = const <ExamPart>[]}): _parts = parts,super._();
  factory _Exam.fromJson(Map<String, dynamic> json) => _$ExamFromJson(json);

@override@JsonKey() final  String level;
 final  List<ExamPart> _parts;
@override@JsonKey() List<ExamPart> get parts {
  if (_parts is EqualUnmodifiableListView) return _parts;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_parts);
}


/// Create a copy of Exam
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ExamCopyWith<_Exam> get copyWith => __$ExamCopyWithImpl<_Exam>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ExamToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Exam&&(identical(other.level, level) || other.level == level)&&const DeepCollectionEquality().equals(other._parts, _parts));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,level,const DeepCollectionEquality().hash(_parts));

@override
String toString() {
  return 'Exam(level: $level, parts: $parts)';
}


}

/// @nodoc
abstract mixin class _$ExamCopyWith<$Res> implements $ExamCopyWith<$Res> {
  factory _$ExamCopyWith(_Exam value, $Res Function(_Exam) _then) = __$ExamCopyWithImpl;
@override @useResult
$Res call({
 String level, List<ExamPart> parts
});




}
/// @nodoc
class __$ExamCopyWithImpl<$Res>
    implements _$ExamCopyWith<$Res> {
  __$ExamCopyWithImpl(this._self, this._then);

  final _Exam _self;
  final $Res Function(_Exam) _then;

/// Create a copy of Exam
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? level = null,Object? parts = null,}) {
  return _then(_Exam(
level: null == level ? _self.level : level // ignore: cast_nullable_to_non_nullable
as String,parts: null == parts ? _self._parts : parts // ignore: cast_nullable_to_non_nullable
as List<ExamPart>,
  ));
}


}


/// @nodoc
mixin _$QuestionMark {

 String get id;/// 0-100. Multiple choice lands on 0 or 100; writing is graded on the scale.
@JsonKey(fromJson: _clampScore) int get score;/// Why it is wrong, in Hungarian. Empty when fully correct.
 String get explanationHu;/// The model answer, so the student can compare.
 String get expected;
/// Create a copy of QuestionMark
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$QuestionMarkCopyWith<QuestionMark> get copyWith => _$QuestionMarkCopyWithImpl<QuestionMark>(this as QuestionMark, _$identity);

  /// Serializes this QuestionMark to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is QuestionMark&&(identical(other.id, id) || other.id == id)&&(identical(other.score, score) || other.score == score)&&(identical(other.explanationHu, explanationHu) || other.explanationHu == explanationHu)&&(identical(other.expected, expected) || other.expected == expected));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,score,explanationHu,expected);

@override
String toString() {
  return 'QuestionMark(id: $id, score: $score, explanationHu: $explanationHu, expected: $expected)';
}


}

/// @nodoc
abstract mixin class $QuestionMarkCopyWith<$Res>  {
  factory $QuestionMarkCopyWith(QuestionMark value, $Res Function(QuestionMark) _then) = _$QuestionMarkCopyWithImpl;
@useResult
$Res call({
 String id,@JsonKey(fromJson: _clampScore) int score, String explanationHu, String expected
});




}
/// @nodoc
class _$QuestionMarkCopyWithImpl<$Res>
    implements $QuestionMarkCopyWith<$Res> {
  _$QuestionMarkCopyWithImpl(this._self, this._then);

  final QuestionMark _self;
  final $Res Function(QuestionMark) _then;

/// Create a copy of QuestionMark
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? score = null,Object? explanationHu = null,Object? expected = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,score: null == score ? _self.score : score // ignore: cast_nullable_to_non_nullable
as int,explanationHu: null == explanationHu ? _self.explanationHu : explanationHu // ignore: cast_nullable_to_non_nullable
as String,expected: null == expected ? _self.expected : expected // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [QuestionMark].
extension QuestionMarkPatterns on QuestionMark {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _QuestionMark value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _QuestionMark() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _QuestionMark value)  $default,){
final _that = this;
switch (_that) {
case _QuestionMark():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _QuestionMark value)?  $default,){
final _that = this;
switch (_that) {
case _QuestionMark() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id, @JsonKey(fromJson: _clampScore)  int score,  String explanationHu,  String expected)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _QuestionMark() when $default != null:
return $default(_that.id,_that.score,_that.explanationHu,_that.expected);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id, @JsonKey(fromJson: _clampScore)  int score,  String explanationHu,  String expected)  $default,) {final _that = this;
switch (_that) {
case _QuestionMark():
return $default(_that.id,_that.score,_that.explanationHu,_that.expected);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id, @JsonKey(fromJson: _clampScore)  int score,  String explanationHu,  String expected)?  $default,) {final _that = this;
switch (_that) {
case _QuestionMark() when $default != null:
return $default(_that.id,_that.score,_that.explanationHu,_that.expected);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _QuestionMark extends QuestionMark {
  const _QuestionMark({this.id = '', @JsonKey(fromJson: _clampScore) this.score = 0, this.explanationHu = '', this.expected = ''}): super._();
  factory _QuestionMark.fromJson(Map<String, dynamic> json) => _$QuestionMarkFromJson(json);

@override@JsonKey() final  String id;
/// 0-100. Multiple choice lands on 0 or 100; writing is graded on the scale.
@override@JsonKey(fromJson: _clampScore) final  int score;
/// Why it is wrong, in Hungarian. Empty when fully correct.
@override@JsonKey() final  String explanationHu;
/// The model answer, so the student can compare.
@override@JsonKey() final  String expected;

/// Create a copy of QuestionMark
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$QuestionMarkCopyWith<_QuestionMark> get copyWith => __$QuestionMarkCopyWithImpl<_QuestionMark>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$QuestionMarkToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _QuestionMark&&(identical(other.id, id) || other.id == id)&&(identical(other.score, score) || other.score == score)&&(identical(other.explanationHu, explanationHu) || other.explanationHu == explanationHu)&&(identical(other.expected, expected) || other.expected == expected));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,score,explanationHu,expected);

@override
String toString() {
  return 'QuestionMark(id: $id, score: $score, explanationHu: $explanationHu, expected: $expected)';
}


}

/// @nodoc
abstract mixin class _$QuestionMarkCopyWith<$Res> implements $QuestionMarkCopyWith<$Res> {
  factory _$QuestionMarkCopyWith(_QuestionMark value, $Res Function(_QuestionMark) _then) = __$QuestionMarkCopyWithImpl;
@override @useResult
$Res call({
 String id,@JsonKey(fromJson: _clampScore) int score, String explanationHu, String expected
});




}
/// @nodoc
class __$QuestionMarkCopyWithImpl<$Res>
    implements _$QuestionMarkCopyWith<$Res> {
  __$QuestionMarkCopyWithImpl(this._self, this._then);

  final _QuestionMark _self;
  final $Res Function(_QuestionMark) _then;

/// Create a copy of QuestionMark
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? score = null,Object? explanationHu = null,Object? expected = null,}) {
  return _then(_QuestionMark(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,score: null == score ? _self.score : score // ignore: cast_nullable_to_non_nullable
as int,explanationHu: null == explanationHu ? _self.explanationHu : explanationHu // ignore: cast_nullable_to_non_nullable
as String,expected: null == expected ? _self.expected : expected // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc
mixin _$SectionScore {

 ExamSection get section; int get percent;
/// Create a copy of SectionScore
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SectionScoreCopyWith<SectionScore> get copyWith => _$SectionScoreCopyWithImpl<SectionScore>(this as SectionScore, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SectionScore&&(identical(other.section, section) || other.section == section)&&(identical(other.percent, percent) || other.percent == percent));
}


@override
int get hashCode => Object.hash(runtimeType,section,percent);

@override
String toString() {
  return 'SectionScore(section: $section, percent: $percent)';
}


}

/// @nodoc
abstract mixin class $SectionScoreCopyWith<$Res>  {
  factory $SectionScoreCopyWith(SectionScore value, $Res Function(SectionScore) _then) = _$SectionScoreCopyWithImpl;
@useResult
$Res call({
 ExamSection section, int percent
});




}
/// @nodoc
class _$SectionScoreCopyWithImpl<$Res>
    implements $SectionScoreCopyWith<$Res> {
  _$SectionScoreCopyWithImpl(this._self, this._then);

  final SectionScore _self;
  final $Res Function(SectionScore) _then;

/// Create a copy of SectionScore
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? section = null,Object? percent = null,}) {
  return _then(_self.copyWith(
section: null == section ? _self.section : section // ignore: cast_nullable_to_non_nullable
as ExamSection,percent: null == percent ? _self.percent : percent // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [SectionScore].
extension SectionScorePatterns on SectionScore {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SectionScore value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SectionScore() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SectionScore value)  $default,){
final _that = this;
switch (_that) {
case _SectionScore():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SectionScore value)?  $default,){
final _that = this;
switch (_that) {
case _SectionScore() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( ExamSection section,  int percent)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SectionScore() when $default != null:
return $default(_that.section,_that.percent);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( ExamSection section,  int percent)  $default,) {final _that = this;
switch (_that) {
case _SectionScore():
return $default(_that.section,_that.percent);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( ExamSection section,  int percent)?  $default,) {final _that = this;
switch (_that) {
case _SectionScore() when $default != null:
return $default(_that.section,_that.percent);case _:
  return null;

}
}

}

/// @nodoc


class _SectionScore extends SectionScore {
  const _SectionScore({required this.section, required this.percent}): super._();
  

@override final  ExamSection section;
@override final  int percent;

/// Create a copy of SectionScore
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SectionScoreCopyWith<_SectionScore> get copyWith => __$SectionScoreCopyWithImpl<_SectionScore>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SectionScore&&(identical(other.section, section) || other.section == section)&&(identical(other.percent, percent) || other.percent == percent));
}


@override
int get hashCode => Object.hash(runtimeType,section,percent);

@override
String toString() {
  return 'SectionScore(section: $section, percent: $percent)';
}


}

/// @nodoc
abstract mixin class _$SectionScoreCopyWith<$Res> implements $SectionScoreCopyWith<$Res> {
  factory _$SectionScoreCopyWith(_SectionScore value, $Res Function(_SectionScore) _then) = __$SectionScoreCopyWithImpl;
@override @useResult
$Res call({
 ExamSection section, int percent
});




}
/// @nodoc
class __$SectionScoreCopyWithImpl<$Res>
    implements _$SectionScoreCopyWith<$Res> {
  __$SectionScoreCopyWithImpl(this._self, this._then);

  final _SectionScore _self;
  final $Res Function(_SectionScore) _then;

/// Create a copy of SectionScore
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? section = null,Object? percent = null,}) {
  return _then(_SectionScore(
section: null == section ? _self.section : section // ignore: cast_nullable_to_non_nullable
as ExamSection,percent: null == percent ? _self.percent : percent // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

/// @nodoc
mixin _$ExamResult {

 String get level; List<SectionScore> get sections; List<QuestionMark> get marks; String get overallFeedbackHu;
/// Create a copy of ExamResult
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ExamResultCopyWith<ExamResult> get copyWith => _$ExamResultCopyWithImpl<ExamResult>(this as ExamResult, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ExamResult&&(identical(other.level, level) || other.level == level)&&const DeepCollectionEquality().equals(other.sections, sections)&&const DeepCollectionEquality().equals(other.marks, marks)&&(identical(other.overallFeedbackHu, overallFeedbackHu) || other.overallFeedbackHu == overallFeedbackHu));
}


@override
int get hashCode => Object.hash(runtimeType,level,const DeepCollectionEquality().hash(sections),const DeepCollectionEquality().hash(marks),overallFeedbackHu);

@override
String toString() {
  return 'ExamResult(level: $level, sections: $sections, marks: $marks, overallFeedbackHu: $overallFeedbackHu)';
}


}

/// @nodoc
abstract mixin class $ExamResultCopyWith<$Res>  {
  factory $ExamResultCopyWith(ExamResult value, $Res Function(ExamResult) _then) = _$ExamResultCopyWithImpl;
@useResult
$Res call({
 String level, List<SectionScore> sections, List<QuestionMark> marks, String overallFeedbackHu
});




}
/// @nodoc
class _$ExamResultCopyWithImpl<$Res>
    implements $ExamResultCopyWith<$Res> {
  _$ExamResultCopyWithImpl(this._self, this._then);

  final ExamResult _self;
  final $Res Function(ExamResult) _then;

/// Create a copy of ExamResult
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? level = null,Object? sections = null,Object? marks = null,Object? overallFeedbackHu = null,}) {
  return _then(_self.copyWith(
level: null == level ? _self.level : level // ignore: cast_nullable_to_non_nullable
as String,sections: null == sections ? _self.sections : sections // ignore: cast_nullable_to_non_nullable
as List<SectionScore>,marks: null == marks ? _self.marks : marks // ignore: cast_nullable_to_non_nullable
as List<QuestionMark>,overallFeedbackHu: null == overallFeedbackHu ? _self.overallFeedbackHu : overallFeedbackHu // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [ExamResult].
extension ExamResultPatterns on ExamResult {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ExamResult value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ExamResult() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ExamResult value)  $default,){
final _that = this;
switch (_that) {
case _ExamResult():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ExamResult value)?  $default,){
final _that = this;
switch (_that) {
case _ExamResult() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String level,  List<SectionScore> sections,  List<QuestionMark> marks,  String overallFeedbackHu)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ExamResult() when $default != null:
return $default(_that.level,_that.sections,_that.marks,_that.overallFeedbackHu);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String level,  List<SectionScore> sections,  List<QuestionMark> marks,  String overallFeedbackHu)  $default,) {final _that = this;
switch (_that) {
case _ExamResult():
return $default(_that.level,_that.sections,_that.marks,_that.overallFeedbackHu);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String level,  List<SectionScore> sections,  List<QuestionMark> marks,  String overallFeedbackHu)?  $default,) {final _that = this;
switch (_that) {
case _ExamResult() when $default != null:
return $default(_that.level,_that.sections,_that.marks,_that.overallFeedbackHu);case _:
  return null;

}
}

}

/// @nodoc


class _ExamResult extends ExamResult {
  const _ExamResult({required this.level, required final  List<SectionScore> sections, required final  List<QuestionMark> marks, required this.overallFeedbackHu}): _sections = sections,_marks = marks,super._();
  

@override final  String level;
 final  List<SectionScore> _sections;
@override List<SectionScore> get sections {
  if (_sections is EqualUnmodifiableListView) return _sections;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_sections);
}

 final  List<QuestionMark> _marks;
@override List<QuestionMark> get marks {
  if (_marks is EqualUnmodifiableListView) return _marks;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_marks);
}

@override final  String overallFeedbackHu;

/// Create a copy of ExamResult
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ExamResultCopyWith<_ExamResult> get copyWith => __$ExamResultCopyWithImpl<_ExamResult>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ExamResult&&(identical(other.level, level) || other.level == level)&&const DeepCollectionEquality().equals(other._sections, _sections)&&const DeepCollectionEquality().equals(other._marks, _marks)&&(identical(other.overallFeedbackHu, overallFeedbackHu) || other.overallFeedbackHu == overallFeedbackHu));
}


@override
int get hashCode => Object.hash(runtimeType,level,const DeepCollectionEquality().hash(_sections),const DeepCollectionEquality().hash(_marks),overallFeedbackHu);

@override
String toString() {
  return 'ExamResult(level: $level, sections: $sections, marks: $marks, overallFeedbackHu: $overallFeedbackHu)';
}


}

/// @nodoc
abstract mixin class _$ExamResultCopyWith<$Res> implements $ExamResultCopyWith<$Res> {
  factory _$ExamResultCopyWith(_ExamResult value, $Res Function(_ExamResult) _then) = __$ExamResultCopyWithImpl;
@override @useResult
$Res call({
 String level, List<SectionScore> sections, List<QuestionMark> marks, String overallFeedbackHu
});




}
/// @nodoc
class __$ExamResultCopyWithImpl<$Res>
    implements _$ExamResultCopyWith<$Res> {
  __$ExamResultCopyWithImpl(this._self, this._then);

  final _ExamResult _self;
  final $Res Function(_ExamResult) _then;

/// Create a copy of ExamResult
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? level = null,Object? sections = null,Object? marks = null,Object? overallFeedbackHu = null,}) {
  return _then(_ExamResult(
level: null == level ? _self.level : level // ignore: cast_nullable_to_non_nullable
as String,sections: null == sections ? _self._sections : sections // ignore: cast_nullable_to_non_nullable
as List<SectionScore>,marks: null == marks ? _self._marks : marks // ignore: cast_nullable_to_non_nullable
as List<QuestionMark>,overallFeedbackHu: null == overallFeedbackHu ? _self.overallFeedbackHu : overallFeedbackHu // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}


/// @nodoc
mixin _$ExamAttempt {

 DateTime get takenAt; Exam get exam;/// Question id -> the answer the student gave.
 Map<String, String> get answers; List<QuestionMark> get marks; String get feedbackHu;
/// Create a copy of ExamAttempt
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ExamAttemptCopyWith<ExamAttempt> get copyWith => _$ExamAttemptCopyWithImpl<ExamAttempt>(this as ExamAttempt, _$identity);

  /// Serializes this ExamAttempt to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ExamAttempt&&(identical(other.takenAt, takenAt) || other.takenAt == takenAt)&&(identical(other.exam, exam) || other.exam == exam)&&const DeepCollectionEquality().equals(other.answers, answers)&&const DeepCollectionEquality().equals(other.marks, marks)&&(identical(other.feedbackHu, feedbackHu) || other.feedbackHu == feedbackHu));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,takenAt,exam,const DeepCollectionEquality().hash(answers),const DeepCollectionEquality().hash(marks),feedbackHu);

@override
String toString() {
  return 'ExamAttempt(takenAt: $takenAt, exam: $exam, answers: $answers, marks: $marks, feedbackHu: $feedbackHu)';
}


}

/// @nodoc
abstract mixin class $ExamAttemptCopyWith<$Res>  {
  factory $ExamAttemptCopyWith(ExamAttempt value, $Res Function(ExamAttempt) _then) = _$ExamAttemptCopyWithImpl;
@useResult
$Res call({
 DateTime takenAt, Exam exam, Map<String, String> answers, List<QuestionMark> marks, String feedbackHu
});


$ExamCopyWith<$Res> get exam;

}
/// @nodoc
class _$ExamAttemptCopyWithImpl<$Res>
    implements $ExamAttemptCopyWith<$Res> {
  _$ExamAttemptCopyWithImpl(this._self, this._then);

  final ExamAttempt _self;
  final $Res Function(ExamAttempt) _then;

/// Create a copy of ExamAttempt
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? takenAt = null,Object? exam = null,Object? answers = null,Object? marks = null,Object? feedbackHu = null,}) {
  return _then(_self.copyWith(
takenAt: null == takenAt ? _self.takenAt : takenAt // ignore: cast_nullable_to_non_nullable
as DateTime,exam: null == exam ? _self.exam : exam // ignore: cast_nullable_to_non_nullable
as Exam,answers: null == answers ? _self.answers : answers // ignore: cast_nullable_to_non_nullable
as Map<String, String>,marks: null == marks ? _self.marks : marks // ignore: cast_nullable_to_non_nullable
as List<QuestionMark>,feedbackHu: null == feedbackHu ? _self.feedbackHu : feedbackHu // ignore: cast_nullable_to_non_nullable
as String,
  ));
}
/// Create a copy of ExamAttempt
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ExamCopyWith<$Res> get exam {
  
  return $ExamCopyWith<$Res>(_self.exam, (value) {
    return _then(_self.copyWith(exam: value));
  });
}
}


/// Adds pattern-matching-related methods to [ExamAttempt].
extension ExamAttemptPatterns on ExamAttempt {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ExamAttempt value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ExamAttempt() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ExamAttempt value)  $default,){
final _that = this;
switch (_that) {
case _ExamAttempt():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ExamAttempt value)?  $default,){
final _that = this;
switch (_that) {
case _ExamAttempt() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( DateTime takenAt,  Exam exam,  Map<String, String> answers,  List<QuestionMark> marks,  String feedbackHu)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ExamAttempt() when $default != null:
return $default(_that.takenAt,_that.exam,_that.answers,_that.marks,_that.feedbackHu);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( DateTime takenAt,  Exam exam,  Map<String, String> answers,  List<QuestionMark> marks,  String feedbackHu)  $default,) {final _that = this;
switch (_that) {
case _ExamAttempt():
return $default(_that.takenAt,_that.exam,_that.answers,_that.marks,_that.feedbackHu);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( DateTime takenAt,  Exam exam,  Map<String, String> answers,  List<QuestionMark> marks,  String feedbackHu)?  $default,) {final _that = this;
switch (_that) {
case _ExamAttempt() when $default != null:
return $default(_that.takenAt,_that.exam,_that.answers,_that.marks,_that.feedbackHu);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ExamAttempt extends ExamAttempt {
  const _ExamAttempt({required this.takenAt, required this.exam, final  Map<String, String> answers = const <String, String>{}, final  List<QuestionMark> marks = const <QuestionMark>[], this.feedbackHu = ''}): _answers = answers,_marks = marks,super._();
  factory _ExamAttempt.fromJson(Map<String, dynamic> json) => _$ExamAttemptFromJson(json);

@override final  DateTime takenAt;
@override final  Exam exam;
/// Question id -> the answer the student gave.
 final  Map<String, String> _answers;
/// Question id -> the answer the student gave.
@override@JsonKey() Map<String, String> get answers {
  if (_answers is EqualUnmodifiableMapView) return _answers;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_answers);
}

 final  List<QuestionMark> _marks;
@override@JsonKey() List<QuestionMark> get marks {
  if (_marks is EqualUnmodifiableListView) return _marks;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_marks);
}

@override@JsonKey() final  String feedbackHu;

/// Create a copy of ExamAttempt
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ExamAttemptCopyWith<_ExamAttempt> get copyWith => __$ExamAttemptCopyWithImpl<_ExamAttempt>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ExamAttemptToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ExamAttempt&&(identical(other.takenAt, takenAt) || other.takenAt == takenAt)&&(identical(other.exam, exam) || other.exam == exam)&&const DeepCollectionEquality().equals(other._answers, _answers)&&const DeepCollectionEquality().equals(other._marks, _marks)&&(identical(other.feedbackHu, feedbackHu) || other.feedbackHu == feedbackHu));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,takenAt,exam,const DeepCollectionEquality().hash(_answers),const DeepCollectionEquality().hash(_marks),feedbackHu);

@override
String toString() {
  return 'ExamAttempt(takenAt: $takenAt, exam: $exam, answers: $answers, marks: $marks, feedbackHu: $feedbackHu)';
}


}

/// @nodoc
abstract mixin class _$ExamAttemptCopyWith<$Res> implements $ExamAttemptCopyWith<$Res> {
  factory _$ExamAttemptCopyWith(_ExamAttempt value, $Res Function(_ExamAttempt) _then) = __$ExamAttemptCopyWithImpl;
@override @useResult
$Res call({
 DateTime takenAt, Exam exam, Map<String, String> answers, List<QuestionMark> marks, String feedbackHu
});


@override $ExamCopyWith<$Res> get exam;

}
/// @nodoc
class __$ExamAttemptCopyWithImpl<$Res>
    implements _$ExamAttemptCopyWith<$Res> {
  __$ExamAttemptCopyWithImpl(this._self, this._then);

  final _ExamAttempt _self;
  final $Res Function(_ExamAttempt) _then;

/// Create a copy of ExamAttempt
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? takenAt = null,Object? exam = null,Object? answers = null,Object? marks = null,Object? feedbackHu = null,}) {
  return _then(_ExamAttempt(
takenAt: null == takenAt ? _self.takenAt : takenAt // ignore: cast_nullable_to_non_nullable
as DateTime,exam: null == exam ? _self.exam : exam // ignore: cast_nullable_to_non_nullable
as Exam,answers: null == answers ? _self._answers : answers // ignore: cast_nullable_to_non_nullable
as Map<String, String>,marks: null == marks ? _self._marks : marks // ignore: cast_nullable_to_non_nullable
as List<QuestionMark>,feedbackHu: null == feedbackHu ? _self.feedbackHu : feedbackHu // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

/// Create a copy of ExamAttempt
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ExamCopyWith<$Res> get exam {
  
  return $ExamCopyWith<$Res>(_self.exam, (value) {
    return _then(_self.copyWith(exam: value));
  });
}
}

// dart format on
