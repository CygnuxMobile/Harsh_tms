enum Environments { harsh }

abstract class AppEnvironments {
  static late String baseurl;
  static late String title;
  static late String version;
  static late Environments environments;
  static List<String> dashBordList = <String>[];
  static Environments get _environments => environments;

  ///this method is change flavor
  static setupEvm(Environments evm) {
    environments = evm;
    switch (evm) {
      case Environments.harsh:
        // Flavor-specific configuration for Harsh
        title = "Harsh";
        baseurl = "https://harshtmsapi.cygnux.in/";
        // baseurl = "https://tmsapi.cygnux.in/";///test

        ///live
        // baseurl = "http://103.232.124.146:44397/";///test

        ///Harsh live.
        version = 'v 25.06.26';
        dashBordList = [
          'quickDocket',
          // 'gcn',
          // 'manifest',
          // "manifestWithoutScening",
          // "thcWithoutScening",
          // "stockUpdateWithoutScening",
          // "arrivalWithoutScening",
          // "thc",
          // 'arrival',
          // 'stockUpdate',
          // 'pod',
          // 'unloadingSheet',
          // 'attendance',
          // 'tracking',
          'drs',
          // 'prq'
        ];
        break;
    }
  }
}
