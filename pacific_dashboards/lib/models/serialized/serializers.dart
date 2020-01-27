import 'package:built_value/serializer.dart';
import 'package:built_collection/built_collection.dart';
import 'package:built_value/standard_json_plugin.dart';
import 'package:pacific_dashboards/models/emis_config/emis_config.dart';
import 'package:pacific_dashboards/models/emis_config/emises_config.dart';
import 'package:pacific_dashboards/models/emis_config/module_config.dart';
import 'package:pacific_dashboards/models/lookups/lookup.dart';
import 'package:pacific_dashboards/models/lookups/lookups.dart';

part 'serializers.g.dart';

//add all of the built value types that require serialization
@SerializersFor([
  EmisesConfig,
  EmisConfig,
  ModuleConfig,
  Lookup,
  Lookups
])
final Serializers serializers = _$serializers;

final Serializers standardSerializers =
    (serializers.toBuilder()..addPlugin(StandardJsonPlugin())).build();
