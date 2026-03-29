# pack_mate

## หมายเหตุ

โปรเจกต์นี้พัฒนาเสร็จสมบูรณ์ตามขอบเขตที่กำหนด และได้ทดสอบการทำงานบน **Android** เรียบร้อยแล้ว

เนื่องจากอุปกรณ์ **macOS / Xcode** ของผู้พัฒนาเสียหาย จึงไม่สามารถ build, run และตรวจสอบการทำงานบน **iOS** ได้ภายในช่วงเวลาส่งงาน

อย่างไรก็ตาม โปรเจกต์นี้พัฒนาด้วย **Flutter** โดยคำนึงถึงโครงสร้างแบบ **cross-platform** ไว้แล้ว

## Getting Started

คำสั่งสำหรับรันโปรเจกต์ในแต่ละ environment:

### Run staging

flutter run --flavor staging -t lib/main_staging.dart


### Run production

flutter run --flavor prod -t lib/main_prod.dart
