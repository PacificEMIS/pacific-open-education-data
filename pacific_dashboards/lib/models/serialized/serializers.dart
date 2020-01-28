import 'package:built_value/serializer.dart';
import 'package:built_collection/built_collection.dart';
import 'package:built_value/standard_json_plugin.dart';
import 'package:pacific_dashboards/models/emis_config/emis_config.dart';
import 'package:pacific_dashboards/models/emis_config/emises_config.dart';
import 'package:pacific_dashboards/models/emis_config/module_config.dart';
import 'package:pacific_dashboards/models/lookups/lookup.dart';
import 'package:pacific_dashboards/models/lookups/lookups.dart';
import 'package:pacific_dashboards/models/school/school.dart';

part 'serializers.g.dart';

//add all of the built value types that require serialization
@SerializersFor([
  EmisesConfig,
  EmisConfig,
  ModuleConfig,
  Lookup,
  Lookups,
  School,
])
final Serializers serializers = (_$serializers.toBuilder()
      ..addPlugin(StandardJsonPlugin())
      ..addBuilderFactory(
        const FullType(BuiltList, const [const FullType(School)]),
        () => ListBuilder<School>(),
      ))
    .build();
