import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:task_manager/models/task.dart';

class TaskFormScreen extends StatefulWidget {
  final Task? task;

  const TaskFormScreen({Key? key, this.task}) : super(key: key);

  @override
  _TaskFormScreenState createState() => _TaskFormScreenState();
}

class _TaskFormScreenState extends State<TaskFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late String _name;
  late DateTime _dateTime;
  late double _latitude;
  late double _longitude;
  late String _location = "Localização não disponível";

  @override
  void initState() {
    super.initState();
    if (widget.task != null) {
      _name = widget.task!.name;
      _dateTime = widget.task!.dateTime;
      _latitude = widget.task!.latitude;
      _longitude = widget.task!.longitude;
    } else {
      _name = '';
      _dateTime = DateTime.now();
      _latitude = 0.0;
      _longitude = 0.0;
    }
  }

  Future<void> _getCurrentLocation() async {
    try {
      bool serviceEnabled;
      LocationPermission permission;

      // Testa se o serviço de localização está habilitado
      serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        setState(() {
          _location = "Serviço de localização desabilitado";
        });
        return;
      }

      // Verifica as permissões de localização
      permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          setState(() {
            _location = "Permissão de localização negada";
          });
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        setState(() {
          _location = "Permissão de localização negada permanentemente";
        });
        return;
      }

      // Obtém a localização atual
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      setState(() {
        _latitude = position.latitude;
        _longitude = position.longitude;
      });

      // Geocoding para obter o endereço a partir das coordenadas
      List<Placemark> placemarks = await placemarkFromCoordinates(
        _latitude,
        _longitude,
      );
      if (placemarks.isNotEmpty) {
        Placemark place = placemarks[0];
        setState(() {
          _location = "${place.locality}, ${place.administrativeArea}, ${place.country}";
        });
      } else {
        setState(() {
          _location = "Localização não encontrada";
        });
      }
    } catch (e) {
      setState(() {
        _location = "Erro ao obter localização";
      });
      print(e);
    }
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      final task = Task(
        name: _name,
        dateTime: _dateTime,
        latitude: _latitude,
        longitude: _longitude,
      );
      Navigator.of(context).pop(task);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.task != null ? 'Editar Tarefa' : 'Nova Tarefa'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                initialValue: _name,
                decoration: const InputDecoration(labelText: 'Nome da Tarefa'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Digite o nome de uma tarefa';
                  }
                  return null;
                },
                onSaved: (value) {
                  _name = value!;
                },
              ),
              TextFormField(
                initialValue: '' ,//_dateTime.toString(),
                decoration: const InputDecoration(labelText: 'Data e Hora'),
                readOnly: true,
                onTap: () async {
                  final selectedDate = await showDatePicker(
                    context: context,
                    initialDate: _dateTime,
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2101),
                  );

                  if (selectedDate != null) {
                    final selectedTime = await showTimePicker(
                      context: context,
                      initialTime: TimeOfDay.fromDateTime(_dateTime),
                    );

                    if (selectedTime != null) {
                      setState(() {
                        _dateTime = DateTime(
                          selectedDate.year,
                          selectedDate.month,
                          selectedDate.day,
                          selectedTime.hour,
                          selectedTime.minute,
                          
                          
                        );
                      });
                    }
                  }
                },
              ),
              SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: _getCurrentLocation,
                child: Text('Capturar localização atual'),
              ),
              SizedBox(height: 16.0),
              Text('Latitude: $_latitude'),
              Text('Longitude: $_longitude'),
              Text('Localização: $_location'),
              SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: _submit,
                child: Text('Salvar Tarefa'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
