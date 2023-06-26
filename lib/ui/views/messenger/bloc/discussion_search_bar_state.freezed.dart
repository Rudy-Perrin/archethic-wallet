// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'discussion_search_bar_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
mixin _$DiscussionSearchBarState {
  String get searchCriteria => throw _privateConstructorUsedError;
  bool get loading => throw _privateConstructorUsedError;
  String get error => throw _privateConstructorUsedError;
  Talk? get talk => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $DiscussionSearchBarStateCopyWith<DiscussionSearchBarState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DiscussionSearchBarStateCopyWith<$Res> {
  factory $DiscussionSearchBarStateCopyWith(DiscussionSearchBarState value,
          $Res Function(DiscussionSearchBarState) then) =
      _$DiscussionSearchBarStateCopyWithImpl<$Res, DiscussionSearchBarState>;
  @useResult
  $Res call({String searchCriteria, bool loading, String error, Talk? talk});

  $TalkCopyWith<$Res>? get talk;
}

/// @nodoc
class _$DiscussionSearchBarStateCopyWithImpl<$Res,
        $Val extends DiscussionSearchBarState>
    implements $DiscussionSearchBarStateCopyWith<$Res> {
  _$DiscussionSearchBarStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? searchCriteria = null,
    Object? loading = null,
    Object? error = null,
    Object? talk = freezed,
  }) {
    return _then(_value.copyWith(
      searchCriteria: null == searchCriteria
          ? _value.searchCriteria
          : searchCriteria // ignore: cast_nullable_to_non_nullable
              as String,
      loading: null == loading
          ? _value.loading
          : loading // ignore: cast_nullable_to_non_nullable
              as bool,
      error: null == error
          ? _value.error
          : error // ignore: cast_nullable_to_non_nullable
              as String,
      talk: freezed == talk
          ? _value.talk
          : talk // ignore: cast_nullable_to_non_nullable
              as Talk?,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $TalkCopyWith<$Res>? get talk {
    if (_value.talk == null) {
      return null;
    }

    return $TalkCopyWith<$Res>(_value.talk!, (value) {
      return _then(_value.copyWith(talk: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$_DiscussionSearchBarStateCopyWith<$Res>
    implements $DiscussionSearchBarStateCopyWith<$Res> {
  factory _$$_DiscussionSearchBarStateCopyWith(
          _$_DiscussionSearchBarState value,
          $Res Function(_$_DiscussionSearchBarState) then) =
      __$$_DiscussionSearchBarStateCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String searchCriteria, bool loading, String error, Talk? talk});

  @override
  $TalkCopyWith<$Res>? get talk;
}

/// @nodoc
class __$$_DiscussionSearchBarStateCopyWithImpl<$Res>
    extends _$DiscussionSearchBarStateCopyWithImpl<$Res,
        _$_DiscussionSearchBarState>
    implements _$$_DiscussionSearchBarStateCopyWith<$Res> {
  __$$_DiscussionSearchBarStateCopyWithImpl(_$_DiscussionSearchBarState _value,
      $Res Function(_$_DiscussionSearchBarState) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? searchCriteria = null,
    Object? loading = null,
    Object? error = null,
    Object? talk = freezed,
  }) {
    return _then(_$_DiscussionSearchBarState(
      searchCriteria: null == searchCriteria
          ? _value.searchCriteria
          : searchCriteria // ignore: cast_nullable_to_non_nullable
              as String,
      loading: null == loading
          ? _value.loading
          : loading // ignore: cast_nullable_to_non_nullable
              as bool,
      error: null == error
          ? _value.error
          : error // ignore: cast_nullable_to_non_nullable
              as String,
      talk: freezed == talk
          ? _value.talk
          : talk // ignore: cast_nullable_to_non_nullable
              as Talk?,
    ));
  }
}

/// @nodoc

class _$_DiscussionSearchBarState extends _DiscussionSearchBarState {
  const _$_DiscussionSearchBarState(
      {this.searchCriteria = '',
      this.loading = false,
      this.error = '',
      this.talk})
      : super._();

  @override
  @JsonKey()
  final String searchCriteria;
  @override
  @JsonKey()
  final bool loading;
  @override
  @JsonKey()
  final String error;
  @override
  final Talk? talk;

  @override
  String toString() {
    return 'DiscussionSearchBarState(searchCriteria: $searchCriteria, loading: $loading, error: $error, talk: $talk)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_DiscussionSearchBarState &&
            (identical(other.searchCriteria, searchCriteria) ||
                other.searchCriteria == searchCriteria) &&
            (identical(other.loading, loading) || other.loading == loading) &&
            (identical(other.error, error) || other.error == error) &&
            (identical(other.talk, talk) || other.talk == talk));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, searchCriteria, loading, error, talk);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_DiscussionSearchBarStateCopyWith<_$_DiscussionSearchBarState>
      get copyWith => __$$_DiscussionSearchBarStateCopyWithImpl<
          _$_DiscussionSearchBarState>(this, _$identity);
}

abstract class _DiscussionSearchBarState extends DiscussionSearchBarState {
  const factory _DiscussionSearchBarState(
      {final String searchCriteria,
      final bool loading,
      final String error,
      final Talk? talk}) = _$_DiscussionSearchBarState;
  const _DiscussionSearchBarState._() : super._();

  @override
  String get searchCriteria;
  @override
  bool get loading;
  @override
  String get error;
  @override
  Talk? get talk;
  @override
  @JsonKey(ignore: true)
  _$$_DiscussionSearchBarStateCopyWith<_$_DiscussionSearchBarState>
      get copyWith => throw _privateConstructorUsedError;
}