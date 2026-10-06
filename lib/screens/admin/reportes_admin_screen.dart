import 'package:file_saver/file_saver.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../models/usuario.dart';
import '../../providers/auth_provider.dart';
import '../../services/report_service.dart';

class ReportesAdminScreen extends ConsumerStatefulWidget {
  const ReportesAdminScreen({super.key});

  @override
  ConsumerState<ReportesAdminScreen> createState() =>
      _ReportesAdminScreenState();
}

class _ReportesAdminScreenState extends ConsumerState<ReportesAdminScreen> {
  final _reportService = ReportService();
  late final TextEditingController _yearController;
  late int _quarter;
  bool _downloading = false;

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    _yearController = TextEditingController(text: '${now.year}');
    _quarter = ((now.month - 1) ~/ 3) + 1;
  }

  @override
  void dispose() {
    _yearController.dispose();
    super.dispose();
  }

  Future<void> _downloadReport() async {
    final year = int.tryParse(_yearController.text);
    if (year == null || year < 1 || year > 9998) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Ingresa un año entre 1 y 9998.')),
      );
      return;
    }

    setState(() => _downloading = true);
    try {
      final bytes = await _reportService.downloadQuarterlyReport(
        year: year,
        quarter: _quarter,
      );
      final filename = 'reporte_trimestral_${year}_T$_quarter';
      final savedPath = await FileSaver.instance.saveAs(
        name: filename,
        bytes: bytes,
        fileExtension: 'xlsx',
        mimeType: MimeType.microsoftExcel,
        dialogTitle: 'Guardar reporte trimestral',
      );
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            savedPath == null
                ? 'Descarga cancelada.'
                : 'Reporte guardado: $filename.xlsx',
          ),
        ),
      );
    } catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('No se pudo descargar el reporte: $error')),
      );
    } finally {
      if (mounted) setState(() => _downloading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isAdmin = ref.watch(authProvider).role == AppRole.admin;
    if (!isAdmin) {
      return const Center(
          child: Text('Solo un administrador puede generar reportes.'));
    }

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Card(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Reportes trimestrales',
                    style: Theme.of(context).textTheme.headlineSmall),
                const SizedBox(height: 8),
                const Text(
                  'Descarga un Excel con el resumen, el historial de cambios y los registros disponibles del período.',
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: _yearController,
                  enabled: !_downloading,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Año',
                    hintText: 'Por ejemplo, 2027',
                  ),
                ),
                const SizedBox(height: 12),
                DropdownButtonFormField<int>(
                  value: _quarter,
                  decoration: const InputDecoration(labelText: 'Trimestre'),
                  items: const [
                    DropdownMenuItem(value: 1, child: Text('T1 · Enero–marzo')),
                    DropdownMenuItem(value: 2, child: Text('T2 · Abril–junio')),
                    DropdownMenuItem(
                        value: 3, child: Text('T3 · Julio–septiembre')),
                    DropdownMenuItem(
                        value: 4, child: Text('T4 · Octubre–diciembre')),
                  ],
                  onChanged: _downloading
                      ? null
                      : (quarter) {
                          if (quarter != null)
                            setState(() => _quarter = quarter);
                        },
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton.icon(
                    onPressed: _downloading ? null : _downloadReport,
                    icon: _downloading
                        ? const SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Icon(Icons.download),
                    label: Text(_downloading
                        ? 'Generando reporte...'
                        : 'Descargar Excel'),
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  'El historial detallado empieza desde la instalación de la auditoría. '
                  'Los registros anteriores usan las fechas disponibles en la base de datos.',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
