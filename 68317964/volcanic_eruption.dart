class VolcanicEruption {
  int? id;
  String name;          // Attribute 1: ชื่อภูเขาไฟ
  String location;      // Attribute 2: สถานที่
  String eruptionDate;  // Attribute 3: วันที่ปะทุ
  int vei;              // Attribute 4: ดัชนีการระเบิด (VEI)
  String status;        // Attribute 5: สถานะ (เช่น "Ongoing", "Ended")

  VolcanicEruption({
    this.id,
    required this.name,
    required this.location,
    required this.eruptionDate,
    required this.vei,
    required this.status,
  });

  // แปลง Object เป็น Map (สำหรับ Insert/Update ลง DB)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'location': location,
      'eruptionDate': eruptionDate,
      'vei': vei,
      'status': status,
    };
  }

  // แปลง Map (ที่ได้จาก DB) เป็น Object
  factory VolcanicEruption.fromMap(Map<String, dynamic> map) {
    return VolcanicEruption(
      id: map['id'],
      name: map['name'],
      location: map['location'],
      eruptionDate: map['eruptionDate'],
      vei: map['vei'],
      status: map['status'],
    );
  }
}