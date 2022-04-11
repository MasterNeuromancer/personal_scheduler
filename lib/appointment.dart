import 'package:flutter/material.dart';

class Appointment {
  String? id;
  DateTime? appointmentDate;
  TimeOfDay? appointmentTime;
  String? location;
  String? description;

  Appointment(
    this.id,
    this.appointmentDate,
    this.appointmentTime,
    this.location,
    this.description,
  );
}
