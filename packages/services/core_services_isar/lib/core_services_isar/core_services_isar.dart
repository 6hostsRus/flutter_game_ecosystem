library core_services_isar;

// Re-export wallet base types so downstream packages importing core_services_isar
// (tests) get WalletState and walletProvider without a second import.
export 'package:core_services/core_services.dart'
    show walletProvider, WalletState, WalletNotifier;

export 'src/isar_db.dart';
export 'src/wallet_dao.dart';
export 'src/idle_dao.dart';
export 'src/idle_service_isar.dart';
export 'src/wallet_service_isar.dart';
