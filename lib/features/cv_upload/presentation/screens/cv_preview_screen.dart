import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

import '../../../../core/constants/app_theme.dart';
import '../../../../shared/providers/core_providers.dart';

class CvPreviewScreen extends ConsumerStatefulWidget {
  final String cvUrl;

  const CvPreviewScreen({super.key, required this.cvUrl});

  @override
  ConsumerState<CvPreviewScreen> createState() => _CvPreviewScreenState();
}

class _CvPreviewScreenState extends ConsumerState<CvPreviewScreen> {
  bool _isDownloading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        title: const Text('CV Preview'),
        actions: [
          IconButton(
            icon: _isDownloading
                ? const SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  )
                : const Icon(Icons.download_outlined),
            tooltip: 'Download',
            onPressed:
                _isDownloading || widget.cvUrl.isEmpty ? null : _downloadCv,
          ),
          const SizedBox(width: 4),
        ],
      ),
      body: widget.cvUrl.isEmpty
          ? const Center(
              child: Text(
                'No CV URL provided.',
                style: TextStyle(color: Colors.white54),
              ),
            )
          : FutureBuilder<String?>(
              future: ref.read(tokenStorageProvider).getAccessToken(),
              builder: (context, snapshot) {
                final token = snapshot.data;
                final headers = token == null || token.isEmpty
                    ? const <String, String>{}
                    : {'Authorization': 'Bearer $token'};

                return SfPdfViewer.network(
                  widget.cvUrl,
                  headers: headers,
                  onDocumentLoadFailed: (details) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content:
                            Text('Failed to load PDF: ${details.description}'),
                        backgroundColor: AppColors.error,
                      ),
                    );
                  },
                );
              },
            ),
    );
  }

  Future<void> _downloadCv() async {
    setState(() => _isDownloading = true);

    try {
      final dio = ref.read(dioClientProvider).client;
      final response = await dio.get<List<int>>(
        widget.cvUrl,
        options: Options(responseType: ResponseType.bytes),
      );

      final bytes = response.data;
      if (bytes == null || bytes.isEmpty) {
        throw Exception('Downloaded file was empty.');
      }

      final dir = await getApplicationDocumentsDirectory();
      final fileName = _fileNameFromHeaders(response) ?? 'hireops-cv.pdf';
      final file = File('${dir.path}${Platform.pathSeparator}$fileName');
      await file.writeAsBytes(bytes, flush: true);
      await OpenFilex.open(file.path);

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('CV downloaded.')),
      );
    } on Object catch (err) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Download failed: $err'),
          backgroundColor: AppColors.error,
        ),
      );
    } finally {
      if (mounted) {
        setState(() => _isDownloading = false);
      }
    }
  }

  String? _fileNameFromHeaders(Response<List<int>> response) {
    final disposition = response.headers.value('content-disposition');
    final match = disposition == null
        ? null
        : RegExp(r'filename="?([^";]+)"?').firstMatch(disposition);
    final rawName = match?.group(1);
    if (rawName == null || rawName.trim().isEmpty) {
      return null;
    }

    return rawName.replaceAll(RegExp(r'[\\/:*?"<>|]'), '_');
  }
}
