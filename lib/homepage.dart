// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:personal_scheduler/appointment.dart';
import 'package:personal_scheduler/scheduler_form.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<Appointment> appointments = [];

  void addAppointment(Appointment appointment) {
    setState(() {
      appointments.add(appointment);
    });
  }

  void editAppointment(Appointment appointment, int index) {
    setState(() {
      appointments[index] = appointment;
    });
  }

  void deleteAppointment(Appointment appointment) {
    setState(() {
      appointments.removeWhere((element) => element.id == appointment.id);
    });
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
                  deleteAppointment(appointmentToDelete);
                  Navigator.pop(context);
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
        centerTitle: true,
      ),
      body: Column(
        children: [
          const Divider(),
          Expanded(
            child: ListView.separated(
              itemCount: appointments.length,
              itemBuilder: ((context, index) {
                String formattedDate = DateFormat.yMMMEd()
                    .format(appointments[index].appointmentDate!);
                TimeOfDay appointmentTime =
                    appointments[index].appointmentTime!;

                String formattedTime = appointmentTime.format(context);

                return InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SchedulerForm(
                          selectedAppointment: appointments[index],
                          onAddAppointment: addAppointment,
                          onDeleteAppointment: deleteAppointment,
                          onEditAppointment: editAppointment,
                          title: 'Personal Scheduler',
                          appointmenIndex: index,
                        ),
                      ),
                    );
                  },
                  child: Card(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            const Padding(
                              padding: EdgeInsets.only(left: 16.0, right: 16.0),
                              child: Icon(
                                Icons.calendar_today_rounded,
                                color: Colors.blue,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                  top: 25.0, bottom: 25.0),
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
                                      appointments[index].location.toString(),
                                      style: const TextStyle(fontSize: 14),
                                    ),
                                  ),
                                  Text(
                                    appointments[index].description.toString(),
                                    style: const TextStyle(fontSize: 12),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            IconButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => SchedulerForm(
                                      selectedAppointment: appointments[index],
                                      onAddAppointment: addAppointment,
                                      onDeleteAppointment: deleteAppointment,
                                      onEditAppointment: editAppointment,
                                      title: 'Personal Scheduler',
                                      appointmenIndex: index,
                                    ),
                                  ),
                                );
                              },
                              icon: const Icon(
                                Icons.edit,
                                color: Colors.grey,
                              ),
                              tooltip: 'Edit Appointment',
                            ),
                            IconButton(
                              onPressed: () {
                                // deleteAppointment(appointments[index]);
                                _showMaterialDialog(appointments[index]);
                              },
                              icon: const Icon(
                                Icons.delete,
                                color: Colors.red,
                              ),
                              tooltip: 'Delete Appointment',
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                );
              }),
              separatorBuilder: (BuildContext context, int index) =>
                  const Divider(),
            ),
          ),
          const Divider(),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: SizedBox(
              width: double.infinity,
              height: 75,
              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SchedulerForm(
                          onAddAppointment: addAppointment,
                          onDeleteAppointment: deleteAppointment,
                          onEditAppointment: editAppointment,
                          title: 'Personal Scheduler',
                          selectedAppointment: null,
                          appointmenIndex: null,
                        ),
                      ));
                },
                icon: const Icon(Icons.add),
                label: const Text('Add New Appointment'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
