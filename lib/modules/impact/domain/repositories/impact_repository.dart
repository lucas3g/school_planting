import 'package:school_planting/core/domain/entities/either_of.dart';
import 'package:school_planting/core/domain/entities/failure.dart';
import '../entities/impact_entity.dart';

abstract class ImpactRepository {
  Future<EitherOf<AppFailure, ImpactEntity>> getImpactData();
}
