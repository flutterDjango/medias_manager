import 'package:flutter/material.dart';
import 'package:medias_manager/utils/utils.dart';

class DialogTimeFormWidget extends StatefulWidget {
  const DialogTimeFormWidget({super.key, required this.title});

  final String title;

  @override
  State<DialogTimeFormWidget> createState() => _DialogTimeFormWidgetState();
}

class _DialogTimeFormWidgetState extends State<DialogTimeFormWidget> {
  final TextEditingController _hourController = TextEditingController();
  final TextEditingController _minuteController = TextEditingController();
  final TextEditingController _secondeController = TextEditingController();

  String _duration = "00:00:00";
  final _formGlobalKey = GlobalKey<FormState>();
  // @override
  // void initState() {
  //   super.initState();
  //   _hourController.text = '00';

  // }

  @override
  void dispose() {
    _hourController.dispose();
    _minuteController.dispose();
    _secondeController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.title),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(10.0)),
      ),
      contentPadding: const EdgeInsets.all(20.0),
      content: SizedBox(
        width: 100,
        height: MediaQuery.of(context).size.height * 0.35,
        child: Form(
          key: _formGlobalKey,
          child: Column(
            children: [
              TextFormField(
                autofocus: true,
                controller: _hourController,
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: false),
                decoration: const InputDecoration(
                  label: Text('Heure'),
                ),
                onChanged: (value) {
                  setState(
                    () {
                      _duration =
                          "${_hourController.text}:${_minuteController.text}:${_minuteController.text}";
                    },
                  );
                },
                validator: (value) {
                  return Helpers.validTimeField(value);
                },
                onSaved: (value) {
                  _duration = calculDuration(_hourController.text,
                      _minuteController.text, _secondeController.text);
                },
              ),
              TextFormField(
                autofocus: true,
                controller: _minuteController,
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: false),
                decoration: const InputDecoration(label: Text('Minute')),
                onChanged: (value) {
                  setState(
                    () {
                      _duration =
                          "${_hourController.text}:${_minuteController.text}:${_secondeController.text}";
                    },
                  );
                },
                validator: (value) {
                  return Helpers.validTimeField(value);
                },
                onSaved: (value) {
                  _duration = calculDuration(_hourController.text,
                      _minuteController.text, _secondeController.text);
                },
              ),
              TextFormField(
                // autofocus: true,
                controller: _secondeController,
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: false),
                decoration: const InputDecoration(label: Text('Seconde')),
                onChanged: (value) {
                  setState(
                    () {
                      _duration =
                          "${_hourController.text}:${_minuteController.text}:${_secondeController.text}";
                    },
                  );
                },
                validator: (value) {
                  return Helpers.validTimeField(value);
                },
                onSaved: (value) {
                  _duration = calculDuration(_hourController.text,
                      _minuteController.text, _secondeController.text);
                },
              ),
              const SizedBox(
                height: 20,
              ),
              Text(
                "${widget.title.split(" ").first}: ${calculDuration(_hourController.text, _minuteController.text, _secondeController.text)}",
              ),
            ],
          ),
        ),
      ),
      actions: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _hourController.clear();
                _minuteController.clear();
                _secondeController.clear();
              },
              child: const Text('Annuler'),
            ),
            TextButton(
              onPressed: () {
                if (_formGlobalKey.currentState!.validate()) {
                  _formGlobalKey.currentState!.save();
                  debugPrint('_duration $_duration');
                  Navigator.of(context).pop(_duration);
                  _hourController.clear();
                  _minuteController.clear();
                  _secondeController.clear();
                }
              },
              child: const Text('Valider'),
            ),
          ],
        ),
      ],
    );
  }

  String calculDuration(h, m, s) {
    if (h.isEmpty) {
      h = '00';
    }
    if (m.isEmpty) {
      m = '00';
    }
    if (s.isEmpty) {
      s = '00';
    }
    if (h.length < 2) {
      h = '0$h';
    }
    if (m.length < 2) {
      m = '0$m';
    }
    if (s.length < 2) {
      s = '0$s';
    }
    return "$h:$m:$s";

    // return '00:00:00';
  }
}
