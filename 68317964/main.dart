import 'package:flutter/material.dart';
import 'database_helper.dart';
import 'volcanic_eruption.dart';

void main() {

  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Volcano DB Test',
      home: HomePage()
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  
  final dbHelper = DatabaseHelper.instance;

  void _addNewEruption() async {
    print('--- กำลังเพิ่มข้อมูล ---');
    VolcanicEruption newEruption = VolcanicEruption(
      name: "Mauna Loa",
      location: "Hawaii, USA",
      eruptionDate: "2022-11-27",
      vei: 3,
      status: "Ended",
    );

    final id = await dbHelper.insert(newEruption);
    print('เพิ่มข้อมูลการปะทุ ID: $id สำเร็จ');
  }

  void _loadAllEruptions() async {
    print('--- กำลังอ่านข้อมูลทั้งหมด ---');
    final allEruptions = await dbHelper.queryAllEruptions();

    if (allEruptions.isEmpty) {
      print('ไม่พบข้อมูลในฐานข้อมูล');
      return;
    }

    print('พบข้อมูล ${allEruptions.length} รายการ:');
    for (var eruption in allEruptions) {
      print('ID ${eruption.id}: ${eruption.name} (${eruption.location}) - สถานะ: ${eruption.status}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ทดสอบฐานข้อมูลภูเขาไฟ'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: _addNewEruption,
              child: const Text('1. เพิ่มข้อมูล (Add Eruption)'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _loadAllEruptions,
              child: const Text('2. อ่านข้อมูลทั้งหมด (Load Eruptions)'),
            ),
          ],
        ),
      ),
    );
  }
}