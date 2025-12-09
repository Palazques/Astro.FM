import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

/// A small widget that polls a backend `/status` endpoint and shows
/// a simple connected / disconnected indicator.
///
/// Usage:
/// ```dart
/// BackendStatus(url: 'http://10.0.2.2:7777/status')
/// ```
class BackendStatus extends StatefulWidget {
  final String url;
  final Duration interval;

  const BackendStatus({Key? key, required this.url, this.interval = const Duration(seconds: 3)}) : super(key: key);

  @override
  State<BackendStatus> createState() => _BackendStatusState();
}

class _BackendStatusState extends State<BackendStatus> {
  Timer? _timer;
  bool _connected = false;
  String _lastChecked = '';

  @override
  void initState() {
    super.initState();
    _check();
    _timer = Timer.periodic(widget.interval, (_) => _check());
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  Future<void> _check() async {
    try {
      final r = await http.get(Uri.parse(widget.url)).timeout(const Duration(seconds: 2));
      if (r.statusCode == 200) {
        final data = jsonDecode(r.body);
        final ok = data is Map && data['connected'] == true;
        setState(() {
          _connected = ok;
          _lastChecked = DateTime.now().toLocal().toIso8601String();
        });
        return;
      }
    } catch (_) {
      // ignore, mark disconnected below
    }
    if (mounted) {
      setState(() {
        _connected = false;
        _lastChecked = DateTime.now().toLocal().toIso8601String();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final color = _connected ? Colors.green : Colors.red;
    final icon = _connected ? Icons.cloud_done : Icons.cloud_off;
    final label = _connected ? 'Backend: Connected' : 'Backend: Disconnected';

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: color),
        const SizedBox(width: 8),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: Theme.of(context).textTheme.bodyMedium),
            if (_lastChecked.isNotEmpty) Text('Last: $_lastChecked', style: Theme.of(context).textTheme.bodySmall),
          ],
        ),
      ],
    );
  }
}
