/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: implementation_imports
// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: public_member_api_docs
// ignore_for_file: type_literal_in_constant_pattern
// ignore_for_file: use_super_parameters
// ignore_for_file: invalid_use_of_internal_member

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod/serverpod.dart' as _is;

/// The walker's own result from the official PAR-Q+ (eparmedx.com): none
/// of the 7 general health questions apply, or some do.
enum ScreeningResult implements _is.SerializableModel {
  noneApply,
  someApply;

  static ScreeningResult fromJson(String name) {
    switch (name) {
      case 'noneApply':
        return ScreeningResult.noneApply;
      case 'someApply':
        return ScreeningResult.someApply;
      default:
        throw ArgumentError(
          'Value "$name" cannot be converted to "ScreeningResult"',
        );
    }
  }

  @override
  String toJson() => name;

  @override
  String toString() => name;
}
