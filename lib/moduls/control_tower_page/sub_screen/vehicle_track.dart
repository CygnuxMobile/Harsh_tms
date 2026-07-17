import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../model/control_tower_model/control_tower_response.dart';

class VehicleTrackScreen extends StatelessWidget {
  final ControlTower data;

  const VehicleTrackScreen({super.key, required this.data});

  String formatData(ControlTower data) {
    return ''' 
 🚚 Vehicle: ${data.vehno} | Zone: ${data.vehicleArea} 
 🚘 Model: ${data.vehicleModel} 
 🏭 Make: ${data.vehicleMake} 
 📄 Doc No: ${data.docNo} 
 📅 Date: ${data.docDt} 
 🧭 Trip No: ${data.tripNo} 
 📍 Lat/Long: ${data.latitude} / ${data.longitude} 
 📌 Status: ${data.vMainStatus} 
 📍 Sub Stage: ${data.vMainStatus} 
 ⏱ Last Update: ${data.statusUpdatedDate} 
 🕓 ETA: ${data.eta} 
 🕓 STA: ${data.sta} 
 📏 Pending KM: ${data.pendingKm} 
 🚦 Running Status: ${data.runningStatus} 
 🏢 Billing Party: ${data.billingParty}
 🔁 From-To: ${data.fromToCity} 
 📦 EWB No: ${data.ewbno} 
 ⏳ Expiry: ${data.eWayBillExpiredDate} 
 📍 Near Branch: ${data.location} 
 📏 Distance: "${data.distance}KM" 
 👨 Driver: ${data.driverName} 
 📞 Mobile: ${data.driverMobile} 
    ''';
  }

  void copyData(BuildContext context) {
    Clipboard.setData(ClipboardData(text: formatData(data)));
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Copied to clipboard")));
  }

  Widget rowItem(String title, String value, {bool isPhone = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          SizedBox(
            width: 130,
            child: Text(
              title,
              style: const TextStyle(color: Colors.grey, fontWeight: FontWeight.w500),
            ),
          ),
          const Text(": "),
          Expanded(
            child: isPhone
                ? InkWell(
                    onTap: () async {
                      try {
                        final Uri launchUri = Uri(scheme: 'tel', path: value);
                        await launchUrl(launchUri, mode: LaunchMode.externalApplication);
                      } catch (e) {
                        debugPrint("Error launching dialer: $e");
                        Get.snackbar("Error", "Plugin error. Please stop and RE-RUN the app.");
                      }
                    },
                    child: Text(
                      value,
                      style: const TextStyle(fontWeight: FontWeight.w600, color: Colors.blue, decoration: TextDecoration.underline),
                    ),
                  )
                : Text(value, style: const TextStyle(fontWeight: FontWeight.w600)),
          ),
        ],
      ),
    );
  }

  Widget section(String title, List<Widget> children) {
    return Container(
      margin: const EdgeInsets.only(bottom: 18),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [BoxShadow(color: Colors.grey.withOpacity(.15), blurRadius: 8)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black87),
          ),
          const Divider(height: 20),
          ...children,
        ],
      ),
    );
  }

  Widget vehicleHeader() {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: const LinearGradient(colors: [Color(0xff232F34), Color(0xff3A4F55)]),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          const Icon(Icons.local_shipping, color: Colors.white, size: 40),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  data.vehno,
                  style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Text(data.vehicleModel, style: const TextStyle(color: Colors.white70)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF3F5F7),

      appBar: AppBar(
        backgroundColor: const Color(0xff232F34),
        title: const Text("Vehicle Tracking", style: TextStyle(color: Colors.white)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Get.back(),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.copy, color: Colors.white),
            onPressed: () => copyData(context),
          ),
        ],
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(14),
        child: Column(
          children: [
            /// Header
            vehicleHeader(),

            const SizedBox(height: 18),

            /// Vehicle Info
            section("Vehicle Info", [
              rowItem("Zone", data.vehicleArea),
              rowItem("Model", data.vehicleModel),
              rowItem("Make", data.vehicleMake),
              rowItem("Doc No", data.docNo),
              rowItem("Trip No", data.tripNo),
            ]),

            /// Status
            section("Trip Status", [
              rowItem("Main Status", data.vMainStatus),
              rowItem("Last Update", data.statusUpdatedDate),
              rowItem("ETA", data.eta),
              rowItem("STA", data.sta),
              rowItem("Pending KM", "${data.pendingKm} KM"),
            ]),

            /// Location
            section("Location", [
              rowItem("From - To", "${data.fromLoc}-${data.toLoc}"),
              rowItem("Near Branch", data.nearBranch),
              rowItem("Address", data.location),
              rowItem("Distance", "${data.distance ?? 0} KM"),
              rowItem("Lat / Long", "${data.latitude} / ${data.longitude}"),
            ]),

            /// Driver
            section("Driver", [rowItem("Driver Name", data.driverName), rowItem("Mobile", data.driverMobile, isPhone: true)]),
          ],
        ),
      ),
    );
  }
}
