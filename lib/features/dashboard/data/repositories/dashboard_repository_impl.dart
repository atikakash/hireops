import 'package:hireops/core/errors/app_exception_utils.dart';
import 'package:hireops/core/errors/failures.dart';
import 'package:hireops/features/dashboard/data/datasources/dashboard_remote_datasource.dart';
import 'package:hireops/features/dashboard/data/models/dashboard_model.dart';
import 'package:hireops/features/dashboard/domain/entities/dashboard_entity.dart';
import 'package:hireops/features/dashboard/domain/repositories/dashboard_repository.dart';

class DashboardRepositoryImpl implements DashboardRepository {
  final DashboardRemoteDataSource _ds;
  const DashboardRepositoryImpl(this._ds);

  @override
  Future<(DashboardStats?, Failure?)> getStats() async {
    try {
      final model = await _ds.getStats();
      return (model.toEntity(), null);
    } on AppException catch (e) {
      return (null, _map(e));
    } on Object catch (e) {
      final appException = extractAppException(e);
      if (appException != null) {
        return (null, _map(appException));
      }
      return (null, Failure.unknown(message: e.toString()));
    }
  }

  @override
  Future<(List<RecentActivityItem>, Failure?)> getRecentActivity() async {
    try {
      final models = await _ds.getRecentActivity();
      return (models.map((m) => m.toEntity()).toList(), null);
    } on AppException catch (e) {
      return (<RecentActivityItem>[], _map(e));
    } on Object catch (e) {
      final appException = extractAppException(e);
      if (appException != null) {
        return (<RecentActivityItem>[], _map(appException));
      }
      return (
        <RecentActivityItem>[],
        Failure.unknown(message: e.toString()),
      );
    }
  }

  Failure _map(AppException e) => switch (e.statusCode) {
        401 => const Failure.unauthorized(),
        _ => e is NoInternetException
            ? Failure.noInternet(message: e.message)
            : Failure.network(message: e.message),
      };
}
