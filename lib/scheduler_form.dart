import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:personal_scheduler/appointment.dart';

class SchedulerForm extends StatefulWidget {
  const SchedulerForm({
    Key? key,
    required this.title,
    required this.appointmenIndex,
    required this.selectedAppointment,
    required this.onAddAppointment,
    required this.onEditAppointment,
    required this.onDeleteAppointment,
  }) : super(key: key);
  final String title;
  final int? appointmenIndex;
  final Appointment? selectedAppointment;
  final Function onAddAppointment;
  final Function onEditAppointment;
  final Function onDeleteAppointment;

  @override
  State<SchedulerForm> createState() => _SchedulerFormState();
}

class _SchedulerFormState extends State<SchedulerForm> {
  final TextEditingController dateInput = TextEditingController();
  final TextEditingController timeInput = TextEditingController();
  final TextEditingController descriptionInput = TextEditingController();
  Appointment appointmentBeingEdited =
      Appointment(UniqueKey().toString(), null, null, "San Diego", '');
  bool isUpdatingAppointment = false;

  @override
  void initState() {
    if (widget.selectedAppointment != null) {
      setState(() {
        appointmentBeingEdited = widget.selectedAppointment!;
      });
    }
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (widget.selectedAppointment != null) {
      setState(() {
        String formattedDate =
            DateFormat.yMMMEd().format(appointmentBeingEdited.appointmentDate!);
        TimeOfDay appointmentTime = appointmentBeingEdited.appointmentTime!;

        String formattedTime = appointmentTime.format(context);

        dateInput.text = formattedDate;
        timeInput.text = formattedTime;
        descriptionInput.text = appointmentBeingEdited.description!;
        isUpdatingAppointment = true;
      });
    }
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    dateInput.dispose();
    timeInput.dispose();
    descriptionInput.dispose();
    super.dispose();
  }

  List<DropdownMenuItem<String>> get dropdownItems {
    List<DropdownMenuItem<String>> menuItems = [
      const DropdownMenuItem(child: Text("San Diego"), value: "San Diego"),
      const DropdownMenuItem(child: Text("St. George"), value: "St. George"),
      const DropdownMenuItem(child: Text("Park City"), value: "Park City"),
      const DropdownMenuItem(child: Text("Dallas"), value: "Dallas"),
      const DropdownMenuItem(child: Text("Memphis"), value: "Memphis"),
      const DropdownMenuItem(child: Text("Orlando"), value: "Orlando"),
    ];
    return menuItems;
  }

  void _showMaterialDialog(Appointment appointmentToDelete) {
    String formattedDate =
        DateFormat.yMMMEd().format(appointmentToDelete.appointmentDate!);
    TimeOfDay appointmentTime = appointmentToDelete.appointmentTime!;

    String formattedTime = appointmentTime.format(context);

    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title:
                const Text('Are You Sure You Want to Delete this Appointment?'),
            content: IntrinsicHeight(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '$formattedDate at $formattedTime',
                    style: const TextStyle(fontSize: 16),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                      top: 8.0,
                      bottom: 8.0,
                    ),
                    child: Text(
                      appointmentToDelete.location.toString(),
                      style: const TextStyle(fontSize: 14),
                    ),
                  ),
                  Text(
                    appointmentToDelete.description.toString(),
                    style: const TextStyle(fontSize: 12),
                  ),
                ],
              ),
            ),
            actions: <Widget>[
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('Cancel')),
              TextButton(
                onPressed: () {
                  widget.onDeleteAppointment(appointmentToDelete);
                  int count = 0;
                  Navigator.of(context).popUntil((_) => count++ >= 2);
                },
                child: const Text('Delete'),
              )
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.only(
            left: 25.0,
            right: 25.0,
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Date',
                    ),
                    readOnly: true,
                    controller: dateInput,
                    onTap: () async {
                      DateTime? newDate = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(2022),
                        lastDate: DateTime(2100),
                      );

                      if (newDate == null) return;

                      String formattedDate =
                          DateFormat.yMMMEd().format(newDate);

                      setState(() {
                        appointmentBeingEdited.appointmentDate = newDate;
                        dateInput.text = formattedDate;
                      });
                    },
                  ),
                ),
                const SizedBox(
                  height: 16,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Time',
                    ),
                    readOnly: true,
                    controller: timeInput,
                    onTap: () async {
                      TimeOfDay? newTime = await showTimePicker(
                        context: context,
                        initialTime: appointmentBeingEdited.appointmentTime ??
                            TimeOfDay.now(),
                      );

                      if (newTime == null) return;

                      String formattedTime = newTime.format(context);

                      setState(() {
                        appointmentBeingEdited.appointmentTime = newTime;
                        timeInput.text = formattedTime;
                      });
                    },
                  ),
                ),
                const SizedBox(
                  height: 16,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: DropdownButtonFormField(
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Location',
                    ),
                    value: appointmentBeingEdited.location,
                    items: dropdownItems,
                    onChanged: (String? value) {
                      setState(() {
                        appointmentBeingEdited.location = value;
                      });
                    },
                  ),
                ),
                const SizedBox(
                  height: 16,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Description',
                    ),
                    maxLength: 40,
                    controller: descriptionInput,
                    onChanged: (text) {
                      setState(() {
                        appointmentBeingEdited.description = text;
                      });
                    },
                  ),
                ),
                if (isUpdatingAppointment) ...[
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SizedBox(
                      width: double.infinity,
                      height: 60,
                      child: ElevatedButton.icon(
                        onPressed: () {
                          widget.onEditAppointment(
                              appointmentBeingEdited, widget.appointmenIndex);
                          Navigator.pop(context);
                        },
                        icon: const Icon(Icons.edit),
                        label: const Text('Edit'),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                          primary: Colors.red,
                          minimumSize: const Size(
                              double.infinity, 60.0) // Background color
                          ),
                      onPressed: () async {
                        _showMaterialDialog(appointmentBeingEdited);
                      },
                      icon: const Icon(Icons.delete),
                      label: const Text('Delete'),
                    ),
                  )
                ] else ...[
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SizedBox(
                      width: double.infinity,
                      height: 60,
                      child: ElevatedButton.icon(
                        onPressed: () {
                          widget.onAddAppointment(appointmentBeingEdited);
                          Navigator.pop(context);
                        },
                        icon: const Icon(Icons.add),
                        label: const Text('Create New Appointment'),
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
